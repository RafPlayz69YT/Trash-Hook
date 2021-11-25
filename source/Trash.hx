package;

import flixel.FlxG;
import flixel.FlxSprite;
import states.PlayState;

class Trash extends FlxSprite
{
	public var type:String;
	public var canMove:Bool = false;
	public var canRecycle:Bool = false;
	public var isGone:Bool = false;
	public var speed:Float;

	public function new(trashType:String, x:Float = 0, y:Float = 0, ang:Int = 0, sped:Float = 0.2)
	{
		super(x, y);
		type = trashType;
		loadGraphic("assets/images/trash/" + trashType + ".png");
		angle = ang;
		speed = (sped * PlayState.curDiff);
	}

	override public function update(elapsed:Float)
	{
		if (!isGone && !canRecycle)
		{
			if (y <= 283 && PlayState.recycleTrash.length != 5)
			{
				if (type == "Net")
					color = 0xFF0A0AEE;
				recycleThis();
			}
			else if (y <= 283 && !PlayState.autoRe)
			{
				setPosition(x, y + 5);
				FlxG.sound.play(AssetPaths.NoRecycle__wav, 5);
				canMove = false;
			}
			else
			{
				x -= speed;
				canmove();
				mouseMove();
				if (!isOnScreen(FlxG.camera))
				{
					FlxG.sound.play(AssetPaths.Miss__wav);
					PlayState.barUse++;
					PlayState.barCheck();
					PlayState.missed++;
					del();
				}
			}
		}
		super.update(elapsed);
	}

	function recycleThis()
	{
		angle = 0;
		PlayState.oceanTrash.remove(this);
		PlayState.recycleTrash.push(this);
		canRecycle = true;
		setPosition(910 + (60 * (PlayState.recycleTrash.length - 1)), 50.75);
		if (type == "Net")
			x += 3 * (PlayState.recycleTrash.length - 1);
	}

	public function del()
	{
		isGone = true;
		kill();
		PlayState.oceanTrash.remove(this);
		canRecycle = false;
	}

	function canmove()
	{
		if (canMove)
		{
			if (FlxG.mouse.justReleased)
				canMove = false;
			else
			{
				if (FlxG.mouse.pressed && FlxG.mouse.overlaps(this))
					return;
			}
		}
		else
		{
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(this))
				canMove = true;
		}
	}

	function mouseMove()
	{
		if (canMove)
		{
			x = FlxG.mouse.x - 20;
			y = FlxG.mouse.y - 3;
		}
	}
}
