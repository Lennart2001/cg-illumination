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
uniform vec2 texture_scale;

// Output
out vec3 model_normal;
out vec2 model_uv;
out vec3 world_pos;

void main() {
    // Get initial position of vertex (prior to height displacement)
    vec4 world_position = world * vec4(position, 1.0);

    // Bruuuuhhhhh now we gotta somehow change the vertex position based on some tupe of heightmap??
    float height = texture(heightmap, uv).r;
    height *= height_scalar;
    world_position.y += height;

    // We we have to normalize everuyhog which is so much code... why does coding use so much code... UGH
    // Anyways, I have just discovered this reaelly cool band called "Slightly Stoopid" they play raggae type beats.
    // It's very cool.
    float height_left = texture(heightmap, uv - vec2(1.0 / ground_size.x, 0.0)).r * height_scalar;
    float height_right = texture(heightmap, uv + vec2(1.0 / ground_size.x, 0.0)).r * height_scalar;

    float height_down = texture(heightmap, uv - vec2(0.0, 1.0 / ground_size.y)).r * height_scalar;
    float height_up = texture(heightmap, uv + vec2(0.0, 1.0 / ground_size.y)).r * height_scalar;

    vec3 dpdx = vec3(2.0 / ground_size.x, height_right - height_left, 0.0);
    vec3 dpdy = vec3(0.0, height_up - height_down, 2.0 / ground_size.y);
    model_normal = normalize(cross(dpdx, dpdy));

    // Okay now we move ebverythin to the fragment shader.
    model_uv = uv * texture_scale;
    world_pos = world_position.xyz;
    gl_Position = projection * view * world_position;
}
