#include <iostream>
#include "glew.h"
#include "glut.h"
#include "obj/glm.h"
#include "glext.h"
#include <windows.h>
#include "Shaders.h"
#include "LoadTexture.h"

#pragma comment (lib, "glew32.lib")

#define WINDOW_HEIGHT 800
#define WINDOW_WIDTH 800

/* For obj loader */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

//for Dragon
//GLfloat eye[3] = { -1.5, 1.5, -0.5 };
//GLfloat at[3]  = { 0.0, 0.0, 0.0 };
//GLfloat up[3]  = { 0.0, 1.0, 0.0 };

//for sibenik
//GLfloat eye[3] = { -2.0, -1.0, 0.0 };
//GLfloat at[3]  = { 0.0, -1.0, 0.0 };
//GLfloat up[3]  = { 0.0, 1.0, 0.0 };

//GLfloat eye[3] = { -1, -2.5, 0.0 };
//GLfloat at[3]  = { 0.0, -1.0, -1.0 };
//GLfloat up[3]  = { 0.0, 1.0, 0.0 };

//for teapot and castle
GLfloat eye[3] = { 1.0, 0.0, 2.0 };
GLfloat at[3]  = { 0.0, 0.0, 0.0 };
GLfloat up[3]  = { 0.0, 1.0, 0.0 };

GLMmodel* pmodel = NULL;

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

void reshape(int width, int height)
{
	printf("Reshape called.\n");
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(60, (float)width/height, 1 ,8);
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

/* For obj loader ends */

GLuint fbo, normal_depth_texture, depthbuffer,depth_texture;
GLuint SSAO_vertex_shader, SSAO_fragment_shader, SSAO_program, normal_vertex_shader, normal_fragment_shader, normal_program;
GLuint blur_vertex_shader, blur_fragment_shader, blur_program;
GLuint blur_v_vertex_shader, blur_v_fragment_shader, blur_v_program;
GLuint rnmTexture, AOTexture, bAOTexture;

static GLuint init_shaders()
{
    printf("Initializing shaders...\n");

    //Initialize shaders to store normal and depth texture 
    normal_vertex_shader = make_shader(GL_VERTEX_SHADER, "normal_v.glsl");
    normal_fragment_shader = make_shader(GL_FRAGMENT_SHADER, "normal_f.glsl");

    if ( normal_vertex_shader==0 || normal_fragment_shader==0 ) {
        return 0;
    }
    normal_program = make_program(normal_vertex_shader, normal_fragment_shader);
    if ( normal_program == 0 ) {
        return 0;
    }

    //Initialize shaders to calculate SSAO factor
    SSAO_vertex_shader = make_shader(GL_VERTEX_SHADER, "SSAO_v.glsl");
    SSAO_fragment_shader = make_shader(GL_FRAGMENT_SHADER, "SSAO_f.glsl");
    if ( SSAO_vertex_shader==0 || SSAO_fragment_shader==0 ) {
        return 0;
    }
    SSAO_program = make_program(SSAO_vertex_shader, SSAO_fragment_shader);
    if ( SSAO_program == 0 ) {
        return 0;
    }
    
	//Initialize shaders to do gaussian bluring for both directions
    /*blur_vertex_shader = make_shader(GL_VERTEX_SHADER, "blur_hor_v.glsl");
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
    }*/

    printf("Shaders are ready!\n");

    return 1;
}



//Load obj file and draw the model
static void draw()
{
    glClearDepth(1.0f);
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    if (!pmodel) {
        //pmodel = glmReadOBJ("sibenik/sibenik.obj");
        pmodel = glmReadOBJ("obj/castle.obj");
        if (!pmodel) exit(0);
        glmUnitize(pmodel);
        glmFacetNormals(pmodel);
        glmVertexNormals(pmodel, 90.0);
    }

    glPushMatrix(); 
    glmDraw(pmodel, GLM_SMOOTH | GLM_MATERIAL);
	
    glPopMatrix();
	glutSwapBuffers();

}

static void render(void)
{
	printf("Render called.\n");
    //Render the normal and depth to a texture
	//glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
    glUseProgram(normal_program);
    glColor3f(1,1,1);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_DEPTH_TEST);
   
	//Draw model
	glPushAttrib(GL_VIEWPORT_BIT);
    draw();
    glPopAttrib();

    //Render SSAO texture

    //Bind buffer to screen
    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);

	//Generate AO texture 
    glGenTextures(1, &AOTexture);
    glBindTexture(GL_TEXTURE_2D, AOTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, WINDOW_WIDTH, WINDOW_HEIGHT, 0, GL_RGBA, GL_FLOAT, NULL);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, AOTexture, 0);



    glUseProgram(SSAO_program);
	GLuint location;
    location = glGetUniformLocation( SSAO_program, "normalMap");
    glUniform1i(location, 0);
    location = glGetUniformLocation( SSAO_program, "rnm");
    glUniform1i(location, 6);


    glActiveTextureARB(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, normal_depth_texture);
    glGenerateMipmapEXT(GL_TEXTURE_2D);

    glActiveTexture(GL_TEXTURE6);
    glBindTexture(GL_TEXTURE_2D, rnmTexture);
    glGenerateMipmapEXT(GL_TEXTURE_2D);

    glClearDepth(1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glMatrixMode(GL_PROJECTION);//转入正投影
    glLoadIdentity();
    glOrtho( 0, WINDOW_WIDTH,WINDOW_HEIGHT, 0, -1, 1 );//屏幕大小
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glBegin(GL_QUADS);
        glTexCoord2f(0, 0);glVertex2f(0,0);
        glTexCoord2f(0, 1);glVertex2f(0,WINDOW_HEIGHT);
        glTexCoord2f(1, 1);glVertex2f(WINDOW_WIDTH, WINDOW_HEIGHT);
        glTexCoord2f(1, 0);glVertex2f(WINDOW_WIDTH,0);
    glEnd();

    glutSwapBuffers();

    printf("Render complete.\n");

}


void initFBO()
{
    glGenFramebuffersEXT(1, &fbo); 
    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo);
    
    /*glGenRenderbuffersEXT(1, &depthbuffer);
    glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthbuffer);
    glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, WINDOW_WIDTH, WINDOW_HEIGHT);
    glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthbuffer);*/

	//normal_depth_texture
    glGenTextures(1, &normal_depth_texture);
    glBindTexture(GL_TEXTURE_2D, normal_depth_texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, WINDOW_WIDTH, WINDOW_HEIGHT, 0, GL_RGBA, GL_FLOAT, NULL);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, normal_depth_texture, 0);

    //depth_texture
    glGenTextures(1, &depth_texture);
    glBindTexture(GL_TEXTURE_2D, depth_texture);
    glTexImage2D( GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, WINDOW_WIDTH, WINDOW_HEIGHT, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT,GL_TEXTURE_2D, depth_texture, 0);

    //load bmp_texture
    bool lt = LoadTexture(L"rnm.bmp",rnmTexture);
    if(!lt)
        printf("Fail to load texture.");

    GLenum status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
    
    if(status == GL_FRAMEBUFFER_COMPLETE_EXT)
        printf("FBO is ready!\n");
    else printf("FBO is not ready!\n");
}


int main(int argc, char **argv) {
    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGB|GLUT_DEPTH);
    glutInitWindowSize(WINDOW_WIDTH,WINDOW_HEIGHT);
    glutCreateWindow("SSAO version:Shader X7");
    glutDisplayFunc(render);
    glutReshapeFunc(reshape);
    

    glewInit();
    initFBO();
	init_shaders();

    glutMainLoop();
    return 0;
}