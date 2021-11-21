package states;

class HTML5CloseState extends flixel.FlxState
{
	override public function create()
	{
		var text = new flixel.text.FlxText(0, 0, flixel.FlxG.width,
			"You closed the game but on HTML5, Haxeflixel can't terminate it.\n Click the button below this to reset the game.", 16);
		text.setFormat(AssetPaths.ocean__ttf, 64, 0xFF00e3f7);
		text.screenCenter();
		text.x += 20;
		add(text);
		var rexb = new flixel.ui.FlxButton(450, 600, "", function rb()
		{
			flixel.FlxG.sound.play(AssetPaths.Select__wav, 1, false, null, true, function next()
			{
				flixel.FlxG.resetGame();
			});
		}).loadGraphic(AssetPaths.ResetGameButton__png, true, 300, 100);
		add(rexb);
		super.create();
	}
}
