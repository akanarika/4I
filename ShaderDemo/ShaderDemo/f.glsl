//Ramdow normal map 
uniform sampler2D rnm;
//Texture storing normal and depth of the scene
uniform sampler2D normalMap;
uniform sampler2D color;

varying vec2 uv;
uniform float totStrength = 0.5;
uniform float strength = 0.07;
uniform float offset = 18.0;
uniform float falloff = 0.000002;
uniform float rad = 0.006;
#define SAMPLES 16 // 10 is good

const float invSamples = 1.0/SAMPLES;
void main(void)
{
	vec3 pSphere[140] = vec3[](vec3(-0.5921,-0.6400,0.4897),vec3(-0.3803,0.4898,0.7845),vec3(0.8572,-0.0161,-0.5148),vec3(0.1085,0.6629,-0.7408),vec3(-0.4805,-0.6832,-0.5499),vec3(-0.7538,-0.5846,-0.3000),vec3(-0.6871,0.5887,-0.4258),vec3(0.3251,0.4041,0.8550),vec3(0.4358,0.0694,-0.8974),vec3(-0.8644,0.4674,0.1853),
	vec3(0.2971,0.6761,-0.6742),vec3(-0.1116,-0.7276,0.6768),vec3(-0.5126,0.5433,-0.6649),vec3(0.5441,-0.8390,0.0044),vec3(-0.0051,-0.0515,0.9987),vec3(-0.8635,-0.4132,-0.2892),vec3(0.1879,0.3797,-0.9058),vec3(0.7906,-0.2169,-0.5727),vec3(-0.0941,0.9744,-0.2043),vec3(0.8391,-0.4303,-0.3327),
	vec3(0.1380,0.8298,-0.5408),vec3(-0.3427,0.3489,0.8722),vec3(0.7934,0.4862,0.3664),vec3(-0.2432,-0.2944,0.9242),vec3(0.4190,0.8995,-0.1241),vec3(0.4549,0.1323,0.8807),vec3(-0.0256,-0.1502,-0.9883),vec3(-0.5605,0.7982,0.2206),vec3(-0.4252,-0.6757,0.6022),vec3(-0.6302,0.5636,-0.5340),
	vec3(-0.3496,-0.3601,0.8649),vec3(0.8423,0.1153,0.5265),vec3(0.6410,-0.4036,0.6529),vec3(0.3090,-0.9397,0.1469),vec3(-0.0212,-0.8106,0.5852),vec3(0.3630,-0.8668,-0.3419),vec3(-0.6190,0.5576,-0.5531),vec3(-0.6865,-0.6229,-0.3752),vec3(-0.8768,-0.4502,0.1690),vec3(-0.7381,-0.1410,0.6598),
	vec3(-0.1424,0.8967,-0.4191),vec3(0.0084,0.9808,-0.1949),vec3(-0.6581,0.2064,0.7241),vec3(0.1359,0.9638,0.2295),vec3(0.0627,-0.1761,0.9824),vec3(0.8024,-0.0702,-0.5926),vec3(0.7427,0.1416,0.6544),vec3(-0.9127,-0.2080,0.3517),vec3(0.7386,0.4499,-0.5021),vec3(0.3211,-0.9458,-0.0484),
	vec3(0.9771,-0.0667,-0.2018),vec3(0.8946,0.4002,0.1989),vec3(0.7420,-0.2970,0.6010),vec3(0.6093,0.0699,-0.7899),vec3(-0.3093,-0.7007,0.6429),vec3(0.1538,-0.7148,0.6822),vec3(-0.9348,-0.2036,-0.2910),vec3(0.7442,-0.6531,-0.1399),vec3(0.7969,-0.5866,0.1445),vec3(-0.6437,-0.6514,0.4016),
	vec3(0.5664,0.6663,0.4849),vec3(0.1721,0.8393,0.5158),vec3(0.4033,0.8878,-0.2217),vec3(0.9560,0.2571,-0.1414),vec3(0.3198,0.2544,0.9127),vec3(-0.7361,-0.6609,0.1459),vec3(0.6639,-0.2645,0.6994),vec3(-0.5458,0.7086,-0.4473),vec3(-0.8207,0.5163,0.2446),vec3(0.9795,-0.0966,0.1767),
	vec3(0.3535,-0.1258,0.9269),vec3(-0.2493,-0.5020,-0.8282),vec3(0.9973,-0.0734,0.0010),vec3(0.1055,-0.9935,0.0432),vec3(-0.2968,0.4899,-0.8197),vec3(-0.3073,-0.5006,0.8093),vec3(0.0234,0.6391,0.7688),vec3(-0.2799,0.9522,-0.1220),vec3(-0.3509,-0.7479,0.5634),vec3(-0.7003,-0.1238,-0.7031),
	vec3(-0.8249,0.5120,0.2396),vec3(-0.7016,-0.5277,-0.4788),vec3(0.0032,-0.9941,-0.1087),vec3(-0.6280,-0.3636,0.6880),vec3(-0.7526,-0.2539,-0.6076),vec3(-0.7959,-0.4611,-0.3923),vec3(-0.9967,-0.0742,-0.0334),vec3(0.8214,0.4691,-0.3244),vec3(-0.1525,-0.7876,0.5970),vec3(0.2222,-0.0054,0.9750),
	vec3(-0.4466,0.5793,-0.6819),vec3(0.8365,-0.1527,-0.5262),vec3(-0.5209,0.7517,0.4045),vec3(0.7327,-0.6334,-0.2491),vec3(-0.3071,0.0899,0.9474),vec3(-0.2808,0.1698,0.9446),vec3(0.1929,0.9382,0.2874),vec3(0.4885,0.4926,0.7202),vec3(-0.3547,0.9141,-0.1962),vec3(-0.1443,-0.9537,0.2639),
	vec3(0.0495,-0.2361,0.9705),vec3(-0.3434,-0.9316,0.1190),vec3(0.4970,0.0307,0.8672),vec3(0.4962,-0.7481,0.4407),vec3(0.8828,-0.4686,-0.0319),vec3(0.1261,-0.9522,0.2781),vec3(0.6091,0.1673,0.7753),vec3(-0.5755,0.5529,-0.6025),vec3(-0.2767,-0.9379,-0.2093),vec3(-0.0226,-0.1748,0.9844),
	vec3(0.1578,0.9680,-0.1953),vec3(-0.1133,0.9414,0.3177),vec3(-0.2773,-0.5280,0.8027),vec3(-0.1342,0.0191,0.9908),vec3(-0.6785,-0.6677,0.3063),vec3(0.0529,0.6196,-0.7831),vec3(0.1650,0.3347,-0.9278),vec3(0.4662,-0.8526,0.2362),vec3(0.1052,-0.9853,0.1343),vec3(0.3506,-0.1531,0.9239),
	vec3(0.6780,0.5459,0.4922),vec3(0.3906,0.8612,0.3250),vec3(0.8115,0.5825,0.0466),vec3(-0.8753,0.0564,-0.4802),vec3(0.1335,0.3584,0.9240),vec3(0.7910,-0.6065,0.0804),vec3(0.2784,0.1998,-0.9395),vec3(0.8845,0.2520,0.3926),vec3(-0.9352,-0.3520,0.0394),vec3(0.0664,-0.4667,-0.8819),
	vec3(-0.2374,0.5789,0.7801),vec3(0.4059,0.8485,-0.3396),vec3(-0.4461,0.7133,-0.5406),vec3(0.1575,0.6157,-0.7721),vec3(-0.9239,-0.0590,-0.3782),vec3(0.6985,-0.4660,-0.5431),vec3(-0.6568,-0.6900,0.3040),vec3(0.3993,0.2961,-0.8677),vec3(-0.6915,0.5658,-0.4491),vec3(0.8473,0.3027,-0.4364));
   //grab a normal for reflecting the sample rays later on
   vec3 fres = normalize((texture2D(rnm,uv*offset).xyz*2.0) - vec3(1.0));
   //vec3 fres = normalize(texture2D(rnm,uv*offset).xyz);

 
	//取出当前点的向量值
   vec4 currentPixelSample = texture2D(normalMap,uv);
 
	//渲染第二遍，将场景本身的颜色取出。如果不做混合，则不需要
	//vec4 sampleColor = texture2D(color, uv);

	//取出当前点的深度值
   float currentPixelDepth = currentPixelSample.a;
 
   // current fragment coords in screen space
   //ep表示当前点的屏幕空间的坐标，加上深度值，组成的屏幕空间的三维坐标
   vec3 ep = vec3(uv.xy,currentPixelDepth);

   //get the normal of current fragment
   //norm表示当前点的法向量
   vec3 norm = currentPixelSample.xyz;
 
   float bl = 0.0;
   // adjust for the depth ( not shure if this is good..)

   float radD = rad/currentPixelDepth;
 
   vec3 ray, se, occNorm;
   float occluderDepth, depthDifference, normDiff;
 
   for(int i=0; i<SAMPLES;++i)
   {
      // get a vector (randomized inside of a sphere with radius 1.0) from a texture and reflect it
      
	  ray = radD*reflect(pSphere[i],fres);
 
      // if the ray is outside the hemisphere then change direction
	  //如果光线ray和法向量norm的夹角大于90，那么sign后得-1， se = ep - ray，否则，是 se = ep + ray
      se = ep + sign(dot(ray,norm) )*ray;
 
      // get the depth of the occluder fragment
	  //取得se位置的normal
      vec4 occluderFragment = texture2D(normalMap,se.xy);
 
      // get the normal of the occluder fragment
	  //得到occluder位置的normal
      occNorm = occluderFragment.xyz;
 
      // if depthDifference is negative = occluder is behind current fragment
	  //depthDifference表示当前的深度减去采样点的深度，如果是负的，表示采样点在后面
      depthDifference = currentPixelDepth-occluderFragment.a;
 
      // calculate the difference between the normals as a weight
	//这两个normal的角度越大，normdiff越大
      normDiff = (1.0-dot(occNorm,norm));
      // the falloff equation, starts at falloff and is kind of 1/x^2 falling
	  //step(edge, x): 如 x<edge 则0.0, 否则 1.0
	  //smoothstep(edge0, edge1, x): x 在两个之间的时候，平滑差值，小于edge0 = 0， 大于edge1， 1.
	  //step(falloff,depthDifference) 如果depthDIfference小于falloff，则整个式子为0
	  //smoothstep(falloff,strength,depthDifference) depthDifference越靠近strength，式子越接近1.
	   bl += step(falloff,depthDifference)*normDiff*(1.0-smoothstep(falloff,strength,depthDifference));
   }
 
   // output the result
   float ao = 1.0-totStrength*bl*invSamples ;
   
   //if(ao<0) ao =0.0;
   //if(ao>1) a0 =1.0;
   
   //Blend
   //gl_FragColor = vec4(ao)*sampleColor;

   //SSAO only
   gl_FragColor = vec4(ao);

   //gl_FragColor = sampleColor;
   //gl_FragColor = vec4(currentPixelDepth);

}