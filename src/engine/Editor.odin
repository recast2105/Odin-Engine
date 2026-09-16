package Engine

import "core:fmt"
import Raylib "vendor:raylib"

editorBackground :: Raylib.Color {18, 22, 30, 255}
editorHeader :: Raylib.Color {29, 35, 47, 255}
editorSurface :: Raylib.Color {36, 43, 57, 255}
editorRow :: Raylib.Color {31, 37, 49, 255}
editorAccent :: Raylib.Color {79, 156, 249, 255}
editorText :: Raylib.Color {226, 232, 240, 255}
editorMutedText :: Raylib.Color {143, 155, 179, 255}

/// Controla as ferramentas visuais básicas fornecidas pela engine.
EditorConfig :: struct {
	/// Quando true, a Hierarchy é desenhada em cada frame.
	ShowHierarchy: bool,
	/// Largura do painel em pixels. Valores menores ou iguais a zero usam 250.
	HierarchyWidth: i32,
}

/// Desenha as ferramentas do editor habilitadas para a Scene informada.
/// Atualmente inclui apenas a Hierarchy, que lista as entidades registradas.
DrawEditor :: proc(config: EditorConfig, scene: ^Scene) {
	if !config.ShowHierarchy {
		return
	}

	width := config.HierarchyWidth
	if width <= 0 {
		width = 250
	}

	screen_height := Raylib.GetScreenHeight()
	entity_count := len(scene.entities)

	// Panel and header.
	Raylib.DrawRectangle(0, 0, width, screen_height, editorBackground)
	Raylib.DrawRectangle(0, 0, width, 64, editorHeader)
	Raylib.DrawRectangle(0, 0, 4, 64, editorAccent)
	Raylib.DrawLine(width, 0, width, screen_height, editorSurface)

	Raylib.DrawText("SCENE", 18, 13, 22, editorText)
	Raylib.DrawText("HIERARCHY", 18, 38, 10, editorMutedText)
	Raylib.DrawText(fmt.ctprint(entity_count), width - 30, 21, 16, editorAccent)

	// Visual filter field. Filtering can be added later without changing the layout.
	Raylib.DrawRectangle(14, 78, width - 28, 32, editorSurface)
	Raylib.DrawText("Filter entities...", 26, 87, 13, editorMutedText)
	Raylib.DrawText("OBJECTS", 18, 126, 11, editorMutedText)

	y: i32 = 146
	row_index := 0
	for entity in scene.entities {
		if y + 36 > screen_height - 42 {
			break
		}

		if row_index % 2 == 0 {
			Raylib.DrawRectangle(10, y, width - 20, 34, editorRow)
		}

		Raylib.DrawCircle(29, y + 17, 5, editorAccent)
		Raylib.DrawText(fmt.ctprint(entity.Name), 44, y + 9, 16, editorText)
		Raylib.DrawText(fmt.ctprint("#", entity.ID), width - 44, y + 11, 12, editorMutedText)
		y += 36
		row_index += 1
	}

	if entity_count == 0 {
		Raylib.DrawText("No objects yet", 18, 160, 17, editorText)
		Raylib.DrawText("CreateEntity() adds them here.", 18, 185, 12, editorMutedText)
	}

	// Status footer stays visible regardless of the number of entities.
	Raylib.DrawRectangle(0, screen_height - 36, width, 36, editorHeader)
	Raylib.DrawCircle(20, screen_height - 18, 4, Raylib.GREEN)
	Raylib.DrawText("ENGINE READY", 32, screen_height - 24, 12, editorText)
	Raylib.DrawText(fmt.ctprint(Raylib.GetFPS(), " FPS"), width - 62, screen_height - 24, 12, editorMutedText)
}
