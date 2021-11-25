package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class PauseSubState extends FlxSubState
{
	var pi:FlxSprite;

	override public function create()
	{
		FlxG.sound.playMusic(AssetPaths.Pause__wav, 0.75);
		pi = new FlxSprite(520, -50).loadGraphic(AssetPaths.PauseIcon__png);
		pi.color = 0xFF6DF0F9;
		pi.scale.set(0.325, 0.325);
		add(pi);
		var pt = new FlxText(550, 200, 300, "Paused").setFormat(AssetPaths.ocean__ttf, 64, 0xFF6DF0F9);
		add(pt);
		var rb = new FlxButton(499, 300, "", c).loadGraphic(AssetPaths.ResumeButton__png, true, 300, 100);
		add(rb);
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

	override public function update(elapsed:Float)
	{
		if (FlxG.mouse.overlaps(pi) && FlxG.mouse.justPressed)
			c();
		super.update(elapsed);
	}

	function c()
	{
		FlxG.sound.play(AssetPaths.Select__wav, 1, false, null, true, function next()
		{
			PlayState.playMusic();
			close();
		});
	}
}
