package Engine

import Math "core:math"
import Raylib "vendor:raylib"

/// Encapsula a câmera 3D do Raylib para uso pelos futuros módulos de renderização.
Camera :: struct {
	/// Dados da câmera compatíveis com Raylib.Camera3D.
	Data: Raylib.Camera3D,
}

/// Guarda o estado de rotação usado por UpdateFreeCamera.
CameraController :: struct {
	/// Rotação horizontal, em radianos.
	Yaw:         f32,
	/// Rotação vertical, em radianos.
	Pitch:       f32,
	/// Multiplicador aplicado ao movimento do mouse.
	Sensitivity: f32,
}

/// Atualiza o alvo da câmera de acordo com o deslocamento atual do mouse.
/// A posição da câmera não é alterada por esta função.
UpdateFreeCamera :: proc(camera: ^Camera, controller: ^CameraController) {
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
