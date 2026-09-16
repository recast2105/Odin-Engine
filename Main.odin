// The executable only starts the reusable engine shell.
package Main

import OdinEngine "src/engine"
import Raylib "vendor:raylib"

main :: proc() {
	engine: OdinEngine.Engine

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

	OdinEngine.Run(&engine)
}
