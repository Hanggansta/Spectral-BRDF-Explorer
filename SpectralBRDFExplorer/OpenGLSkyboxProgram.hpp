//
//  OpenGLSkyboxProgram.hpp
//  SpectralBRDFExplorer
//
//  Created by Fabrizio Duroni on 16/10/2016.
//  
//

#ifndef OpenGLSkyboxProgram_hpp
#define OpenGLSkyboxProgram_hpp

#include <glm/gtc/type_ptr.hpp>

#include "OpenGLProgram.hpp"
#include "Model3D.hpp"

class OpenGLSkyboxProgram : public OpenGLProgram {
private:
    
    /// Skybox cubemap texture.
    OpenGLTexture skyboxTexture;
    /// Texture base path.
    std::string textureBasePath;
    
public:
    
    /// Skybox model view projection matrix shader location.
    GLint _skyboxmvpLocation;
    /// Skybox texture sampler shader location.
    GLint _skyBoxTextureSamplerLocation;
    /// Skybox 3D model.
    Model3D* skyboxModel;
    
    OpenGLSkyboxProgram() : OpenGLProgram() {}
    
    OpenGLSkyboxProgram(std::string aShadersBasePath, std::string aTextureBasePath) :
            OpenGLProgram(aShadersBasePath), textureBasePath{aTextureBasePath} {}
    
    /*!
     Start a skybox program with its specific setup.
     
     @param error error message to be return if the start fails.
     
     @returns true if the program starts correctly, else false.
     */
    bool startProgram(std::string& error);
    
    /*!
     Update skybox models using the current camera and projection matrix.
     
     @param camera the current camera.
     @param projectionMatrix the projection matrix (it is usually a orthogonal matrix).
     */
    void update(OpenGLCamera& openGLCamera, const glm::mat4& projectionMatrix);
    
    /*
     Draw method.
     Contains all the OpenGL ES step need to draw a model
     in the draw renderer method.
     */
    void draw();
};

#endif /* OpenGLSkyboxProgram_hpp */
