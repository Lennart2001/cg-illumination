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
uniform float mat_shininess;
// camera
uniform vec3 camera_position;
// lights
uniform int num_lights;
uniform vec3 light_positions[8];
uniform vec3 light_colors[8]; // Ip

// Output
out vec2 model_uv;
out vec3 diffuse_illum;
out vec3 specular_illum;

void main() {
    // Get that initial position of ther vertex
    vec4 world_pos = world * vec4(position, 1.0);
    vec3 model_normal = mat3(world) * normal;

    // Calculate diffuse and specular illumination
    for (int i = 0; i < num_lights; i++) {

        // Uhhhh what's going on if you dont have a light direction?????? Circular light??
        vec3 light_dir = normalize(light_positions[i] - world_pos.xyz);

        // diffuse illuminating
        float diff = max(dot(model_normal, light_dir), 0.0);
        diffuse_illum += diff * light_colors[i];

        // specular illuminati - You ever think some backroom group of the illuminati still exist?
        // Tghe enlightened ones? Sometimes I wish I would've stucl to latin and reslly studied it
        // It's actually a pretty cool language. I mean i did learn it for 3 years and could read it no problem
        // But, thgen i just stopped studying and now I can barely read it anymore - so sad
        vec3 view_dir = normalize(camera_position - world_pos.xyz);
        vec3 reflect_dir = reflect(-light_dir, model_normal);
        float temp = max(dot(view_dir, reflect_dir), 0.0);
        float spec = pow(temp, mat_shininess);
        specular_illum += spec * light_colors[i];
    }

    // onto the fragment shader we goooooooooo -> Yeah
    model_uv = uv * texture_scale;

    gl_Position = projection * view * world_pos;
}
