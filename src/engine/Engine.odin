package Engine

import Core "../core"
import Raylib "vendor:raylib"

TARGET_FPS :: 60

// ! Temp path for now
LIGHTING_VERTEX_PATH :: "shaders/LightingVertex.glsl"
LIGHTING_FRAGMENT_PATH :: "shaders/LightingFragmengt.glsl"

Engine :: struct {
	Start:            proc(),
	Update:           proc(),
	using basicLight: Shaders,
}

@(private)
//! Don't want have direct access to the light shader for now
Shaders :: struct {
	lightingShader: Raylib.Shader,
}

// TODO: Create Shaders in Material struct and textures, but for the future
Material :: struct {
	using color: Raylib.Color,
}

// To store all 3D Objects and apply the shaders
ArrayWorldObjectsMaterial: [dynamic]Material

AppendArrayWorldObjects :: proc(entities: Material) {
	append(&ArrayWorldObjectsMaterial, entities)
}
