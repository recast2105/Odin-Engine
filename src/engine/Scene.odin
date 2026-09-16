package Engine

Entity :: struct {
	ID:        int,
	Name:      string,
	Transform: Transform,
}

Transform :: struct { Position: [3]f32 }

Scene :: struct {
	entities:       [dynamic]Entity,
	next_entity_id: int,
}

Scene_Register :: proc(scene: ^Scene, entity: Entity) { append(&scene.entities, entity) }

// Every entity created by the scene is automatically visible to the hierarchy.
Scene_Create_Entity :: proc(scene: ^Scene, name: string) -> Entity {
	entity := Entity {ID = scene.next_entity_id, Name = name}
	scene.next_entity_id += 1
	Scene_Register(scene, entity)
	return entity
}

Scene_Entities :: proc(scene: ^Scene) -> []Entity { return scene.entities[:] }

Scene_Clear :: proc(scene: ^Scene) {
	delete(scene.entities)
	scene.next_entity_id = 0
}
