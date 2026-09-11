package Core

import Math "core:math"
import Raylib "vendor:raylib"

CameraController :: struct {
	yaw:         f32,
	pitch:       f32,
	sensitivity: f32,
}

UpdateCameraRotation :: proc(camera: ^Raylib.Camera3D, controller: ^CameraController) {

	mouse_delta := Raylib.GetMouseDelta()

	controller.yaw += mouse_delta.x * controller.sensitivity
	controller.pitch -= mouse_delta.y * controller.sensitivity

	direction := Raylib.Vector3 {
		Math.cos(controller.yaw) * Math.cos(controller.pitch),
		Math.sin(-controller.pitch),
		Math.sin(controller.yaw) * Math.cos(controller.pitch),
	}

	camera.target = camera.position + direction
}
