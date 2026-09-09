package Main

import "core:fmt"
import Raylib "vendor:raylib"

// ---------- custom package ----------

import Camera "src/core"
import Engine "src/engine"
import Mesh "src/mesh"
import Window "src/window"

@(private)
_coreEngine := Engine.Engine {
	Start  = Start,
	Update = Update,
}

@(private)
_coreWindow := Window.WindowConfiguration {
	width  = 800,
	heigth = 600,
	title  = "Odin Engine",
}

@(private)
_delta := Raylib.GetFrameTime()

@(private)
_coreCamera := Camera.Camera3D {
	position   = {0.0, 10.0, 10.0},
	target     = _myCube.position,
	up         = {0.0, 1.0, 0.0},
	fovy       = 45.0,
	projection = .PERSPECTIVE,
}

main :: proc() {
	_coreEngine.Start()
	_coreEngine.Update(_delta)
}

Start :: proc() {
	Raylib.InitWindow(_coreWindow.width, _coreWindow.heigth, _coreWindow.title)

	_coreEngine.lightingShader = Raylib.LoadShader(
		Engine.LIGHTING_VERTEX_PATH,
		Engine.LIGHTING_FRAGMENT_PATH,
	)

	Raylib.SetTargetFPS(Engine.TARGET_FPS)
}

@(private)
_myCube := Mesh.Cube {
	position = {0, 0, 0},
	color    = Raylib.RED,
	width    = 2.0,
	height   = 2.0,
	length   = 2.0,
}

Update :: proc(delta: f32) {

	defer Raylib.CloseWindow()
	for !Raylib.WindowShouldClose() {

		Raylib.BeginDrawing()
		Raylib.ClearBackground(Raylib.GRAY)

		Raylib.BeginMode3D(_coreCamera)

		normalizedColor: Raylib.Vector4 = Raylib.ColorNormalize(_myCube.color)
		Raylib.SetShaderValue(
			_coreEngine.lightingShader,
			Raylib.GetShaderLocation(_coreEngine.lightingShader, "objectColor"),
			&Raylib.Vector3{normalizedColor.x, normalizedColor.y, normalizedColor.z},
			Raylib.ShaderUniformDataType.VEC3,
		)

		Raylib.BeginShaderMode(_coreEngine.lightingShader)

		Raylib.DrawCube(
			_myCube.position,
			_myCube.width,
			_myCube.height,
			_myCube.length,
			_myCube.color,
		)

		Raylib.EndShaderMode()

		Raylib.EndMode3D()

		Raylib.DrawText(fmt.ctprint("FPS:", Raylib.GetFPS()), 10, 10, 20, Raylib.GREEN)
		Raylib.EndDrawing()
	}
}
