module tedit.editor.ui.input;

import aurorafw.core.input.events;
import aurorafw.core.input.keys;

import std.ascii : isAlpha, toUpper;
import std.conv : parse, to;

KeyboardEvent translatePosixKeycode(string keyseq)
{
	if(isAlpha(keyseq[0]))
	{
		string ret = to!string(toUpper(keyseq[0]));
		return KeyboardEvent(parse!Keycode(ret), InputModifier.None);
	}
	return KeyboardEvent(Keycode.Unknown, InputModifier.None);
}