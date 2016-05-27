//
//  GLViewController.m
//  OpenGL
//
//  Created by Fabrizio Duroni on 27/05/16.
//  Copyright © 2016 Fabrizio Duroni. All rights reserved.
//

#import "GLViewController.h"

@interface GLViewController () {

    GLuint _vboIds[2];
}

@property (strong, nonatomic) EAGLContext *context;
@end

@implementation GLViewController

#pragma mark Data OpenGL

#define VERTEX_POS_SIZE       3
#define VERTEX_COLOR_SIZE     4

#define VERTEX_POS_INDX       0
#define VERTEX_COLOR_INDX     1

// 3 vertices, with (x,y,z) ,(r, g, b, a) per-vertex
GLfloat vertices[3 * ( VERTEX_POS_SIZE + VERTEX_COLOR_SIZE )] =
{
    -0.5f,  0.5f, 0.0f,        // v0
    1.0f,  0.0f, 0.0f, 1.0f,  // c0
    -1.0f, -0.5f, 0.0f,        // v1
    0.0f,  1.0f, 0.0f, 1.0f,  // c1
    0.0f, -0.5f, 0.0f,        // v2
    0.0f,  0.0f, 1.0f, 1.0f,  // c2
};

// Index buffer data
GLushort indices[3] = { 0, 1, 2 };

#pragma mark Apple View Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if(!self.context) {
        
        //Failed to load OpenGL ES 3 context.
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"OpenGL"
                                    message:@"OpenGL ES 3 not available"
                                    preferredStyle:UIAlertControllerStyleAlert];

        [self presentViewController:alert animated:YES completion:nil];
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    //Init opengl.
    [self initOpenGL];
    
    //Load opengl data.
    GLint stride = sizeof(GLfloat) * (VERTEX_POS_SIZE + VERTEX_COLOR_SIZE);
    [self loadDataOpenGL:vertices andNumVertices:3 andStride:stride andIndices:indices andNumIndices:3];
}

#pragma mark Init OpenGL

- (void)initOpenGL {

    const char *vertexShaderSource = [self shaderSource:@"vertex"];
    const char *fragmentShaderSource = [self shaderSource:@"fragment"];
    
    //Load shaders.
    GLuint vertexShader = [self loadShader:GL_VERTEX_SHADER source:vertexShaderSource];
    GLuint fragmentShader = [self loadShader:GL_FRAGMENT_SHADER source:fragmentShaderSource];
    
    //Create program.
    GLuint programObject = glCreateProgram();
    
    //Attach shader to program.
    glAttachShader(programObject, vertexShader);
    glAttachShader(programObject, fragmentShader);
    
    //Link the program.
    glLinkProgram(programObject);
    
    //TODO: check program status.
    
    // Free up no longer needed shader resources
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
}

#pragma mark Data OpenGL

- (void)loadDataOpenGL:(GLfloat *)verticesArray
        andNumVertices:(GLint)numVertices
             andStride:(GLint)vertexStride
            andIndices:(GLushort *)indicesArray
         andNumIndices:(GLint)numIndices {
    
    //Generate buffer objects: one for vertex data and one for vertex indices.
    glGenBuffers(2, _vboIds);
    
    //Start buffer for vertex data.
    glBindBuffer(GL_ARRAY_BUFFER, _vboIds[0]);
    glBufferData(GL_ARRAY_BUFFER, vertexStride * numVertices, verticesArray, GL_STATIC_DRAW);

    //start buffer for vertex indices.
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _vboIds[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort) * numIndices, indicesArray, GL_STATIC_DRAW);
    
    //Enable vertex attribute pointer.
    glEnableVertexAttribArray(VERTEX_POS_INDX);
    glEnableVertexAttribArray(VERTEX_COLOR_INDX);

//    glVertexAttribPointer(VERTEX_POS_INDX, VERTEX_POS_SIZE,
//                           GL_FLOAT, GL_FALSE, vtxStride,
//                           ( const void * ) offset );
//    
//    offset += VERTEX_POS_SIZE * sizeof ( GLfloat );
//    glVertexAttribPointer ( VERTEX_COLOR_INDX,
//                           VERTEX_COLOR_SIZE,
//                           GL_FLOAT, GL_FALSE, vtxStride,
//                           ( const void * ) offset );
}

#pragma mark Draw OpenGL

- (void)update {
 
    NSLog(@"update");
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    NSLog(@"glkView");
    
    glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, 0);
}

#pragma mark Shader OpenGL

- (const char *)shaderSource:(NSString *)shaderName {
    
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"sh"];
    const char *shaderSource = [[NSString stringWithContentsOfFile:shaderPath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil] UTF8String];
    return shaderSource;
}

- (GLuint)loadShader:(GLenum)type source:(const char *)shaderSrc {
    
    //Create the shader object.
    GLuint shader = glCreateShader ( type );
    
    if (shader == 0) {
        
        return 0;
    }
    
    //Load the shader source.
    glShaderSource(shader, 1, &shaderSrc, NULL);
    
    //Compile the shader.
    glCompileShader(shader);
    
    //TODO: check shader status.
    
    return shader;
}

#pragma mark Terminate OpenGL

- (void)tearDownGL {
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            
            [EAGLContext setCurrentContext:nil];
        }
        
        self.context = nil;
    }
}

@end
