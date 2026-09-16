package Engine

import "core:fmt"
import Raylib "vendor:raylib"

Editor_Config :: struct {
	Show_Hierarchy: bool,
	Hierarchy_Width: i32,
}

Editor_Draw :: proc(config: Editor_Config, scene: ^Scene) {
	if !config.Show_Hierarchy {
		return
	}

	width := config.Hierarchy_Width
	if width <= 0 {
		width = 250
	}

	Raylib.DrawRectangle(0, 0, width, Raylib.GetScreenHeight(), Raylib.DARKGRAY)
	Raylib.DrawText("Hierarchy", 10, 10, 20, Raylib.WHITE)

	y: i32 = 50
	for entity in scene.entities {
		Raylib.DrawText(fmt.ctprint(entity.Name), 20, y, 18, Raylib.WHITE)
		y += 25
	}
}
