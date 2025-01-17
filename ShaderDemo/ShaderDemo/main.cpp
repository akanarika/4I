﻿#include <cassert>
#include <iostream>
#include "glew.h"
#include "glut.h"
//#include "glu.h"
#include "obj/glm.h"
#include "glext.h"
#include <windows.h>

#pragma warning(disable : 4996)
#pragma comment(lib, "glew32.lib")
GLuint vertex_shader, fragment_shader, program, normal_vertex_shader, normal_fragment_shader, normal_program;
GLuint blur_vertex_shader, blur_fragment_shader, blur_program;
GLuint blur_v_vertex_shader, blur_v_fragment_shader, blur_v_program;
GLuint rnmTexture, colorTexture, AOTexture, bAOTexture;

#define HEIGHT 800
#define WIDTH 800

//OBJ loader
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

//for Dragon
//GLfloat eye[3] = { -1.5,1.5, 0.0 };
//GLfloat at[3]  = { 0.0, 0.0, 0.0 };
//GLfloat up[3]  = { 0.0, 1.0, 0.0 };

//for sibenik
GLfloat eye[3] = { -2.0, -1.0, 0.0 };
GLfloat at[3]  = { 0.0, -1.0, 0.0 };
GLfloat up[3]  = { 0.0, 1.0, 0.0 };

//GLfloat eye[3] = { -1, -2.5, 0.0 };
//GLfloat at[3]  = { 0.0, -1.0, -1.0 };
//GLfloat up[3]  = { 0.0, 1.0, 0.0 };

//for teapot and castle
//GLfloat eye[3] = { 1.0, 0.0, 2.0 };
//GLfloat at[3]  = { 0.0, 0.0, 0.0 };
//GLfloat up[3]  = { 0.0, 1.0, 0.0 };

GLMmodel* pmodel = NULL;

void redisplay_all(void);
GLdouble projection[16], modelview[16], inverse[16];
GLuint window, world, screen, command;
GLuint sub_width = 256, sub_height = 256;
static float angleX=0.0,angleY=0.0;
int rx=0,ry=0,rz=0;
float px=0,py=0,pz=0;
float scale=1;
float lx=1;

GLfloat ambient[] = { 0.2, 0.2, 0.2, 1.0 };
GLfloat diffuse[] = { 0.8, 0.8, 0.8, 1.0 };
GLfloat specular[] = { 0.0, 0.0, 0.0, 1.0 };
GLfloat shininess = 65.0;  
GLfloat light_position[]={ 1.0 , 1.0 , 1.0 , 1.0 };
//OBJ loader

//OBJ loader functions

void reshape(int width, int height)
{
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60.0, (float)width/height, 1.0, 8.0);
    glGetDoublev(GL_PROJECTION_MATRIX, projection);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(eye[0], eye[1], eye[2], at[0], at[1], at[2], up[0], up[1],up[2]);
    glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
    glClearColor(0.2, 0.2, 0.2, 0.0);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
}

void display(void)
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	if (!pmodel) {
        pmodel = glmReadOBJ("obj/teapot.obj");
        if (!pmodel) exit(0);
        glmUnitize(pmodel);
        glmFacetNormals(pmodel);
        glmVertexNormals(pmodel, 90.0);
    }
		/*light_position[0]=lx;
		glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
		glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
		glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
		glMaterialf(GL_FRONT, GL_SHININESS, shininess);	


		glLightfv( GL_LIGHT0 , GL_POSITION , light_position ); */

		glPushMatrix();		
		//glRotatef(angleX,   rx,  1,   rz);
		//glRotatef(angleY,   1,    ry,   rz);
		//glTranslatef(px, py, pz);
		glmDraw(pmodel, GLM_SMOOTH | GLM_MATERIAL);
		glPopMatrix();

	glFlush ();
    glutSwapBuffers();
}

//OBJ loader functions



GLuint fbo, color_texture, depthbuffer,depthtex;

static void show_info_log(
    GLuint object,
    PFNGLGETSHADERIVPROC glGet__iv,
    PFNGLGETSHADERINFOLOGPROC glGet__InfoLog
)
{
    GLint log_length;
    char *log;

    glGet__iv(object, GL_INFO_LOG_LENGTH, &log_length);
    log = (char*)malloc(log_length);
    glGet__InfoLog(object, log_length, NULL, log);
    fprintf(stderr, "%s", log);
    free(log);
}

