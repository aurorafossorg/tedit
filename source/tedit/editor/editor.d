module tedit.editor.editor;

import tedit.editor.clipboard : ClipboardManager;
import tedit.editor.buffer.filebuffer : FileBuffer;
import tedit.editor.logger : Logger;
import tedit.app : TeditApplication;

class Editor {
	this(TeditApplication app)
	{
		this.app = app;
	}

	private TeditApplication app;
	private FileBuffer[] buffers;
}