package Mesh

import CoreEntity "../core"
import Raylib "vendor:raylib"

Cube :: struct {
	using entity: CoreEntity.Entity,
	color:        Raylib.Color,
	width:        f32,
	height:       f32,
	length:       f32,
}
