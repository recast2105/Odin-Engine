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
Engine.Initialize(&engine, Engine.Config {
    Window = {Width = 800, Height = 600, Title = "Meu projeto"},
    Target_FPS = 60,
    Clear_Color = Raylib.GRAY,
    Editor = {Show_Hierarchy = true, Hierarchy_Width = 250},
})
defer Engine.Shutdown(&engine)

Engine.Run(&engine)
```

`Run` não recebe callbacks de jogo. Ele apenas abre os frames e, se ativado,
desenha a Hierarchy. Por isso o `Main.odin` atual pode permanecer somente como
o inicializador do framework.

## Cena e Hierarchy

Crie entidades usando a cena da instância:

```odin
player := Engine.Scene_Create_Entity(&engine.Scene, "Player")
camera := Engine.Scene_Create_Entity(&engine.Scene, "Main Camera")
```

Cada chamada gera um identificador sequencial, registra a entidade e a torna
visível na Hierarchy automaticamente. A entidade possui `ID`, `Name` e
`Transform`; atualmente o transform contém somente `Position`.

`Scene_Register` também aceita uma `Entity` pronta. Ele é uma operação de
baixo nível e não valida IDs repetidos; prefira `Scene_Create_Entity` para os
objetos normais do projeto. `Scene_Entities` expõe uma visão da lista para
interfaces como uma Hierarchy customizada.

## Loop próprio do projeto

Quando houver lógica de jogo, o projeto pode substituir o loop padrão sem a
engine precisar conhecer essa lógica:

```odin
for !Engine.Should_Close(&engine) {
    // update do projeto

    Engine.Begin_Frame(&engine)
    Engine.Editor_Draw(engine.Config.Editor, &engine.Scene)
    // render do projeto
    Engine.End_Frame()
}
```

Chame `Engine.Shutdown` ao final para liberar a cena e fechar a janela.

## Estado atual

Esta é uma fundação mínima. Ela ainda não inclui componentes, serialização de
cenas, carregamento de assets, física ou renderer de meshes. Esses recursos
podem ser adicionados como módulos da engine sem colocar código do projeto em
`src/engine`.
