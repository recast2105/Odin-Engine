package Mesh

import Core "../core"

Cube :: struct {
	using entity: Core.Entity,
	material:     Core.Material,
	width:        f32,
	height:       f32,
	length:       f32,
}
