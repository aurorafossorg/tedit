module tedit.editor.config.settings;

import tedit.app;

import tedit.editor.editor : Editor;

import std.json;
import std.file : exists, write, read, mkdirRecurse;
import std.path : absolutePath, pathSeparator;
import std.conv : to;

class Settings {
	// FIXME: path is not at home dir
	this(TeditApplication app)
	{
		this.editor = editor;
		this.app = app;
		this.path = absolutePath("~/.config/tedit/");

		app.logger.trace("Check for user configurations");
		if(!exists(this.path))
			mkdirRecurse(this.path);

		if(exists(this.path~"settings.json"))
		{
			try {
				parsedSettings = parseJSON(to!string(read(this.path~"/settings.json")));
			} catch(JSONException e) {
				app.logger.error(e.msg);
			}
		}
		else {
			initializeSettings();
		}
	}

	private void initializeSettings()
	{
		app.logger.trace("Create user settings");
		mkdirRecurse(path);
		write(this.path ~ "settings.json", "{}");
	}

	private immutable string path;
	private JSONValue parsedSettings;
	private Editor editor;
	private TeditApplication app;
}