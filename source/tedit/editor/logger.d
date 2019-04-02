module tedit.editor.logger;

import tedit.editor.buffer.buffer;
import tedit.editor.editor;

import std.experimental.logger;

class Logger : std.experimental.logger.Logger {
	this(LogLevel lv = LogLevel.off) @safe
	{
		debug super(LogLevel.all);
		else super(lv);

		this.buffer = new Buffer();
	}

	override void writeLogMsg(ref LogEntry payload)
	{
		//TODO: Prettify the logger
		string ret;

		ret ~= payload.msg;

		buffer.append(ret);
	}

	private Buffer buffer;
}