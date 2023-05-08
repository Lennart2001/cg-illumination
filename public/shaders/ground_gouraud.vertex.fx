#version 300 es
precision highp float;

// Attributes
in vec3 position;
in vec2 uv;

// Uniforms
// projection 3D to 2D
uniform mat4 world;
uniform mat4 view;
uniform mat4 projection;
// height displacement
uniform vec2 ground_size;
uniform float height_scalar;
uniform sampler2D heightmap;
// material
uniform float mat_shininess;
uniform vec2 texture_scale;
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
    // Get initial position of vertex (prior to height displacement)
    vec4 world_pos = world * vec4(position, 1.0);

    // create some displacement beased on heighyamp
    float height = texture(heightmap, uv).r * height_scalar;
    world_pos.y += height;

    // pass too the fragment shader
    model_uv = uv * texture_scale;

    // Left rigth
    float height_left = texture(heightmap, uv - vec2(1.0 / ground_size.x, 0.0)).r * height_scalar;
    float height_right = texture(heightmap, uv + vec2(1.0 / ground_size.x, 0.0)).r * height_scalar;
    // Up Down
    float height_down = texture(heightmap, uv - vec2(0.0, 1.0 / ground_size.y)).r * height_scalar;
    float height_up = texture(heightmap, uv + vec2(0.0, 1.0 / ground_size.y)).r * height_scalar;
    //noramlize evrything
    vec3 dpdx = vec3(2.0 / ground_size.x, height_right - height_left, 0.0);
    vec3 dpdy = vec3(0.0, height_up - height_down, 2.0 / ground_size.y);
    vec3 normal = cross(dpdx, dpdy);
    float normal_length = length(normal);
    normal = normal / normal_length;

    for (int i = 0; i < num_lights; i++) {
        vec3 light_dir = light_positions[i] - world_pos.xyz;
        float light_dir_length = length(light_dir);
        light_dir = light_dir / light_dir_length;

        // diff illumination
        float diff = max(dot(normal, light_dir), 0.0);
        diffuse_illum += diff * light_colors[i];

        // ughhhhhh the repetition.... why is there so much specular illumination
        vec3 view_dir = camera_position - world_pos.xyz;
        float view_dir_length = length(view_dir);
        view_dir = view_dir / view_dir_length;
        vec3 reflection_dir = reflect(-light_dir, normal);
        float spec = pow(max(dot(view_dir, reflection_dir), 0.0), mat_shininess);
        specular_illum += spec * light_colors[i];
    }

    // Transform and project vertex from 3D world-space to 2D screen-space
    gl_Position = projection * view * world_pos;
}