static GLuint make_shader(GLenum type, const char *filename)
{
    GLint length;
    GLchar *source;
    GLuint shader;
    GLint shader_ok;

	// read the file content
	FILE *fp = fopen(filename, "rb");
	if ( !fp ) {
		printf("Error: Open file \"%s\" failed.\n", filename);
		return 0;
	}
	fseek(fp, 0, SEEK_END);
	length = ftell(fp);
	source = new char[length+1];
	rewind(fp);
	fread(source, sizeof(char), length, fp);
	source[length] = 0;	// end with null character

	shader = glCreateShader(type);
    glShaderSource(shader, 1, (const GLchar**)&source, &length);
    delete []source;
    glCompileShader(shader);

	glGetShaderiv(shader, GL_COMPILE_STATUS, &shader_ok);
    if (!shader_ok) {
        fprintf(stderr, "Failed to compile %s:\n", filename);
        show_info_log(shader, glGetShaderiv, glGetShaderInfoLog);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}

static GLuint make_program(GLuint vertex_shader, GLuint fragment_shader)
{
    GLint program_ok;

    GLuint program = glCreateProgram();
    glAttachShader(program, vertex_shader);
    glAttachShader(program, fragment_shader);
    glLinkProgram(program);

	glGetProgramiv(program, GL_LINK_STATUS, &program_ok);
    if (!program_ok) {
        fprintf(stderr, "Failed to link shader program:\n");
        show_info_log(program, glGetProgramiv, glGetProgramInfoLog);
        glDeleteProgram(program);
        return 0;
    }
    return program;
}

static GLuint init_shaders()
{
	printf("Initializing shaders...\n");

	vertex_shader = make_shader(GL_VERTEX_SHADER, "v.glsl");
	fragment_shader = make_shader(GL_FRAGMENT_SHADER, "f.glsl");
	if ( vertex_shader==0 || fragment_shader==0 ) {
		return 0;
	}
	program = make_program(vertex_shader, fragment_shader);
	if ( program == 0 ) {
		return 0;
	}
	

	normal_vertex_shader = make_shader(GL_VERTEX_SHADER, "normal_v.glsl");
	normal_fragment_shader = make_shader(GL_FRAGMENT_SHADER, "normal_f.glsl");

	if ( normal_vertex_shader==0 || normal_fragment_shader==0 ) {
		return 0;
	}
	normal_program = make_program(normal_vertex_shader, normal_fragment_shader);
	if ( normal_program == 0 ) {
		return 0;
	}

	blur_vertex_shader = make_shader(GL_VERTEX_SHADER, "blur_hor_v.glsl");
	blur_fragment_shader = make_shader(GL_FRAGMENT_SHADER, "blur_hor_f.glsl");
	if ( blur_vertex_shader==0 || blur_fragment_shader==0 ) {
		return 0;
	}
	blur_program = make_program(blur_vertex_shader,blur_fragment_shader);
	if ( blur_program == 0 ) {
		return 0;
	}

	blur_v_vertex_shader = make_shader(GL_VERTEX_SHADER, "blur_ver_v.glsl");
	blur_v_fragment_shader = make_shader(GL_FRAGMENT_SHADER, "blur_ver_f.glsl");
	if ( blur_v_vertex_shader==0 || blur_v_fragment_shader==0 ) {
		return 0;
	}
	blur_v_program = make_program(blur_v_vertex_shader,blur_v_fragment_shader);
	if ( blur_v_program == 0 ) {
		return 0;
	}

	//glUseProgram(program);

	printf("Shaders are ready!\n");

	return 1;
}

static bool LoadTexture(LPTSTR szFileName, GLuint &texid)     // Creates Texture From A Bitmap File
{
	 HBITMAP hBMP;             // Handle Of The Bitmap
	 BITMAP BMP;             // Bitmap Structure
	 glGenTextures(1, &texid);          // Create The Texture
	 hBMP=(HBITMAP)LoadImage(GetModuleHandle(NULL), szFileName, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION | LR_LOADFROMFILE );
	 if (!hBMP)
	  return false;
	 GetObject(hBMP, sizeof(BMP), &BMP);

	 glPixelStorei(GL_UNPACK_ALIGNMENT, 4);

	 glBindTexture(GL_TEXTURE_2D, texid);
	 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	 glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	 glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, BMP.bmWidth, BMP.bmHeight, 0, GL_BGR_EXT, GL_UNSIGNED_BYTE, BMP.bmBits);
	 DeleteObject(hBMP);
	 return true;
}

