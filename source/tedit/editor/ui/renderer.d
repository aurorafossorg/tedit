module tedit.editor.ui.renderer;

import tedit.app;

import std.string : toStringz;

alias CTRL_KEY = (char k) => ((k) & 0x1f);

import aurorafw.cli.terminal.terminal;

class Renderer {
	this(TeditApplication app)
	{
		this.app = app;

		this.terminal = Terminal(Terminal.OutputType.CELL);
		terminal.setTitle("Tedit Text Editor");

		//initial draw
		terminal.getWindowSize(rows, cols);
		windowResizeCallback();

		terminal.flushBuffer();
	}

	public void render()
	{
		dchar c = terminal.readCh();
		switch (c) {
			case CTRL_KEY('q'):
				this._shouldRender = false;
				break;
			case '\x1b':
				c = terminal.readCh();
				if(c == '[')
				{
					c = terminal.readCh();
					final switch(c)
					{
						case 'A':
							if(cy != 0)
								cy--;
							break;
						case 'B':
							if(cx != rows - 1)
							cy++;
							break;
						case 'C':
							if(cx != cols - 1)
								cx++;
							break;
						case 'D':
							if(cx != 0)
								cx--;
							break;
					}
				}
				break;
			case 0: break;
			default:
				import std.conv : to;
				terminal.writeBuffer(to!string(c));
				cx++;
				break;
		}

		// new window size
		size_t new_rows, new_cols;
		terminal.getWindowSize(new_rows, new_cols);

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

		terminal.setCursorPos(cx, cy);
		terminal.viewCursor(true); // show cursor

		// if should render, flush buffer
		if(this._shouldRender)
			terminal.flushBuffer();
	}

	public void windowResizeCallback()
	{
		terminal.clear();

		for (size_t y = 0; y < rows; y++)
		{
			terminal.writeBuffer("~");
			terminal.writeBuffer("\x1b[K");
			if (y < rows - 1) {
				terminal.writeBuffer("\r\n");
    }
		}
		terminal.setCursorPos(0, 0);

		terminal.flushBuffer();
	}

	@property public bool shouldRender()
	{
		return this._shouldRender;
	}

	@property public bool isResized()
	{
		return this.resized;
	}

	public Terminal terminal;

	private TeditApplication app;
	private size_t cx, cy;
	private size_t rows, cols;
	private bool _shouldRender = true;
	private bool resized;
}