module tedit.editor.clipboard;

import tedit.editor.editor;
import tedit.app : TeditApplication;

//TODO: Create clipboard manager

class ClipboardManager {
	this(TeditApplication app)
	{
		this.app = app;
		app.logger.trace("Starting clipboard manager...");
	}

	private TeditApplication app;
}