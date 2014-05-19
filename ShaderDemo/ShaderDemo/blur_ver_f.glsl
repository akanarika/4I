uniform sampler2D bAOTexture;

varying vec2 v_Coordinates;
 
uniform vec2 u_Scale = vec2(0, 1.0/800);
//uniform sampler2D u_Texture0;
 
const vec2 gaussFilter[7] = 
{ 
	vec2(-3.0,	0.015625),
	vec2(-2.0,	0.09375),
	vec2(-1.0,	0.234375),
	vec2(0.0,	0.3125),
	vec2(1.0,	0.234375),
	vec2(2.0,	0.09375),
	vec2(3.0,	0.015625)
};
 
void main()
{
	vec4 color = vec4(0.0);
	for( int i = 0; i < 7; i++ )
	{
		color += texture2D( bAOTexture, vec2( v_Coordinates.x+gaussFilter[i].x*u_Scale.x, v_Coordinates.y+gaussFilter[i].x*u_Scale.y ) )*gaussFilter[i].y;
	}
 
	gl_FragColor = color;

	//gl_FragColor = vec4(u_Scale*400,0,0);
	//gl_FragColor = texture2D( bAOTexture,v_Coordinates);
}