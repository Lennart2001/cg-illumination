#version 300 es
precision mediump float;

// Input
in vec2 model_uv;
in vec3 diffuse_illum;
in vec3 specular_illum;

// Uniforms
// material
uniform vec3 mat_color;
uniform vec3 mat_specular;
uniform sampler2D mat_texture;
// light from environment
uniform vec3 ambient; // Ia

// Output
out vec4 FragColor;

void main() {
    // Uhhhhhhhhh that model color definitionsss yearrr
    vec3 model_color = mat_color;
    model_color *= texture(mat_texture, model_uv).rgb;

    // Calculate ambient illumination
    // Reminds me of that one 'The Weeknd' song:
    // "To the music of the ambiance, get shit poppin'" - I'm not gonna source this line TAKE THE ROYALTIES I DONT CARE
    vec3 ambient_illum = ambient * model_color;

    // Combine ambient, diffuse, and specular illumination
    // Combine me with the uh ambient
    // The what??! The Diffuse as well
    // Oh okay! Yeah, alright. Got that Specualr illumaation as wellll
    vec3 final_color = ambient_illum + diffuse_illum * model_color + specular_illum * mat_specular;

    // Yeerrrr get the color poppin
    FragColor = vec4(final_color, 1.0);
}
