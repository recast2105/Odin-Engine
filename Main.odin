// The executable only starts the reusable engine shell.
package Main

import Raylib "vendor:raylib"
import Engine "src/engine"

main :: proc() {
	engine: Engine.Engine

	Engine.Initialize(&engine, Engine.Config {
		Window = {Width = 800, Height = 600, Title = "Odin Engine"},
		Target_FPS = 60,
		Clear_Color = Raylib.GRAY,
		Editor = {Show_Hierarchy = true, Hierarchy_Width = 250},
	})
	defer Engine.Shutdown(&engine)

	Engine.Run(&engine)
}
