module tedit.editor.ui.input;

import aurorafw.core.input.rawlistener;
import aurorafw.core.input.events;
import aurorafw.core.input.keys;

import tedit.app;

class TeditInputListener : RawInputListener {
	this(TeditApplication app)
	{
		this.app = app;
		app.logger.trace("Initializing the input listener");
	}

	@trusted
	override void keyPressed(immutable KeyboardEvent e, bool)
	{
		if(e == KeyboardEvent(Keycode.Backspace, InputModifier.None)) {
			//app.renderer.moveX(-1);
			//app.renderer.terminal.writeBuffer(' ');
		} else if(e == KeyboardEvent(Keycode.PageDown, InputModifier.None)) {
			app.renderer.moveY(app.renderer.height());
		} else if(e == KeyboardEvent(Keycode.PageUp, InputModifier.None)) {
			app.renderer.moveY(-app.renderer.height());
		} else if(e == KeyboardEvent(Keycode.Home, InputModifier.None)) {
			app.renderer.moveX(-app.renderer.width());
		} else if(e == KeyboardEvent(Keycode.End, InputModifier.None)) {
			app.renderer.moveX(app.renderer.width());
		} else if(e == KeyboardEvent(Keycode.Q, InputModifier.Control)) {
			app.renderer.quit();
		} else if(e == KeyboardEvent(Keycode.Down, InputModifier.None)) {
			app.renderer.moveY(1);
		} else if(e == KeyboardEvent(Keycode.Up, InputModifier.None)) {
			app.renderer.moveY(-1);
		} else if(e == KeyboardEvent(Keycode.Right, InputModifier.None)) {
			app.renderer.moveX(1);
		} else if(e == KeyboardEvent(Keycode.Left, InputModifier.None)) {
			app.renderer.moveX(-1);
		}

		//TODO: Step 51
	}

	private TeditApplication app;
}