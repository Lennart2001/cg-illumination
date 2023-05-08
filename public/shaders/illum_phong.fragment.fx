#version 300 es
precision mediump float;

// Input
in vec3 model_normal;
in vec2 model_uv;
in vec3 world_pos;

// Uniforms
// material
uniform vec3 mat_color;
uniform vec3 mat_specular;
uniform float mat_shininess;
uniform sampler2D mat_texture;
// camera
uniform vec3 camera_position;
// lights
uniform vec3 ambient; // Ia
uniform int num_lights;
uniform vec3 light_positions[8];
uniform vec3 light_colors[8]; // Ip

// Output
out vec4 FragColor;

void main() {
    vec3 model_color = mat_color * texture(mat_texture, model_uv).rgb;
    vec3 diff = vec3(0.0);
    vec3 specular = vec3(0.0);

    for (int i = 0; i < num_lights; i++) {

        vec3 light_dir = normalize(light_positions[i] - world_pos);

        // diff
        diff += max(dot(model_normal, light_dir), 0.0) * light_colors[i];

        // spec
        vec3 view_dir = normalize(camera_position - world_pos);
        vec3 reflect_dir = reflect(-light_dir, model_normal);
        float temp = max(dot(view_dir, reflect_dir), 0.0);
        float spec = pow(temp, mat_shininess);
        specular += spec * light_colors[i];
    }

    // Stupid ambient light again
    vec3 ambient_illum = ambient * model_color;

    // slef expokanatory what be happing her e -> ambinet + specular + diffisinh
    vec3 final_color = ambient_illum + diff * model_color + specular * mat_specular;

    // Yeeeeeeeerrrrr give me that colorrrrr
    FragColor = vec4(final_color, 1.0);
}