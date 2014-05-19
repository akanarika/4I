varying vec2 v_Coordinates;

void main(void)
{
	gl_Position = ftransform();
	v_Coordinates =(vec2( gl_Position.x,  gl_Position.y ) + vec2( 1.0 ) ) *0.5;
}