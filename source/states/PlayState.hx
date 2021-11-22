package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var water:FlxSprite;
	var wA:Bool = false;
	var text:FlxText;
	var dt:String = "Score: ";
	var ml:Bool = false;
	var limit:Int = 10;

	public var typesTrash:Array<String> = ["Bag", "Bottle", "Net", "Straw", "Tin"];
	public var endless = MenuState.endless;

	static public var recycled:Int = 0;
	static public var missed:Int = 0;
	static public var curDiff:Float = 1;
	static public var oceanTrash:Array<Trash> = [];
	static public var recycleTrash:Array<Trash> = [];

	override public function create()
	{
		FlxG.sound.play(AssetPaths.Select__wav);
		playMusic();
		var BG = new FlxSprite().loadGraphic(AssetPaths.BG__png);
		add(BG);
		text = new FlxText(100, 75, 400, dt + 0).setFormat(AssetPaths.ocean__ttf, 48, 0xFF6DF0F9);
		add(text);
		var reButton = new FlxButton(550, 30, "", recycleAll).loadGraphic(AssetPaths.RecycleButton__png, true, 300, 100);
		add(reButton);
		water = new FlxSprite(0, 300).loadGraphic(AssetPaths.Water__png, true, 1280, 540);
		water.animation.add("flow", [0, 1], 1.7, true);
		water.animation.play("flow");
		water.alpha = 0.6;
		var recycleBox = new FlxSprite(900, 30).loadGraphic(AssetPaths.RecycleBox__png);
		add(recycleBox);
		addTrash(FlxG.random.int(5, 8));
		super.create();
	}

	override function update(elapsed:Float)
	{
		mouseCheck();
		if (FlxG.keys.anyJustPressed([ESCAPE, ENTER]))
		{
			FlxG.mouse.unload();
			ml = false;
			openSubState(new PauseSubState(0xC0000000));
		}
		super.update(elapsed);
	}

	function mouseCheck()
	{
		if (FlxG.mouse.overlaps(water) && !ml)
		{
			FlxG.mouse.load(AssetPaths.Hook__png);
			ml = true;
		}
		else if (!FlxG.mouse.overlaps(water) && ml)
		{
			FlxG.mouse.unload();
			ml = false;
		}
	}

	static public function exitState()
	{
		curDiff = 1;
		oceanTrash = [];
		recycleTrash = [];
	}

	function addTrash(amount:Int)
	{
		for (i in 0...amount)
		{
			if (oceanTrash.length == limit)
				continue;
			var trash = new Trash(typesTrash[FlxG.random.int(0, typesTrash.length - 1)], FlxG.random.float(950, 1210), FlxG.random.float(325, 650),
				FlxG.random.int(-75, 75));
			add(trash);
			oceanTrash.push(trash);
		}
		if (wA)
			remove(water);
		wA = true;
		add(water);
		var extraTime = (curDiff / 2.09242);
		var mult = curDiff / 2.354545323542;
		if (extraTime < 1)
			extraTime += 0.2876;
		if (mult < 1)
			mult += 0.3;
		new FlxTimer().start(FlxG.random.float(3.9, 6.9) / extraTime, function spawn(tmr:FlxTimer)
		{
			addTrash(Math.floor((FlxG.random.int(4, 9) * mult)));
		});
	}

	function recycleAll()
	{
		if (recycleTrash.length > 0)
		{
			FlxG.sound.play(AssetPaths.Recycle__wav);
			for (i in 0...recycleTrash.length)
			{
				recycleTrash[i].del(true);
				addScore();
			}
			recycleTrash = [];
		}
	}

	function addScore()
	{
		recycled++;
		switch (recycled)
		{
			case 10:
				addDiff();
			case 20:
				addDiff();
			case 30:
				addDiff();
			case 45:
				addDiff();
			case 60:
				addDiff();
			case 85:
				addDiff();
			case 100:
				addDiff();
			case 150:
				addDiff();
		}
		text.text = dt + recycled;
	}

	function addDiff()
	{
		curDiff += 0.5;
		water.animation.remove("flow");
		water.animation.add("flow", [0, 1], 1.7 * curDiff, true);
		water.animation.play("flow");
		limit = limit * Std.int(curDiff);
		for (i in 0...oceanTrash.length)
		{
			oceanTrash[i].speed = 0.2 * curDiff;
		}
		playMusic();
	}

	static public function playMusic()
	{
		var ext = 1;
		switch (recycled)
		{
			case 50, 99:
				ext++;
			case 100, 999999999:
				ext = 3;
		}
		FlxG.sound.playMusic("assets/music/Game" + ext + ".wav");
	}
}
