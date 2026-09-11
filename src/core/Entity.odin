package Core

Entity :: struct {
	id:        int,
	tag:       string,
	transform: Transform,
}

Transform :: struct {
	position: [3]f32,
}
