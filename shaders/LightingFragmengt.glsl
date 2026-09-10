#version 330

uniform vec3 objectColor;
uniform vec3 cameraPosition;

out vec4 FragColor;

in vec3 FragPosition;
in vec3 FragNormal;

void main() {
    vec3 lightPosition = vec3(0.0, 8.0, -8.0);

    // Light effect 100%
    vec3 lightAmbient = vec3(1.0, 1.0, 1.0);
    vec3 lightDiffuse = vec3(1.0, 1.0, 1.0);
    vec3 lightDirection = normalize(FragPosition - lightPosition);
    vec3 lightSpecular = vec3(0.5, 0.5, 0.5);

    // Ambient color of the object effect 40%
    vec3 objectAmbient = vec3(0.4, 0.4, 0.4);
    // Diffuse light in the object effect 50%
    vec3 objectDiffuse = vec3(0.5, 0.5, 0.5);
    vec3 objectSpecular = vec3(1.0, 1.0, 1.0);

    vec3 ambient = lightAmbient * objectAmbient;
    float diff = max(dot(FragNormal, -lightDirection), 0);
    vec3 diffuse = diff * lightDiffuse * objectDiffuse;

    vec3 viewDirection = normalize(cameraPosition - FragPosition);
    vec3 reflectDirection = reflect(lightDirection, FragNormal);
    float spec = pow(max(dot(viewDirection, reflectDirection), 0), 32);
    vec3 specular = spec * lightSpecular * objectSpecular;

    FragColor = vec4((ambient + diffuse + specular) * objectColor, 1.0);
}
