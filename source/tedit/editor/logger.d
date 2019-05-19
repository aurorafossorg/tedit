module tedit.editor.logger;

import tedit.app;
import tedit.editor.config.settings;

import std.experimental.logger;
import std.container;
import std.stdio;

class Logger : std.experimental.logger.Logger {
	this(TeditApplication app, LogLevel lv = LogLevel.info) @safe
	{
		debug super(LogLevel.all);
		else super(lv);

		this.app = app;
		this.path = app.path ~ "logs/";

		import std.file : mkdirRecurse;
		// create directory if doesn't exist
		mkdirRecurse(path);

		import std.datetime.systime : Clock;
		import std.conv : to;
		// open the log file
		file_ = File(path~Clock.currTime.toISOString~".log", "a");
	}

	override protected void writeLogMsg(ref LogEntry payload)
	{
		// if theres too much elements
		if(maxCachedLength > 0 && qlen > maxCachedLength)
		{
			queueLog.removeFront(qlen - maxCachedLength + 1);
			qlen -= qlen - maxCachedLength + 1;
		}

		// append element
		queueLog ~= payload;
		++qlen;
	}

	void updateSettings(Settings settings)
	{
		maxCachedLength = settings.getSettingsValue!long("editor.logger.cachesize");
		size_t maxLogFiles = settings.getSettingsValue!size_t("editor.logger.filecount");

		import std.file : dirEntries, SpanMode, DirEntry;
		import std.algorithm.iteration : filter, map;
		import std.array : array;

		auto files = dirEntries(path, SpanMode.shallow).filter!(a => a.isFile);
		if(files.array.length > maxLogFiles) {
			import std.algorithm.sorting : sort;
			import std.datetime.systime : SysTime;
			foreach(entry; files.map!(a => a.timeLastModified, a => a.name))
			{
				
			}
		}
	}

	public immutable string path;
	private long maxCachedLength = -1;
	private DList!LogEntry queueLog;
	private size_t qlen;
	private File file_;
	private TeditApplication app;
}