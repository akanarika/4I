varying vec3 Normal;
varying float dep; //in eye space

void main( void )
{
	vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
	//dep = -viewPos.z/10.0;

	gl_Position = ftransform();
	dep = (gl_Position.z/gl_Position.w + 1)/2;
	Normal      = normalize(( gl_ModelViewMatrix * vec4( gl_Normal.xyz, 0.0 ) ).xyz);
}