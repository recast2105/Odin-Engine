package Engine

import Math "core:math"
import Raylib "vendor:raylib"

Camera :: struct { Data: Raylib.Camera3D }

Camera_Controller :: struct {
	Yaw:         f32,
	Pitch:       f32,
	Sensitivity: f32,
}

Update_Free_Camera :: proc(camera: ^Camera, controller: ^Camera_Controller) {
	mouse_delta := Raylib.GetMouseDelta()
	controller.Yaw += mouse_delta.x * controller.Sensitivity
	controller.Pitch -= mouse_delta.y * controller.Sensitivity

	direction := Raylib.Vector3 {
		Math.cos(controller.Yaw) * Math.cos(controller.Pitch),
		Math.sin(controller.Pitch),
		Math.sin(controller.Yaw) * Math.cos(controller.Pitch),
	}
	camera.Data.target = camera.Data.position + direction
}
