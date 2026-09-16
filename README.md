# Odin Engine

Este repositório compila um executável mínimo que inicializa e executa a
engine. Não há objetos ou renderização de demonstração no projeto inicial.

## Requisito

O compilador [Odin](https://odin-lang.org/) precisa estar disponível no `PATH`
como `odin`. A engine usa o pacote `vendor:raylib` distribuído com o ambiente
Odin.

Execute os comandos a partir da raiz do repositório.

## Makefile

| Comando | Resultado |
| --- | --- |
| `make` ou `make check` | Verifica tipos e sintaxe, sem criar executável. |
| `make build` | Verifica e gera `/tmp/odin-engine-sandbox`. |
| `make run` | Verifica, compila e abre a janela. Feche-a para encerrar. |

Equivalentes sem Makefile:

```sh
odin check .
odin run .
```

## Arquitetura do projeto

```text
Main.odin          Executável: configura, inicializa e executa a engine
src/engine/        Pacote reutilizável Engine
docs/ENGINE.md     Referência de API e guia de uso da engine
```

`Main.odin` não contém entidades de teste nem lógica de jogo. Ele chama
`Engine.Initialize`, `Engine.Run` e `Engine.Shutdown`. O loop padrão abre uma
janela cinza e, quando habilitado na configuração, mostra uma Hierarchy vazia.

O pacote em `src/engine` não importa `Main.odin` ou código de projeto. Para
entender os módulos e usar a engine em outro projeto, consulte a
[documentação da engine](docs/ENGINE.md).
