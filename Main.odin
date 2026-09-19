// The executable only starts the reusable engine shell.
package Main

import OdinEngine "src/engine"
import Raylib "vendor:raylib"

main :: proc() {
	engine: OdinEngine.Engine

	camera: OdinEngine.Camera = {
		Data = {
			position = {10, 10, 10},
			fovy = 45,
			projection = .ORTHOGRAPHIC,
			up = OdinEngine.Vector3Up(),
			target = {0, 0, 0},
		},
	}

	OdinEngine.Initialize(
		&engine,
		OdinEngine.EngineConfig {
			Window = {Width = 800, Height = 600, Title = "Odin Engine"},
			TargetFps = 60,
			ClearColor = Raylib.Color{13, 16, 22, 255},
			Editor = {ShowHierarchy = true, HierarchyWidth = 280},
		},
	)

	defer OdinEngine.Shutdown(&engine)

	for !OdinEngine.ShouldClose(&engine) {

		OdinEngine.BeginFrame(&engine)
		OdinEngine.DrawEditor(engine.Config.Editor, &engine.Scene)

		OdinEngine.BeginMode3D(camera)

		Raylib.DrawGrid(20, 1)

		OdinEngine.EndMode3D()

		OdinEngine.EndFrame()
	}
}
