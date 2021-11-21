package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxBar;

class PlayState extends FlxState
{
	var water:FlxSprite;
	var text:FlxText;
	var dt:String = "Score: ";
	var ml:Bool = false;

	static var e1:FlxSound = new FlxSound().loadEmbedded(AssetPaths.Extra1__wav, true);
	static var e2:FlxSound = new FlxSound().loadEmbedded(AssetPaths.Extra2__wav, true);

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
		FlxG.sound.playMusic(AssetPaths.Game__wav);
		var BG = new FlxSprite().loadGraphic(AssetPaths.BG__png);
		add(BG);
		text = new FlxText(100, 75, 400, dt).setFormat(AssetPaths.ocean__ttf, 48, 0xFF6DF0F9);
		add(text);
		water = new FlxSprite(0, 300).loadGraphic(AssetPaths.Water__png, true, 1280, 540);
		water.animation.add("flow", [0, 1], 1.7, true);
		water.animation.play("flow");
		water.alpha = 0.6;
		var recycleBox = new FlxSprite(900, 30).loadGraphic(AssetPaths.RecycleBox__png);
		add(recycleBox);
		addTrash(10);
		add(water);
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

	function changeDiff() {}

	static public function exitState()
	{
		curDiff = 0;
		oceanTrash = [];
		recycleTrash = [];
	}

	public function addTrash(amount:Int)
	{
		for (i in 0...amount)
		{
			var trash = new Trash(typesTrash[FlxG.random.int(0, 4)], FlxG.random.float(1000, 1200), FlxG.random.float(300, 600), FlxG.random.int(-45, 45));
			add(trash);
			oceanTrash.push(trash);
		}
	}

	static public function playMusic()
	{
		if (recycled >= 50)
		{
			e1.play();
		}
		if (recycled >= 100)
		{
			e2.play();
		}
		FlxG.sound.playMusic(AssetPaths.Game__wav);
	}
}
