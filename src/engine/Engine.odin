package Engine

import Core "../core"
import Raylib "vendor:raylib"

TARGET_FPS :: 60

LIGHTING_VERTEX_PATH :: "shaders/LightingVertex.glsl"
LIGHTING_FRAGMENT_PATH :: "shaders/LightingFragmengt.glsl"

Engine :: struct {
	Start:            proc(),
	Update:           proc(),
	using basicLight: Shaders,
}


Shaders :: struct {
	lightingShader: Raylib.Shader,
}


Material :: struct {
	using color: Raylib.Color,
}

// ---------- World Entities ----------

Entities: [dynamic]Core.Entity


AppendEntity :: proc(entity: Core.Entity) {

	append(&Entities, entity)
}
