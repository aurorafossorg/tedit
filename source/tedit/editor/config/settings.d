module tedit.editor.config.settings;

import tedit.app;

import tedit.editor.editor : Editor;

import std.json;
import std.file : exists, write, read, mkdirRecurse;
import std.path : absolutePath, pathSeparator;
import std.conv : to;
import std.exception;

class SettingsParseException : Exception {
	/** Settings Parse Exception Constructor
	 * This construct a normal exception
	 * @param msg exception message
	 * @param file code file
	 * @param line line code on file
	 * @param next next throwable object
	 */
	this(string msg, string file = __FILE__, size_t line = __LINE__,
		Throwable next = null)
	{
		super(msg, file, line, next);
	}

	/** Settings Parse Exception Constructor
	 * This construct a normal exception
	 * @param msg exception message
	 * @param next next throwable object
	 * @param file code file
	 * @param line line code on file
	 */
	this(string msg, Throwable next,
		string file = __FILE__, size_t line = __LINE__)
	{
		super(msg, file, line, next);
	}
}

class Settings {
	this(TeditApplication app)
	{
		this.editor = editor;
		this.app = app;

		app.logger.trace("Check for user configurations");
		if(!exists(app.path))
			mkdirRecurse(app.path);

		parsedSettings = parseValues("settings.json");
		parsedKeybinds = parseValues("keybinds.json");
		
		checkValues();

		app.logger.updateSettings(this);
	}

	private JSONValue parseValues(string file)
	{
		if(exists(app.path~file))
		{
			try {
				app.logger.trace("Parsing "~file);
				return parseJSON(to!string(read(app.path~file)));
			} catch(JSONException e) {
				app.logger.error(e.msg);
			}
		}
		else {
			app.logger.trace("Creating "~file);
			mkdirRecurse(app.path);
			write(app.path ~ file, "{}");
			return parseJSON("{}");
		}
		throw new SettingsParseException("Can't parse " ~ file);
	}

	pragma(inline, true)
	private void checkValues()
	{
		// settings.json
		checkValue(parsedSettings, "editor.window.title", "Tedit Text Editor");
		checkValue(parsedSettings, "editor.window.greetings", "Welcome to Tedit Text Editor");
		checkValue!"a > 0"(parsedSettings, "editor.logger.cachesize", 1024L);
		checkValue!"a > 0"(parsedSettings, "editor.logger.filecount", 5);

		// keybinds.json
		checkValue(parsedKeybinds, "editor.quit", "ctrl+k q");
	}

	public void checkValue(alias RegEx = `[\s\S]+`)(JSONValue jvalue, immutable string key, immutable string fallback)
	{
		if(key in jvalue &&
			jvalue.object[key].type == JSONType.string)
		{
			import std.regex : match, ctRegex;
			if(match(jvalue.object[key].str, ctRegex!(RegEx)))
			{
				app.logger.trace("Reading value ", key);
				return;
			} else
				app.logger.warning("Invalid value format, ", key);
		}

		if(key in jvalue &&
			jvalue.object[key].type != JSONType.string)
			app.logger.warning("Invalid value, ", key);
		
		app.logger.trace("Setting the default value for ", key);
		jvalue.object[key] = JSONValue(fallback);
	}


	public void checkValue(alias Exp = "true")(JSONValue jvalue, immutable string key, immutable long fallback)
	{
		if(key in jvalue &&
			jvalue.object[key].type == JSONType.integer)
		{
			immutable long a = jvalue.object[key].integer;
			if(mixin(Exp)) {
				app.logger.trace("Reading value ", key);
				return;
			} else
				app.logger.warning("Invalid value format, ", key);
		}

		if(key in jvalue &&
			jvalue.object[key].type != JSONType.integer)
			app.logger.warning("Invalid value, ", key);
		
		app.logger.trace("Setting the default value for ", key);
		jvalue.object[key] = JSONValue(fallback);
	}


	pragma(inline)
	public T getSettingsValue(T : string)(string key)
	{
		return parsedSettings[key].str;
	}


	pragma(inline)
	public T getSettingsValue(T : bool)(string key)
	{
		return parsedSettings[key].boolean;
	}


	pragma(inline)
	public T getSettingsValue(T : long)(string key)
	{
		import std.conv : to;
		return to!T(parsedSettings[key].integer);
	}


	pragma(inline)
	public T getKeybindsValue(T : string)(string key)
	{
		return parsedKeybinds[key].str;
	}


	private JSONValue parsedSettings;
	private JSONValue parsedKeybinds;
	private Editor editor;
	private TeditApplication app;
}