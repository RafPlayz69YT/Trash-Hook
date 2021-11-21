package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	public static var endless = false;
	public static var EndS = 0;

	var pb:FlxSprite;
	var enb:FlxSprite;

	var rb:FlxSprite;
	var exb:FlxSprite;
	var text:FlxText;
	var logo:FlxSprite;
	var notetext:FlxText;
	var Cicon:FlxSprite;
	var Vicon:FlxSprite;

	override public function create()
	{
		FlxG.mouse.visible = true;
		#if !web
		FlxG.save.bind("scores");
		if (FlxG.save.data.ES == null)
		{
			FlxG.save.data.ES = 0;
			FlxG.save.flush();
		}
		uS();
		#end
		var bg = new FlxSprite().loadGraphic(AssetPaths.BG__png);
		add(bg);
		text = new FlxText(20, 1000, FlxG.width, "Endless Mode Score: " + EndS + ".");
		text.setFormat(AssetPaths.ocean__ttf, 42);
		#if web
		notetext = new FlxText(20, 1100, 300, "Notice: you are on web which can't save. If you want to save, you have to download the windows build.");
		notetext.setFormat(AssetPaths.ocean__ttf, 18);
		add(notetext);
		#end
		add(text);
		logo = new FlxSprite(400, 795).loadGraphic(AssetPaths.Logo__png);
		logo.scale.set(1.125, 1.125);
		add(logo);
		Cicon = new FlxSprite(1210, 650).loadGraphic(AssetPaths.YoutubeIcon__png);
		add(Cicon);
		Vicon = new FlxSprite(1100, 660).loadGraphic(AssetPaths.VideoIcon__png);
		add(Vicon);
		var vtext = new FlxText(1000, 600, 300, "This was made for #SEAJAM!\nCheck out the video and my youtube channel!");
		vtext.setFormat(AssetPaths.ocean__ttf, 18);
		add(vtext);
		FlxG.sound.playMusic(AssetPaths.MainMenu__wav, 0.7);
		FlxTween.tween(logo, {x: 400, y: 55}, 0.5, {ease: FlxEase.quadInOut, onComplete: pbt});
		pb = new FlxButton(500, 1000, "", PS).loadGraphic(AssetPaths.PlayButton__png, true, 300, 100);
		add(pb);
		enb = new FlxButton(500, 1100, "", ES).loadGraphic(AssetPaths.EndlessButton__png, true, 300, 100);
		add(enb);
		rb = new FlxButton(500, 1200, "", RS).loadGraphic(AssetPaths.ResetButton__png, true, 300, 100);
		add(rb);
		exb = new FlxButton(500, 1300, "", EX).loadGraphic(AssetPaths.ExitButton__png, true, 300, 100);
		add(exb);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		mouseCheck();
		super.update(elapsed);
	}

	function mouseCheck()
	{
		if (FlxG.mouse.overlaps(Cicon) && FlxG.mouse.justPressed)
			FlxG.openURL("https://www.youtube.com/channel/UCmXh1HTaH_KRwisl0892KLA");
		else if (FlxG.mouse.overlaps(Vicon) && FlxG.mouse.justPressed)
			FlxG.openURL("https://www.youtube.com/channel/UCmXh1HTaH_KRwisl0892KLA");
	}

	function PS()
	{
		FlxG.switchState(new PlayState());
	}

	function ES()
	{
		endless = true;
		FlxG.switchState(new PlayState());
	}

	function EX()
	{
		FlxG.sound.play(AssetPaths.Select__wav, 1, false, null, true, function next()
		{
			#if !web
			flash.system.System.exit(0);
			#else
			FlxG.switchState(new HTML5CloseState());
			#end
		});
	}

	function uS()
	{
		#if !web
		EndS = FlxG.save.data.ES;
		#end
	}

	function RS()
	{
		FlxG.sound.play(AssetPaths.Select__wav);
		#if !web
		FlxG.save.data.ES = 0;
		EndS = FlxG.save.data.ES;
		FlxG.save.flush();
		#else
		EndS = 0;
		#end
	}

	function pbt(tween:FlxTween)
	{
		swagLogo();
		FlxTween.tween(pb, {x: 500, y: 300}, 0.5, {ease: FlxEase.quadInOut, onComplete: enbt});
	}

	function enbt(tween:FlxTween)
	{
		FlxTween.tween(enb, {x: 500, y: 400}, 0.5, {ease: FlxEase.quadInOut, onComplete: rbt});
		FlxTween.tween(text, {x: 20, y: 300}, 0.5, {
			ease: FlxEase.quadInOut,
			onComplete: function note(tween:FlxTween)
			{
				#if web
				FlxTween.tween(notetext, {x: 20, y: 400}, 0.5, {ease: FlxEase.quadInOut});
				#end
			}
		});
	}

	function rbt(tween:FlxTween)
	{
		FlxTween.tween(rb, {x: 500, y: 500}, 0.5, {ease: FlxEase.quadInOut, onComplete: exbt});
	}

	function exbt(tween:FlxTween)
	{
		FlxTween.tween(exb, {x: 500, y: 600}, 0.5, {ease: FlxEase.quadInOut});
	}

	function swagLogo(tween:FlxTween = null)
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