static void draw()
{
	glClearDepth(1.0f);
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	if (!pmodel) {
        //pmodel = glmReadOBJ("sibenik/sibenik.obj");
		pmodel = glmReadOBJ("obj/sibenik.obj");
		if (!pmodel) exit(0);
        glmUnitize(pmodel);
        glmFacetNormals(pmodel);
        glmVertexNormals(pmodel, 90.0);
    }
		/*light_position[0]=lx;
		glMaterialfv(GL_FRONT, GL_AMBIENT, ambient);
		glMaterialfv(GL_FRONT, GL_DIFFUSE, diffuse);
		glMaterialfv(GL_FRONT, GL_SPECULAR, specular);
		glMaterialf(GL_FRONT, GL_SHININESS, shininess);	


		glLightfv( GL_LIGHT0 , GL_POSITION , light_position ); */

		glPushMatrix();		
		//glRotatef(angleX,   rx,  1,   rz);
		//glRotatef(angleY,   1,    ry,   rz);
		//glTranslatef(px, py, pz);
		glmDraw(pmodel, GLM_SMOOTH | GLM_MATERIAL);
		glPopMatrix();

}

static void render(void)
{

	//Render the normal and depth to a texture
	glUseProgram(normal_program);
	glColor3f(1,1,1);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_DEPTH_TEST);
	
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo);	
	glPushAttrib(GL_VIEWPORT_BIT);
	
	
	draw();
	//glutSwapBuffers();
	

	//Render teh scene for a second time to store color in a texture
	glUseProgram(0);


	glGenTextures(1, &colorTexture);
	glBindTexture(GL_TEXTURE_2D, colorTexture);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8,WIDTH,HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, colorTexture, 0);
	
	glClearDepth(1.0f);
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	draw();

	//glPopAttrib();

	//Render SSAO texture

	//Bind buffer to screen
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);

	glGenTextures(1, &AOTexture);
	glBindTexture(GL_TEXTURE_2D, AOTexture);
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8,WIDTH,HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, WIDTH, HEIGHT, 0, GL_RGBA, GL_FLOAT, NULL);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, AOTexture, 0);



	glUseProgram(program);
	GLuint location;
	location = glGetUniformLocation( program, "normalMap");
	glUniform1i(location, 0);
	location = glGetUniformLocation( program, "rnm");
	glUniform1i(location, 6);
	location = glGetUniformLocation( program, "color");
	glUniform1i(location, 5);


	glActiveTextureARB(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, color_texture);
	glGenerateMipmapEXT(GL_TEXTURE_2D);

	glActiveTexture(GL_TEXTURE6);
	glBindTexture(GL_TEXTURE_2D, rnmTexture);
	glGenerateMipmapEXT(GL_TEXTURE_2D);

	glActiveTexture(GL_TEXTURE5);
	glBindTexture(GL_TEXTURE_2D, colorTexture);
	glGenerateMipmapEXT(GL_TEXTURE_2D);

	glClearDepth(1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glMatrixMode(GL_PROJECTION);//转入正投影
	glLoadIdentity();
	glOrtho( 0, WIDTH,HEIGHT, 0, -1, 1 );//屏幕大小
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glBegin(GL_QUADS);
		glTexCoord2f(0, 0);glVertex2f(0,0);
		glTexCoord2f(0, 1);glVertex2f(0,HEIGHT);
		glTexCoord2f(1, 1);glVertex2f(WIDTH, HEIGHT);
		glTexCoord2f(1, 0);glVertex2f(WIDTH,0);
	glEnd();

	glutSwapBuffers();


	//Blur Horizontal
	//glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	
	//glGenTextures(1, &bAOTexture);
	//glBindTexture(GL_TEXTURE_2D, bAOTexture);
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8,WIDTH,HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	//glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, bAOTexture, 0);


	//glUseProgram(blur_program);
	//location = glGetUniformLocation( blur_program, "AOTexture");
	//glUniform1i(location, 4);
	///*location = glGetUniformLocation( color_program, "u_Scale");
	//float u_Scale = 1.0/800;
	//glUniform2fv(location, 0, &u_Scale);*/

	//glActiveTextureARB(GL_TEXTURE4);
	//glBindTexture(GL_TEXTURE_2D, AOTexture);
	//glGenerateMipmapEXT(GL_TEXTURE_2D);

	//glClearDepth(1.0f);
	//glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	//glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	//glMatrixMode(GL_PROJECTION);//转入正投影
	//glLoadIdentity();
	//glOrtho( 0, WIDTH,HEIGHT, 0, -1, 1 );//屏幕大小
	//glMatrixMode(GL_MODELVIEW);
	//glLoadIdentity();

	//glBegin(GL_QUADS);
	//	glTexCoord2f(0, 0);glVertex2f(0,0);
	//	glTexCoord2f(0, 1);glVertex2f(0,HEIGHT);
	//	glTexCoord2f(1, 1);glVertex2f(WIDTH, HEIGHT);
	//	glTexCoord2f(1, 0);glVertex2f(WIDTH,0);
	//glEnd();
	//glutSwapBuffers();


	////Blur Vertical
	//glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);

	//glUseProgram(blur_v_program);
	//location = glGetUniformLocation( blur_v_program, "bAOTexture");
	//glUniform1i(location, 7);

	//glActiveTextureARB(GL_TEXTURE7);
	//glBindTexture(GL_TEXTURE_2D, bAOTexture);
	//glGenerateMipmapEXT(GL_TEXTURE_2D);

	//glClearDepth(1.0f);
	//glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	//glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	//glMatrixMode(GL_PROJECTION);//转入正投影
	//glLoadIdentity();
	//glOrtho( 0, WIDTH,HEIGHT, 0, -1, 1 );//屏幕大小
	//glMatrixMode(GL_MODELVIEW);
	//glLoadIdentity();

	//glBegin(GL_QUADS);
	//	glTexCoord2f(0, 0);glVertex2f(0,0);
	//	glTexCoord2f(0, 1);glVertex2f(0,HEIGHT);
	//	glTexCoord2f(1, 1);glVertex2f(WIDTH, HEIGHT);
	//	glTexCoord2f(1, 0);glVertex2f(WIDTH,0);
	//glEnd();
	//glutSwapBuffers();



	printf("Render complete.\n");

}


