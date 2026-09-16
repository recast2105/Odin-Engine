package Engine

/// Representa um objeto registrado em uma Scene.
Entity :: struct {
	/// Identificador da entidade dentro da cena.
	ID:        int,
	/// Nome exibido pela Hierarchy e usado para identificação humana.
	Name:      string,
	/// Transformação espacial básica da entidade.
	Transform: Transform,
}

/// Contém os dados espaciais básicos de uma Entity.
Transform :: struct {
	/// Posição XYZ da entidade no mundo.
	Position: [3]f32,
}

/// Armazena as entidades de uma cena e controla a geração de IDs.
Scene :: struct {
	entities:       [dynamic]Entity,
	nextEntityId: int,
}

/// Registra uma Entity já construída na Scene.
/// Esta operação não verifica IDs duplicados; use CreateEntity quando possível.
RegisterEntity :: proc(scene: ^Scene, entity: Entity) { append(&scene.entities, entity) }

/// Cria, registra e retorna uma Entity com ID gerado automaticamente.
/// A entidade passa a aparecer na Hierarchy quando ela estiver habilitada.
CreateEntity :: proc(scene: ^Scene, name: string) -> Entity {
	entity := Entity {ID = scene.nextEntityId, Name = name}
	scene.nextEntityId += 1
	RegisterEntity(scene, entity)
	return entity
}

/// Retorna uma visão das entidades registradas, útil para interfaces customizadas.
GetEntities :: proc(scene: ^Scene) -> []Entity { return scene.entities[:] }

/// Remove todas as entidades da Scene e reinicia a sequência de IDs.
ClearScene :: proc(scene: ^Scene) {
	delete(scene.entities)
	scene.nextEntityId = 0
}
