package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;

class EndingState extends FlxState
{
	var logo:FlxText;

	override public function create()
	{
		FlxG.sound.playMusic(AssetPaths.MainMenu__wav, 0.75);
		var bg = new FlxSprite().loadGraphic(AssetPaths.BG__png);
		add(bg);
		var text = "You Lost!";
		if (PlayState.hasWon)
		{
			text = "You Won!";
			FlxG.sound.play(AssetPaths.Win__wav);
		}
		else
			FlxG.sound.play(AssetPaths.NoRecycle__wav);
		if (MenuState.endless)
			text = "Game Over!";
		logo = new FlxText(450, 30, FlxG.width, text, 48).setFormat(AssetPaths.ocean__ttf, 100, 0xFF6DF0F9);
		add(logo);
		var scoreText = new FlxText(500, 250, 500,
			"Score: " + PlayState.recycled + "\nMissed: " + PlayState.missed).setFormat(AssetPaths.ocean__ttf, 60, 0xFF6DF0F9);
		add(scoreText);
		swagLogo(null);
		#if !web
		if (MenuState.endless && PlayState.recycled > FlxG.save.data.ES)
		{
			saveScore();
			scoreText.text += "\nYou got a new highscore!";
		}
		#end
		var rexb = new FlxButton(499, 400, "", function rb()
		{
			FlxG.sound.play(AssetPaths.Select__wav, 1, false, null, true, function next()
			{
				PlayState.exitState();
				FlxG.switchState(new PlayState());
			});
		}).loadGraphic(AssetPaths.ResetGameButton__png, true, 300, 100);
		add(rexb);
		var emb = new FlxButton(499, 500, "", function em()
		{
			FlxG.sound.play(AssetPaths.Select__wav, 1, false, null, true, function next()
			{
				PlayState.exitState();
				FlxG.switchState(new MenuState());
			});
		}).loadGraphic(AssetPaths.ExitToMenuButton__png, true, 300, 100);
		add(emb);
		var eb = new FlxButton(499, 600, "", function emb()
		{
			FlxG.sound.play(AssetPaths.Select__wav, 1, false, null, true, function next()
			{
				#if !web
				flash.system.System.exit(0);
				#else
				FlxG.switchState(new HTML5CloseState());
				#end
			});
		}).loadGraphic(AssetPaths.ExitButton__png, true, 300, 100);
		add(eb);
		super.create();
	}

	function saveScore()
	{
		FlxG.save.data.ES = PlayState.recycled;
		FlxG.save.flush();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function swagLogo(tween:FlxTween)
	{
		FlxTween.tween(logo, {x: logo.x, y: logo.y + 40}, 3, {
			ease: FlxEase.quadInOut,
			onComplete: function name(tween:FlxTween)
			{
				FlxTween.tween(logo, {x: logo.x, y: logo.y - 40}, 3, {ease: FlxEase.cubeInOut, onComplete: swagLogo});
			}
		});
	}
}
