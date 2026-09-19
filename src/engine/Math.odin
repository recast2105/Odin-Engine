package Engine

Vector3Forward :: proc() -> [3]f32 {
	return {0, 0, 1}
}

Vector3Back :: proc() -> [3]f32 {
	return {0, 0, -1}
}

Vector3Up :: proc() -> [3]f32 {
	return {0, 1, 0}
}

Vector3Down :: proc() -> [3]f32 {
	return {0, -1, 0}
}
