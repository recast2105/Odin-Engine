#version 330

uniform vec3 objectColor;

out vec4 FragColor;

in vec3 FragPosition;
in vec3 FragNormal;

void main() {
    vec3 lightPosition = vec3(0.0, 10.0, -10.0);

    // Light effect 100%
    vec3 lightAmbient = vec3(1.0, 1.0, 1.0);

    vec3 lightDiffuse = vec3(1.0, 1.0, 1.0);

    // Ambient color of the object effect 40%
    vec3 objectAmbient = vec3(0.4, 0.4, 0.4);
    // Diffuse light in the object effect 50%
    vec3 objectDiffuse = vec3(0.5, 0.5, 0.5);

    vec3 ambient = lightAmbient * objectAmbient;

    vec3 lightDirection = normalize(FragPosition - lightPosition);

    float diff = max(dot(FragNormal, -lightDirection), 0);

    vec3 diffuse = diff * lightDiffuse * objectDiffuse;

    FragColor = vec4((ambient + diffuse) * objectColor, 1.0);
}
