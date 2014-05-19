varying vec3 Normal;
varying float dep;

float zNear = 1;
float zFar = 8;



void main( void )
{
	float z_b = gl_FragCoord.z;
	float z_n = 2.0 * z_b - 1.0;
	float z_e = 2.0 * zNear * zFar /(zFar + zNear - z_n * (zFar - zNear));


   gl_FragColor = vec4(normalize(Normal),gl_FragCoord.z/gl_FragCoord.w);
   //gl_FragColor = vec4(normalize(Normal),gl_FragCoord.z);
   
   //gl_FragColor = vec4(normalize(Normal),z_e-1);
}