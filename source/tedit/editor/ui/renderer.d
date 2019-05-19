module tedit.editor.ui.renderer;

import tedit.app;
import tedit.editor.buffer.buffer;

import std.string : toStringz;

import aurorafw.cli.terminal.terminal;
import aurorafw.cli.terminal.window;

class Renderer {
	this(TeditApplication app)
	{
		this.app = app;

		this.terminal = Terminal(Terminal.OutputType.CELL);
		terminal.setTitle(app.settings.getSettingsValue!string("editor.window.title"));

		//initial draw
		terminal.getWindowSize(rows, cols);
		windowResizeCallback();

		terminal.flushBuffer();
	}

	pragma(inline)
	public void render()
	{
		ev = terminal.pollEvents();

		terminal.input.buffer();
		//if((ev.flags & Terminal.EventFlag.InputBuffer) != 0)
		//{
		//	string ibuffer = terminal.input.buffer;
		//	terminal.writeBuffer(ibuffer);
		//	moveX(ibuffer.length);
		//}

		if((ev.flags & Terminal.EventFlag.Resize) != 0)
		{
			// new window size
			int new_rows, new_cols;
			terminal.getWindowSize(new_rows, new_cols);

			// set new windows size values
			cols = new_cols;
			rows = new_rows;

			windowResizeCallback();
		}

		// if should render, flush buffer
		if(this._shouldRender && (ev.flags != 0))
		{
			moveCursor();
			terminal.flushBuffer();
		}
	}


	public void windowResizeCallback()
	{
		terminal.clear();

		for (size_t y = 0; y < rows; y++)
		{
			if(y == rows / 2)
			{
				string greetings = app.settings.getSettingsValue!string("editor.window.greetings");
				if (greetings.length > cols) greetings.length = cols;
				size_t padding = (cols - greetings.length) / 2;
				if (padding) {
					terminal.writeBuffer("~");
					padding--;
				}
				while (padding--) terminal.writeBuffer(" ");
				terminal.writeBuffer(greetings);
			} else {
				terminal.writeBuffer("~");
			}

			terminal.writeBuffer("\x1b[K");
			if (y < rows - 1)
				terminal.writeBuffer("\r\n");
		}
		setCursorPos(0, 0);

		terminal.flushBuffer();
	}


	public @safe void quit()
	{
		this._shouldRender = false;
	}

	pragma(inline)
	@property public bool shouldRender() const
	{
		return this._shouldRender;
	}


	@property public bool isResized() const
	{
		return (ev.flags & Terminal.EventFlag.Resize) != 0;
	}


	pragma(inline) @safe
	@property public void moveCursor(int x = 0, int y = 0)
	{
		setCursorPos(cx + x, cy + y);
	}


	@safe
	@property public void setCursorPos(int x = 0, int y = 0)
	{
		import std.algorithm.comparison : clamp;
		cx = clamp(x, 0, cols);
		cy = clamp(y, 0, rows);

		terminal.setCursorPos(cx, cy);
	}


	@safe
	@property public void moveX(int val)
	{
		moveCursor(val);
	}


	@safe
	@property public void moveY(int val)
	{
		moveCursor(0, val);
	}

	pragma(inline) @safe
	@property public int width() const
	{
		return cols;
	}

	pragma(inline) @safe
	@property public int height() const
	{
		return rows;
	}

	public Terminal terminal;

	private TeditApplication app;
	private int cx, cy;
	private int rows, cols;
	private Terminal.Event ev;
	private TerminalWindow[] twins;
	private bool _shouldRender = true;
}