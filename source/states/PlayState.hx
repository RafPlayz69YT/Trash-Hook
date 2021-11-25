package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var ml:Bool = false;
	var upgradeBox:FlxSprite;

	static var sRD = 1.0;
	static var tAD = 1.0;
	static var moneyIncrease = 1.0;
	static var maxUpgrade = false;

	static var water:FlxSprite;
	static var limit:Int = 10;
	static var text:FlxText;
	static var mtext:FlxText;
	static var dst:String = "Score: ";
	static var dct:String = "Money: ";
	static var info = UpgradeList.getInfo(0);
	static var utext:FlxText;

	public var typesTrash:Array<String> = ["Bag", "Bottle", "Net", "Straw", "Tin"];

	static public var hasWon = false;
	static public var barUse:Int = 60;
	public static var autoRe = false;
	static public var money:Int = 0;
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
		text = new FlxText(3, 30, 400, dst + 0).setFormat(AssetPaths.ocean__ttf, 32, 0xFF6DF0F9);
		add(text);
		mtext = new FlxText(3, 70, 400, dct + 0 + Main.ms).setFormat(AssetPaths.ocean__ttf, 32, 0xFF6DF0F9);
		add(mtext);
		upgradeBox = new FlxSprite(220, 50).loadGraphic(AssetPaths.UpgradeBox__png);
		add(upgradeBox);
		utext = new FlxText(235, 60, upgradeBox.width - 25, "").setFormat(AssetPaths.ocean__ttf, 24, 0xFF002024);
		add(utext);
		upgradeTo(0);
		var reButton = new FlxButton(600, 30, "", recycleAll).loadGraphic(AssetPaths.RecycleButton__png, true, 300, 100);
		add(reButton);
		water = new FlxSprite(0, 300).loadGraphic(AssetPaths.Water__png, true, 1280, 540);
		water.animation.add("flow", [0, 1], 1.7, true);
		water.animation.play("flow");
		water.alpha = 0.6;
		var recycleBox = new FlxSprite(900, 30).loadGraphic(AssetPaths.RecycleBox__png);
		add(recycleBox);
		var bar = new FlxBar(10, 200, LEFT_TO_RIGHT, 200, 20, PlayState, "barUse", 0, 100, true).createFilledBar(0xffeeeeee, 0xff424747, true, 0xFF000000);
		add(bar);
		var barText = new FlxText(10, 170, 200, "Ocean Pollution Bar").setFormat(AssetPaths.ocean__ttf, 16, 0xFF6DF0F9, CENTER);
		add(barText);
		addTrash(FlxG.random.int(5, 8));
		super.create();
	}

	override function update(elapsed:Float)
	{
		mouseCheck();
		pauseCheck();
		if (!maxUpgrade && FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(utext) || FlxG.mouse.overlaps(upgradeBox))
			{
				if (money >= info[3])
				{
					FlxG.sound.play(AssetPaths.Select__wav);
					upgrade();
					refreshText();
				}
				else
				{
					FlxG.sound.play(AssetPaths.NoRecycle__wav);
				}
			}
		}
		if (autoRe && recycleTrash.length == 5)
		{
			recycleAll();
		}
		super.update(elapsed);
	}

	static function upgrade()
	{
		money -= info[3];
		info[1] = info[1] + 1;
		switch (info[0])
		{
			case 0:
				autoRe = true;
			case 1:
				sRD += 0.15;
			case 2:
				moneyIncrease += 0.2;
			case 3:
				removeDiff();
			case 4:
				tAD += 0.2;
		}
		if (info[1] == info[2])
			FlxTween.tween(utext, {alpha: 0}, 0.5, {
				ease: FlxEase.quadInOut,
				onComplete: function next(tween:FlxTween)
				{
					if (info[0] + 1 == 5)
						maxUpgrade = true;
					upgradeTo(info[0] + 1);
					FlxTween.tween(utext, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
				}
			});
		else
		{
			info[3] = Math.floor(info[3] * 1.45);
			refreshText();
		}
	}

	function pauseCheck()
	{
		if (FlxG.keys.anyJustPressed([ESCAPE, ENTER]))
		{
			FlxG.mouse.unload();
			ml = false;
			openSubState(new PauseSubState(0xC0000000));
		}
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
		remove(water);
		for (i in 0...amount)
		{
			if (oceanTrash.length == limit)
				continue;
			var trash = new Trash(typesTrash[FlxG.random.int(0, typesTrash.length - 1)], FlxG.random.float(1050, 1210), FlxG.random.float(325, 650),
				FlxG.random.int(-80, 80));
			add(trash);
			oceanTrash.push(trash);
		}
		add(water);
		var extraTime = curDiff / 2.09242;
		var mult = (curDiff / 2.354545323542) / tAD;
		if (extraTime < 1)
			extraTime += 0.2876;
		if (mult < 1)
			mult += 0.3;
		new FlxTimer().start((FlxG.random.float(3.9, 6.9) / extraTime) * sRD, function spawn(tmr:FlxTimer)
		{
			addTrash(Math.round((FlxG.random.int(4, 10) * mult) / tAD));
		});
	}

	function recycleAll()
	{
		if (recycleTrash.length > 0)
		{
			FlxG.sound.play(AssetPaths.Recycle__wav);
			for (i in 0...recycleTrash.length)
			{
				recycleTrash[i].del();
				addScore();
				if (FlxG.random.bool(42.5))
				{
					spawnText(recycleTrash[i], Math.round((FlxG.random.int(27, 52) * Math.floor(PlayState.curDiff + 1 / 1.25)) * moneyIncrease));
				}
			}
			recycleTrash = [];
		}
	}

	public static function barCheck()
	{
		if (barUse <= 0 && !MenuState.endless)
		{
			hasWon = true;
			FlxG.switchState(new EndingState());
		}
		if (barUse >= 100)
			FlxG.switchState(new EndingState());
	}

	function addScore()
	{
		recycled++;
		if (barUse > 0)
			barUse--;
		barCheck();
		switch (recycled)
		{
			case 10:
				addDiff();
			case 25:
				addDiff();
			case 55:
				addDiff();
			case 80:
				addDiff();
			case 100:
				addDiff();
			case 130:
				addDiff();
			case 175:
				addDiff();
			case 220:
				addDiff();
			case 260:
				addDiff();
			case 300:
				addDiff();
			case 350:
				addDiff();
			case 380:
				addDiff();
			case 420:
				addDiff();
			case 450:
				addDiff();
		}
	}

	function addDiff()
	{
		curDiff += 0.425;
		water.animation.remove("flow");
		water.animation.add("flow", [0, 1], 1.7 * curDiff, true);
		water.animation.play("flow");
		limit += 5;
		for (i in 0...oceanTrash.length)
		{
			oceanTrash[i].speed = 0.2 * curDiff;
		}
		playMusic();
	}

	static function removeDiff()
	{
		curDiff -= 0.2;
		water.animation.remove("flow");
		water.animation.add("flow", [0, 1], 1.7 * curDiff, true);
		water.animation.play("flow");
		for (i in 0...oceanTrash.length)
		{
			oceanTrash[i].speed = 0.2 * curDiff;
		}
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

	public function spawnText(t:Trash, amount:Int)
	{
		money += amount;
		var ctext = new FlxText(t.x, t.y + 50, 100, "+" + amount + Main.ms).setFormat(AssetPaths.text__ttf, 10, 0xFF2efc23);
		add(ctext);
		FlxG.sound.play(AssetPaths.CashGet__wav, 0.2);
		refreshText();
		FlxTween.tween(ctext, {y: t.y}, 0.65, {
			ease: FlxEase.quadInOut,
			onComplete: function delText(tween:FlxTween)
			{
				ctext.destroy();
			}
		});
	}

	static function upgradeTo(index:Int)
	{
		info = UpgradeList.getInfo(index);
		refreshText();
	}

	static function refreshText()
	{
		text.text = dst + recycled;
		mtext.text = dct + money + Main.ms;
		if (!maxUpgrade)
		{
			utext.text = "Price: " + info[3] + Main.ms + "\n" + UpgradeList.getNameDesc(info[0]);
			utext.text += "Current Level: " + info[1] + "\nMax Level: " + info[2];
		}
		else
			utext.text = UpgradeList.getNameDesc(info[0]);
	}
}
