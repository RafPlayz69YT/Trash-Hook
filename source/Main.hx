package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.SplashScreenState;

class Main extends Sprite
{
	var fpsCounter:FPS;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, SplashScreenState, 1, 100, 70, true));
		fpsCounter = new FPS(10, 3, 0xFF00e3f7);
		addChild(fpsCounter);
	}
}
