package Engine

import Raylib "vendor:raylib"

TARGET_FPS :: 60

// ! Temp path for now
LIGHTING_VERTEX_PATH :: "shaders/LightingVertex.glsl"
LIGHTING_FRAGMENT_PATH :: "shaders/LightingFragmengt.glsl"

Engine :: struct {
	Start:            proc(),
	Update:           proc(_: f32),
	using basicLight: Shaders,
}

@(private)
//! Don't want have direct access to the light shader for now
Shaders :: struct {
	lightingShader: Raylib.Shader,
}
