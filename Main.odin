package Main

import "core:fmt"
import Render "src/render"
import Window "src/window"
import Raylib "vendor:raylib"

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
	target     = CubePosition,
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
	Raylib.SetTargetFPS(Render.TARGET_FPS)
}

CubePosition := Raylib.Vector3{0.0, 0.0, 0.0}

Update :: proc(delta: f32) {

	defer Raylib.CloseWindow()
	for !Raylib.WindowShouldClose() {

		Raylib.BeginDrawing()
		Raylib.ClearBackground(Raylib.GRAY)

		Raylib.BeginMode3D(camera)

		Raylib.DrawCube(CubePosition, 2.0, 2.0, 2.0, Raylib.RED)

		Raylib.EndMode3D()

		Raylib.DrawText(fmt.ctprint("FPS:", Raylib.GetFPS()), 10, 10, 20, Raylib.GREEN)
		Raylib.EndDrawing()
	}
}
