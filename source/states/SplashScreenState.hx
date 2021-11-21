package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SplashScreenState extends FlxState
{
	var splash:FlxSprite;
	var splashtext:FlxText;

	override public function create()
	{
		FlxG.mouse.visible = false;
		splash = new FlxSprite().loadGraphic(AssetPaths.Splashscreen__png, true, 64, 64);
		splash.animation.add("boot", [
			0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11, 12, 12, 13, 14, 15, 15, 16, 17, 18, 18, 19, 20, 21, 21, 22, 23, 24, 24, 25, 26, 27, 27, 28, 29, 30,
			30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49
		], 60);
		splash.animation.add("idle", [49], 1);
		splash.animation.play("boot");
		splash.screenCenter();
		splash.y -= 50;
		splash.scale.set(5, 5);
		add(splash);
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			splash.animation.play("idle");
			splashtext = new FlxText(0, 465, FlxG.width, "RafPlayz69YT", 32);
			FlxG.sound.play(AssetPaths.Boot_up__wav);
			if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			{
				splashtext.setFormat(AssetPaths.text__ttf, 32, FlxColor.ORANGE, CENTER);
				splashtext.setBorderStyle(OUTLINE, FlxColor.BROWN, 0.3);
			}
			else
			{
				if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
				{
					splashtext.setFormat(AssetPaths.text__ttf, 32, FlxColor.WHITE, CENTER);
					splashtext.setBorderStyle(OUTLINE, FlxColor.RED, 0.3);
				}
				else
				{
					splashtext.setFormat(AssetPaths.text__ttf, 32, FlxColor.WHITE, CENTER);
					splashtext.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.3);
				}
			}
			add(splashtext);
			if (Date.now().getMonth() == 9 && Date.now().getDate() == 31)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					var spookytext = new FlxText(0, 500, FlxG.width, "Spooky Time!", 24);
					spookytext.setFormat(AssetPaths.text__ttf, 24, FlxColor.ORANGE, CENTER);
					spookytext.setBorderStyle(OUTLINE, FlxColor.BROWN, 0.3);
					add(spookytext);
					FlxG.sound.play(AssetPaths.Boot_up__wav);
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{
						splash.destroy();
						splashtext.destroy();
						spookytext.destroy();
						FlxG.switchState(new MenuState());
					});
				});
			}
			else if (Date.now().getMonth() == 11 && Date.now().getDate() == 25)
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					var christmastext = new FlxText(0, 500, FlxG.width, "Christmas Time!", 24);
					christmastext.setFormat(AssetPaths.text__ttf, 24, FlxColor.RED, CENTER);
					christmastext.setBorderStyle(OUTLINE, FlxColor.WHITE, 0.3);
					add(christmastext);
					FlxG.sound.play(AssetPaths.Boot_up__wav);
					new FlxTimer().start(1.5, function(tmr:FlxTimer)
					{
						splash.destroy();
						splashtext.destroy();
						christmastext.destroy();
						FlxG.switchState(new MenuState());
					});
				});
			}
			else
				new FlxTimer().start(2.5, function(tmr:FlxTimer)
				{
					splash.destroy();
					splashtext.destroy();
					FlxG.switchState(new MenuState());
				});
		});
		super.create();
	}
}
