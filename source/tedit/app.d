module tedit.app;

import tedit.editor.editor;
import tedit.editor.logger;
import tedit.editor.clipboard;
import tedit.editor.ui.renderer;
import tedit.editor.config.settings;

import aurorafw.core.appcontext;
import aurorafw.core.input.manager;

class TeditApplication : ApplicationContext {
	this(string[] args)
	{
		super("org.aurorafoss.app.tedit", args);
	}

	override void onStart() {
		this._logger = new Logger();
		this._settings = new Settings(this);
		this._clipboard = new ClipboardManager(this);
		this._input = InputManager();
		this._editor = new Editor(this);
		this._renderer = new Renderer(this);
	}

	override void loop() {
		if(!_renderer.shouldRender) stop();
		else _renderer.render();
	}

	@property Settings settings()
	{
		return this._settings;
	}

	@property Logger logger()
	{
		return this._logger;
	}

	@property ClipboardManager clipboard()
	{
		return this._clipboard;
	}

	@property Renderer renderer()
	{
		return this._renderer;
	}

	private Logger _logger;
	private ClipboardManager _clipboard;
	private Editor _editor;
	private Settings _settings;
	private Renderer _renderer;
	private InputManager _input;
}