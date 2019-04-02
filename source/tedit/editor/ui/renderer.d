module tedit.editor.ui.renderer;

import tedit.app;

import std.string : toStringz;

alias CTRL_KEY = (char k) => ((k) & 0x1f);

import aurorafw.cli.terminal.terminal;

class Renderer {
	this(TeditApplication app)
	{
		this.app = app;

		this.term = Terminal(Terminal.OutputType.CELL);

		//initial draw
		term.getWindowSize(rows, cols);
		windowResizeCallback();

		flush();
	}

	public void flush()
	{
		if(buffer.length>0)
		{
			term.write(buffer.toStringz, buffer.length);
			buffer.length = 0;
		}
	}

	public void render()
	{
		dchar c = term.readCh();
		switch (c) {
			case CTRL_KEY('q'):
				this._shouldRender = false;
				break;/*
			case "\x1b[A":
				win_cy--;
				break;
			case "\x1b[B":
				win_cy++;
				break;
			case "\x1b[C":
				win_cx++;
				break;
			case "\x1b[D":
				win_cx--;
				break;*/
			default:
				import std.conv : to;
				write(to!string(c));
				break;
		}

		// new window size
		size_t new_rows, new_cols;
		term.getWindowSize(new_rows, new_cols);

		// check if window size changed
		if(new_cols != cols || new_rows != rows)
		{
			// resized
			resized = true;
			windowResizeCallback();
		} else if(resized) {
			resized = false;
		}

		// set new windows size values
		cols = new_cols;
		rows = new_rows;

		term.viewCursor(true); // show cursor

		// if should render, flush buffer
		if(this._shouldRender)
			flush();
	}

	public void windowResizeCallback()
	{
		term.clear();

		for (size_t y = 0; y < rows; y++)
		{
			write("~");
			write("\x1b[K");
			if (y < rows - 1) {
				write("\r\n");
    }
		}
		flush();
		term.setCursorPos(0, 0);
	}

	public void write(string str)
	{
		buffer ~= str;
	}

	@property public bool shouldRender()
	{
		return this._shouldRender;
	}

	@property public bool isResized()
	{
		return this.resized;
	}

	@property public ref Terminal terminal()
	{
		return this.term;
	}

	private TeditApplication app;
	private Terminal term;
	private string buffer;
	private size_t cx, cy;
	private size_t rows, cols;
	private bool _shouldRender = true;
	private bool resized;
}