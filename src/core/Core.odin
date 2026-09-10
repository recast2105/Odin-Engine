package Core

import Raylib "vendor:raylib"

Entity :: struct {
	id:       int,
	tag:      string,
	position: [3]f32,
}

Camera3D :: Raylib.Camera3D

// TODO: Create Shaders in Material struct and textures, but for the future
// * Maybe Move Materials to Engine
Material :: struct {
	using color: Raylib.Color,
}
