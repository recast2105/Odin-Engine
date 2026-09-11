package Editor

import "core:fmt"

import Core "../core"
import Raylib "vendor:raylib"


Hierarchy :: struct {
	position: Raylib.Vector2,
	size:     Raylib.Vector2,
}

DrawHierarchy :: proc(hierarchy: Hierarchy, entities: []Core.Entity) {

	// ---------- Panel ----------

	Raylib.DrawRectangle(
		cast(i32)hierarchy.position.x,
		cast(i32)hierarchy.position.y,
		cast(i32)hierarchy.size.x,
		cast(i32)hierarchy.size.y,
		Raylib.DARKGRAY,
	)

	// ---------- Title ----------	

	Raylib.DrawText(
		"Hierarchy",
		cast(i32)hierarchy.position.x + 10,
		cast(i32)hierarchy.position.y + 10,
		20,
		Raylib.WHITE,
	)

	// ---------- Entities ----------

	y := cast(i32)hierarchy.position.y + 50

	for entity in entities {

		Raylib.DrawText(
			fmt.ctprint(entity.tag),
			cast(i32)hierarchy.position.x + 20,
			y,
			18,
			Raylib.WHITE,
		)

		y += 25
	}
}
