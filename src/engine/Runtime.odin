package Engine

import Raylib "vendor:raylib"

Window_Config :: struct {
	Width:  i32,
	Height: i32,
	Title:  cstring,
}

Config :: struct {
	Window:      Window_Config,
	Target_FPS:  i32,
	Clear_Color: Raylib.Color,
	Editor:      Editor_Config,
}

// Engine owns only reusable runtime state. It never imports application code.
Engine :: struct {
	Config:     Config,
	Scene:      Scene,
	Is_Running: bool,
}

Initialize :: proc(engine: ^Engine, config: Config) {
	engine.Config = config
	Raylib.InitWindow(config.Window.Width, config.Window.Height, config.Window.Title)
	Raylib.SetTargetFPS(config.Target_FPS)
	engine.Is_Running = true
}

Should_Close :: proc(engine: ^Engine) -> bool {
	return !engine.Is_Running || Raylib.WindowShouldClose()
}

Delta_Time :: proc() -> f32 { return Raylib.GetFrameTime() }

Begin_Frame :: proc(engine: ^Engine) {
	Raylib.BeginDrawing()
	Raylib.ClearBackground(engine.Config.Clear_Color)
}

End_Frame :: proc() { Raylib.EndDrawing() }

// Run is intentionally callback-free. Projects can use it while they need
// only the engine shell; later they can own their own loop using Begin_Frame.
Run :: proc(engine: ^Engine) {
	for !Should_Close(engine) {
		Begin_Frame(engine)
		Editor_Draw(engine.Config.Editor, &engine.Scene)
		End_Frame()
	}
}

Shutdown :: proc(engine: ^Engine) {
	if !engine.Is_Running { return }
	Scene_Clear(&engine.Scene)
	engine.Is_Running = false
	Raylib.CloseWindow()
}
