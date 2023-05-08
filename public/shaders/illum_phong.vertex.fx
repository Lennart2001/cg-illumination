#version 300 es
precision highp float;

// Attributes
in vec3 position;
in vec3 normal;
in vec2 uv;

// Uniforms
// projection 3D to 2D
uniform mat4 world;
uniform mat4 view;
uniform mat4 projection;
// material
uniform vec2 texture_scale;

// Output
out vec3 model_normal;
out vec2 model_uv;
out vec3 world_pos;

void main() {
    // Get initial position of vertex
    vec4 world_position = world * vec4(position, 1.0);

    // pass that shit into the fragment shader -> FRAGMENT SHADER UR BEING SHIT PASSED TO
    model_normal = mat3(world) * normal;
    world_pos = world_position.xyz;
    model_uv = uv * texture_scale;

    // Transform and project vertex from 3D world-space to 2D screen-space
    gl_Position = projection * view * world_position;
}
