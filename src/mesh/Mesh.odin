package Mesh

import Core "../core"
import Engine "../engine"


Cube :: struct {
	using entity: Core.Entity,
	material:     Engine.Material,
	width:        f32,
	height:       f32,
	length:       f32,
}

