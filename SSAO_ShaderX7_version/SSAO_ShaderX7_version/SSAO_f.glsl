uniform sampler2D rnm; //Random normal map 
uniform sampler2D normalMap; //Texture storing normal and depth of the scene

varying vec2 uv;
uniform vec2 screenSize = vec2(800.0, 800.0);
uniform float farClipDist = 1.0;

float fRangeIsInvalid;

void main(void)
{
	vec2 screenTC = uv.xy;
	
	//create rotation vector
	vec2 rotationTC = screenTC * screenSize / 64;
	//vec3 vRotation = (2*texture2D(rnm, rotationTC).rgb - 1);
	vec3 vRotation = (2*texture2D(rnm, vec2(1.0/64.0)).rgb - 1);

	//Create rotation matrix from rotation vector
	mat3 rotMat;
	float h = 1 / (1+vRotation.z);
	rotMat[0][0] = h*vRotation.y*vRotation.y + vRotation.z;
	rotMat[0][1] = -h*vRotation.y*vRotation.x;
	rotMat[0][2] = -vRotation.x;
	rotMat[1][0] = -h*vRotation.y*vRotation.x;
	rotMat[1][1] = h*vRotation.x*vRotation.x + vRotation.z;
	rotMat[1][2] = -vRotation.y;
	rotMat[2][0] = vRotation.x;
	rotMat[2][1] = vRotation.y;
	rotMat[2][2] = vRotation.z;

	//get depth of current pixel and convert into meters
	float fSceneDepthP = texture2D(normalMap, screenTC).a * farClipDist;
	
	//parameters affecting offset points number and distribution
	const int nSamplesNum = 16;
	float offsetScale = 0.01;
	const float offsetScaleStep = 1 + 2.4/nSamplesNum;

	float Accessibility  = 0.0;



	//sample area and accumulate accessibility
	float radius = 0.5;
	for(int i = 0 ; i < 2; i++)
	for(float x = -radius; x <= radius; x+=2*radius)
	for(float y = -radius; y <= radius; y+=2*radius)
	for(float z = -radius; z <= radius; z+=2*radius)
	{
		//generate offset vector
		//vec3 vOffset = normalize(vec3(x,y,z))* ( offsetScale *= offsetScaleStep );
		vec3 vOffset = vec3(x,y,z)* ( offsetScale *= offsetScaleStep );


		//rotate offset vector by rotation
		vec3 vRotatedOffset = rotMat * vOffset;
		//vec3 vRotatedOffset = vOffset;

		//get center pixel 3d coordinates in screen space
		vec3 vSamplePos = vec3(screenTC, fSceneDepthP );

		//Shift coordinates by offset vector ( range convert and width depth value)
		vSamplePos += vec3( vRotatedOffset.xy, vRotatedOffset.z * fSceneDepthP * 2);

		//read scene depth at sampling point and convert into meters
		float fSceneDepthS = texture2D( normalMap, vSamplePos.xy).a * farClipDist;

		//Check if depths of both pixels are close enough and sampling point should affect our center pixel
		fRangeIsInvalid = clamp(( (fSceneDepthP - fSceneDepthS)/fSceneDepthS ),0.0,1.0);
	
		//accumulate accessibility, use default value of 0.5 if right computations are not possible
		if(fSceneDepthS > vSamplePos.z) //Sample point is outside geometry
			Accessibility += 0.5 +0.5*(1-fRangeIsInvalid);
		else //Sample point is inside geometry 
			Accessibility += 0.5*fRangeIsInvalid;

		//if(fSceneDepthS <= vSamplePos.z) Accessibility += 1*fRangeIsInvalid;

	}

	Accessibility =  Accessibility / float(nSamplesNum) +0.15;

	gl_FragColor = vec4(clamp(Accessibility*Accessibility+Accessibility, 0, 1));

	//Show fRangeIsInvalid
	//gl_FragColor = vec4(fRangeIsInvalid);

   //Draw depth of the scene
   //float dep1 = texture2D(normalMap, uv.xy).a;
   //gl_FragColor = vec4(dep1);

}