void initFBO()
{
	glGenFramebuffersEXT(1, &fbo); 
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo);
	
	/*glGenRenderbuffersEXT(1, &depthbuffer);
	glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthbuffer);
	glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, WIDTH, HEIGHT);
	glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthbuffer);*/

	//color_texture
	glGenTextures(1, &color_texture);
	glBindTexture(GL_TEXTURE_2D, color_texture);
	//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8,WIDTH,HEIGHT, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, WIDTH, HEIGHT, 0, GL_RGBA, GL_FLOAT, NULL);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, color_texture, 0);

	//depth_texture
	glGenTextures(1, &depthtex);
	glBindTexture(GL_TEXTURE_2D, depthtex);
	glTexImage2D( GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, WIDTH, HEIGHT, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, 0);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT,GL_TEXTURE_2D, depthtex, 0);

	//load bmp_texture
	bool lt = LoadTexture(L"rnm.bmp",rnmTexture);
	if(!lt)
		printf("Fail to load texture.");


	GLenum status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
	
	if(status == GL_FRAMEBUFFER_COMPLETE_EXT)
		printf("FBO is ready!\n");
	else printf("FBO is not ready!");
}

int main(int argc, char **argv) {
	glutInit(&argc,argv);
	glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGB|GLUT_DEPTH);
	glutInitWindowSize(WIDTH,WIDTH);
	glutCreateWindow("OpenGL");
	glutDisplayFunc(render);
	glutReshapeFunc(reshape);
	

	glewInit();
	initFBO();
	
	int shaderOK = init_shaders();
	if(init_shaders() == 0) 
	{
		printf("Shaders are not ready!\n");
		return 0;
	}
	else printf("Shaers are ready!\n");

	glutMainLoop();
	return 0;
}