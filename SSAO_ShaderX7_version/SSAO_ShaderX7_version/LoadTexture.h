#ifndef _LOADTEXTURE_H
#define _LOADTEXTURE_H

#include "glut.h"
#include <windows.h>
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

#endif