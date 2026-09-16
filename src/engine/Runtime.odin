package Engine

import Raylib "vendor:raylib"

/// Define as propriedades da janela criada pela engine.
WindowConfig :: struct {
	/// Largura inicial da janela, em pixels.
	Width:  i32,
	/// Altura inicial da janela, em pixels.
	Height: i32,
	/// Título exibido pela janela.
	Title:  cstring,
}

/// Agrupa toda a configuração necessária para inicializar uma Engine.
EngineConfig :: struct {
	/// Propriedades da janela de execução.
	Window:     WindowConfig,
	/// Limite desejado de quadros por segundo.
	TargetFps:  i32,
	/// Cor usada para limpar a tela no início de cada frame.
	ClearColor: Raylib.Color,
	/// Configuração das ferramentas visuais básicas da engine.
	Editor:     EditorConfig,
}

/// Mantém o estado reutilizável do runtime, da cena e do editor.
/// A Engine nunca importa ou depende de código da aplicação.
Engine :: struct {
	/// Configuração aplicada durante a inicialização.
	Config:    EngineConfig,
	/// Cena ativa, onde as entidades são registradas.
	Scene:     Scene,
	/// Indica se a janela e os recursos da engine ainda estão ativos.
	IsRunning: bool,
}

/// Cria a janela e prepara a instância para executar frames.
/// Deve ser chamado uma vez antes de qualquer outra operação da engine.
Initialize :: proc(engine: ^Engine, config: EngineConfig) {
	engine.Config = config
	Raylib.InitWindow(config.Window.Width, config.Window.Height, config.Window.Title)
	Raylib.SetTargetFPS(config.TargetFps)
	engine.IsRunning = true
}

/// Retorna true quando a janela foi fechada ou a engine foi encerrada.
ShouldClose :: proc(engine: ^Engine) -> bool {
	return !engine.IsRunning || Raylib.WindowShouldClose()
}

/// Retorna a duração, em segundos, do último frame renderizado.
DeltaTime :: proc() -> f32 {return Raylib.GetFrameTime()}

/// Inicia um frame e limpa a tela com EngineConfig.ClearColor.
/// Todo BeginFrame deve ser finalizado com EndFrame.
BeginFrame :: proc(engine: ^Engine) {
	Raylib.BeginDrawing()
	Raylib.ClearBackground(engine.Config.ClearColor)
}

/// Finaliza o frame aberto por BeginFrame e o apresenta na janela.
EndFrame :: proc() {Raylib.EndDrawing()}

/// Executa o loop padrão sem callbacks de projeto.
/// O loop desenha somente o editor básico configurado e termina ao fechar a janela.
/// Projetos com lógica própria podem usar BeginFrame e EndFrame diretamente.
Run :: proc(engine: ^Engine) {
	for !ShouldClose(engine) {
		BeginFrame(engine)
		DrawEditor(engine.Config.Editor, &engine.Scene)
		EndFrame()
	}
}

/// Libera a cena, encerra a instância e fecha a janela.
/// É seguro chamar mais de uma vez; chamadas posteriores não fazem nada.
Shutdown :: proc(engine: ^Engine) {
	if !engine.IsRunning {return}
	ClearScene(&engine.Scene)
	engine.IsRunning = false
	Raylib.CloseWindow()
}
