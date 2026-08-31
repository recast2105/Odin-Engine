package Render

import Raylib "vendor:raylib"

TARGET_FPS :: 60

LIGHTING_VERTEX_PATH :: "shaders/LightingVertex.glsl"
LIGHTING_FRAGMENT_PATH :: "shaders/LightingFragmengt.glsl"

Engine :: struct {
	Start:            proc(),
	Update:           proc(_: f32),
	using basicLight: BasicLight,
}


@(private)
//! Don't want have direct access to the light shader for now
BasicLight :: struct {
	lightingShader: Raylib.Shader,
}
