module tedit.app;

import tedit.editor.editor;
import tedit.editor.logger;
import tedit.editor.clipboard;
import tedit.editor.ui.renderer;
import tedit.editor.config.settings;
import tedit.editor.ui.input;

import aurorafw.core.appcontext;
import aurorafw.core.input.manager;

import core.thread : Thread;
import core.time : dur;

class TeditApplication : ApplicationContext {
	this(string[] args)
	{
		super("org.aurorafoss.app.tedit", args);
		import std.process : environment;
		version(Posix) this.path = environment.get("HOME") ~ "/.config/tedit/";
	}

	override void onStart() {
		this._logger = new Logger(this);
		this._settings = new Settings(this);
		this._clipboard = new ClipboardManager(this);
		this._input = InputManager();
		this._input.addRawListener(new TeditInputListener(this));
		this._editor = new Editor(this);
		this._renderer = new Renderer(this);
		this._renderer.terminal.input.keyPressedCallback = &this._input.keyPressed;
	}

	pragma(inline)
	override void loop() {
		if(!_renderer.shouldRender)
			this.stop();
		else {
			_renderer.render();
			Thread.sleep(dur!"msecs"(1));
		}
	}

	pragma(inline)
	@property Settings settings()
	{
		return this._settings;
	}

	pragma(inline)
	@property Logger logger()
	{
		return this._logger;
	}


	pragma(inline)
	@property ClipboardManager clipboard()
	{
		return this._clipboard;
	}


	pragma(inline)
	@property InputManager input()
	{
		return this._input;
	}


	pragma(inline) @trusted
	@property Renderer renderer()
	{
		return this._renderer;
	}

	public immutable string path;

	private Logger _logger;
	private ClipboardManager _clipboard;
	private Editor _editor;
	private Settings _settings;
	private Renderer _renderer;
	private InputManager _input;
}