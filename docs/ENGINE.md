# Engine / Framework

Esta é a documentação de uso do pacote `Engine` em `src/engine`. As instruções
para construir e executar este repositório estão no [README](../README.md).

## Limite entre projeto e engine

Todo o código reutilizável está em `src/engine`, no pacote `Engine`. Ele não
importa `Main.odin` nem código de jogo. O projeto importa a engine e decide se
usa o loop padrão ou controla os próprios frames.

| Arquivo | Responsabilidade |
| --- | --- |
| `Runtime.odin` | Janela, configuração, ciclo de vida e frames. |
| `Scene.odin` | Entidades, transform e registro da cena. |
| `Editor.odin` | Painel Hierarchy opcional. |
| `Camera.odin` | Dados de câmera e controle livre por mouse. |

## Inicialização e loop padrão

O menor programa possível inicializa, executa e encerra a engine:

```odin
engine: Engine.Engine
Engine.Initialize(&engine, Engine.EngineConfig {
	Window = {Width = 800, Height = 600, Title = "Meu projeto"},
	TargetFps = 60,
	ClearColor = Raylib.GRAY,
	Editor = {ShowHierarchy = true, HierarchyWidth = 250},
})
defer Engine.Shutdown(&engine)

Engine.Run(&engine)
```

`Run` não recebe callbacks de jogo. Ele apenas abre os frames e, se ativado,
desenha a Hierarchy. Por isso o `Main.odin` atual pode permanecer somente como
o inicializador do framework.

## Estrutura recomendada para um projeto

Não concentre a lógica em `Main.odin`. Use-o apenas como ponto de entrada e
crie um pacote da aplicação para guardar o estado, a criação da cena e os
sistemas do projeto:

```text
Main.odin           ponto de entrada
src/app/App.odin    ciclo de vida e estado da aplicação
src/app/Game.odin   regras, sistemas e objetos do projeto
src/engine/         framework reutilizável
```

### Main mínimo

```odin
package Main

import App "src/app"

main :: proc() {
    App.Run()
}
```

### Aplicação dona da lógica

O código abaixo é um ponto de partida para `src/app/App.odin`. A aplicação
conhece a engine; a engine continua sem conhecer a aplicação.

```odin
package App

import Raylib "vendor:raylib"
import Engine "src/engine"

Application :: struct {
    engine: Engine.Engine,
}

Run :: proc() {
    app: Application
    Engine.Initialize(&app.engine, Engine.EngineConfig {
        Window = {Width = 1280, Height = 720, Title = "Meu projeto"},
        TargetFps = 60,
        ClearColor = Raylib.Color {13, 16, 22, 255},
        Editor = {ShowHierarchy = true, HierarchyWidth = 280},
    })
    defer Engine.Shutdown(&app.engine)

    CreateScene(&app)

    for !Engine.ShouldClose(&app.engine) {
        Update(&app)

        Engine.BeginFrame(&app.engine)
        Engine.DrawEditor(app.engine.Config.Editor, &app.engine.Scene)
        Render(&app) // adicione a renderização do projeto aqui quando existir
        Engine.EndFrame()
    }
}

CreateScene :: proc(app: ^Application) {
    Engine.CreateEntity(&app.engine.Scene, "Player")
    Engine.CreateEntity(&app.engine.Scene, "Main Camera")
}

Update :: proc(app: ^Application) {
    // Atualização de input, regras e sistemas do projeto.
}

Render :: proc(app: ^Application) {
    // Renderização específica do projeto.
}
```

Use arquivos adicionais dentro de `src/app` quando o projeto crescer. Por
exemplo, `Player.odin`, `World.odin` ou `Game.odin` podem conter as regras
específicas, recebendo apenas o estado que precisam em vez de colocar tudo em
`App.odin`.

## Cena e Hierarchy

Crie entidades usando a cena da instância:

```odin
player := Engine.CreateEntity(&engine.Scene, "Player")
camera := Engine.CreateEntity(&engine.Scene, "Main Camera")
```

Cada chamada gera um identificador sequencial, registra a entidade e a torna
visível na Hierarchy automaticamente. A entidade possui `ID`, `Name` e
`Transform`; atualmente o transform contém somente `Position`.

`RegisterEntity` também aceita uma `Entity` pronta. Ele é uma operação de
baixo nível e não valida IDs repetidos; prefira `CreateEntity` para os
objetos normais do projeto. `GetEntities` expõe uma visão da lista para
interfaces como uma Hierarchy customizada.

## Loop próprio do projeto

Quando houver lógica de jogo, o projeto pode substituir o loop padrão sem a
engine precisar conhecer essa lógica:

```odin
for !Engine.ShouldClose(&engine) {
    // update do projeto

    Engine.BeginFrame(&engine)
    Engine.DrawEditor(engine.Config.Editor, &engine.Scene)
    // render do projeto
    Engine.EndFrame()
}
```

Chame `Engine.Shutdown` ao final para liberar a cena e fechar a janela.

## Estado atual

Esta é uma fundação mínima. Ela ainda não inclui componentes, serialização de
cenas, carregamento de assets, física ou renderer de meshes. Esses recursos
podem ser adicionados como módulos da engine sem colocar código do projeto em
`src/engine`.
