package Main

import "core:fmt"
import Render "src/render"
import Window "src/window"
import Raylib "vendor:raylib"
import "vendor:raylib/rlgl"

// TODO: Find how to draw a cube and show in the screen

@(private)
_game := Render.Engine {
	Start  = Start,
	Update = Update,
}

@(private)
_engineWindow := Window.WindowConfiguration {
	width  = 800,
	heigth = 600,
	title  = "Odin Engine",
}

@(private)
_delta := Raylib.GetFrameTime()

camera := Raylib.Camera3D {
	position   = {0.0, 10.0, 10.0},
	target     = _myCube.position,
	up         = {0.0, 1.0, 0.0},
	fovy       = 45.0,
	projection = .PERSPECTIVE,
}

main :: proc() {
	_game.Start()
	_game.Update(_delta)
}

Start :: proc() {
	Raylib.InitWindow(_engineWindow.width, _engineWindow.heigth, _engineWindow.title)

	_game.lightingShader = Raylib.LoadShader(
		Render.LIGHTING_VERTEX_PATH,
		Render.LIGHTING_FRAGMENT_PATH,
	)

	if Raylib.IsShaderValid(_game.lightingShader) {
		fmt.println("Shaders loaded with success")
	}

	Raylib.SetTargetFPS(Render.TARGET_FPS)

}

//! Temp to test draw cube
Cube :: struct {
	position: Raylib.Vector3,
	color:    Raylib.Color,
	width:    f32,
	height:   f32,
	length:   f32,
}

@(private)
_myCube := Cube {
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

		Raylib.BeginMode3D(camera)

		normalizedColor: Raylib.Vector4 = Raylib.ColorNormalize(_myCube.color)

		Raylib.SetShaderValue(
			_game.lightingShader,
			Raylib.GetShaderLocation(_game.lightingShader, "objectColor"),
			&Raylib.Vector3{normalizedColor.x, normalizedColor.y, normalizedColor.z},
			Raylib.ShaderUniformDataType.VEC3,
		)
		Raylib.BeginShaderMode(_game.lightingShader)

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
