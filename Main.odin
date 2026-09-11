package Main

import "core:fmt"

import Raylib "vendor:raylib"


// ---------- Custom Packages ----------

import Core "src/core"
import Editor "src/editor"
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
_coreCamera := Core.Camera {
	id         = 1,
	tag        = "Camera",
	position   = {0.0, 10.0, 10.0},
	target     = {0.0, 10.0, 9.0},
	up         = {0.0, 1.0, 0.0},
	fovy       = 45.0,
	projection = .PERSPECTIVE,
}

@(private)
_cameraController := Core.CameraController {
	yaw         = -1.57,
	pitch       = 0.0,
	sensitivity = 0.01,
}

@(private)
_hierarchy := Editor.Hierarchy {
	position = {0, 0},
	size     = {250, 600},
}

// ! Test Cube
@(private)
_myCube := Mesh.Cube {
	id = 0,
	tag = "Cube",
	transform = {position = {0, 0, 0}},
	material = {color = Raylib.RED},
	width = 2.0,
	height = 0.2,
	length = 2.0,
}

main :: proc() {

	_coreEngine.Start()
	_coreEngine.Update()
}

// Initialization Scripts
Start :: proc() {

	Raylib.InitWindow(_coreWindow.width, _coreWindow.heigth, _coreWindow.title)

	// Register world entity
	// ! * Test
	Engine.AppendEntity(_coreCamera.entity)
	Engine.AppendEntity(_myCube.entity)

	Raylib.HideCursor()

	_coreEngine.lightingShader = Raylib.LoadShader(
		Engine.LIGHTING_VERTEX_PATH,
		Engine.LIGHTING_FRAGMENT_PATH,
	)

	Raylib.SetTargetFPS(Engine.TARGET_FPS)
}


// Update the logic scripts
Update :: proc() {

	defer Raylib.CloseWindow()

	for !Raylib.WindowShouldClose() {

		Core.UpdateCameraRotation(&_coreCamera, &_cameraController)

		// ! Test Hierarchy
		if (Raylib.IsKeyPressed(.A)) {
			Engine.AppendEntity(_myCube)
		}

		Raylib.BeginDrawing()

		Raylib.ClearBackground(Raylib.GRAY)

		Raylib.BeginMode3D(_coreCamera)

		normalizedColor := Raylib.ColorNormalize(_myCube.material.color)

		Raylib.SetShaderValue(
			_coreEngine.lightingShader,
			Raylib.GetShaderLocation(_coreEngine.lightingShader, "objectColor"),
			&Raylib.Vector3{normalizedColor.x, normalizedColor.y, normalizedColor.z},
			.VEC3,
		)

		Raylib.SetShaderValue(
			_coreEngine.lightingShader,
			Raylib.GetShaderLocation(_coreEngine.lightingShader, "cameraPosition"),
			&_coreCamera.position,
			.VEC3,
		)

		Raylib.BeginShaderMode(_coreEngine.lightingShader)

		Raylib.DrawCube(
			_myCube.transform.position,
			_myCube.width,
			_myCube.height,
			_myCube.length,
			_myCube.material.color,
		)

		Raylib.EndShaderMode()

		Raylib.EndMode3D()

		// ---------- Editor UI ----------

		Editor.DrawHierarchy(_hierarchy, Engine.Entities[:])

		Raylib.DrawText(fmt.ctprint("FPS:", Raylib.GetFPS()), 260, 10, 20, Raylib.GREEN)

		Raylib.EndDrawing()
	}
}
