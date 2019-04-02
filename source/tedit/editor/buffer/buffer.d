module tedit.editor.buffer.buffer;

@safe class Buffer {
	final @property lineCount()
	{
		return lines.length;
	}

	void append(string text)
	{
		lines ~= text;
	}

	public string[] lines;
}