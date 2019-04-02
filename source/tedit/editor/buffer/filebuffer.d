module tedit.editor.buffer.filebuffer;

import tedit.editor.buffer.buffer;
import tedit.editor.editor;

import std.stdio : File;
import std.file : exists, isDir;

class FileBuffer : Buffer {
	this(Editor editor)
	{
		this.editor = editor;
		this.edited = true;
	}

	this(Editor editor, string path)
	{
		this.editor = editor;

		if(this.path.exists)
		{
			this.pathExists = true;
			if(!path.isDir)
			{
				fileExists = true;
				file.open(path);
			}
			else
			{
				fileExists = false;
				import std.path : isDirSeparator;
				if(path[$-1].isDirSeparator)
				{
					path = path[0 .. $-1];
				}
			}
		} else {
			pathExists = false;
			import std.path : isDirSeparator;
			if(path[$-1].isDirSeparator)
			{
				path = path[0 .. $-1];
			}
		}
	}

	@property bool isEdited()
	{
		return edited;
	}

	@property string filePath()
	{
		return this.path;
	}

	void save()
	{
		if(path !is null)
		{
			if(!pathExists)
			{
				import std.path : driveName;
				import std.file : mkdirRecurse;
				mkdirRecurse(driveName(path));
			}
			if(!fileExists)
			{
				file.open(path);
			} else {

			}
		}

		if(!isOpen)
		{
			if(readOnly)
				file.open(path);
		}
	}

	@property bool isOpen()
	{
		return file.isOpen();
	}

	private string path = null;
	private bool edited;
	private bool readOnly;
	private bool pathExists;
	private bool fileExists;
	private File file;
	private Editor editor;
}