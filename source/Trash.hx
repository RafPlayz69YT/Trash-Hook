package;

import flixel.FlxG;
import flixel.FlxSprite;
import states.PlayState;

class Trash extends FlxSprite
{
	public var type:String;
	public var canMove:Bool = false;
	public var isRecycle:Bool = false;
	public var isGone:Bool = false;

	public function new(trashType:String, x:Float = 0, y:Float = 0, ang:Int = 0)
	{
		super(x, y);
		type = trashType;
		loadGraphic("assets/images/trash/" + trashType + ".png");
		angle = ang;
	}

	override public function update(elapsed:Float)
	{
		if (!isGone && !isRecycle)
		{
			if (y <= 283 && PlayState.recycleTrash.length != 5)
				recycleThis();
			else if (y <= 283)
			{
				setPosition(x, y + 5);
				FlxG.sound.play(AssetPaths.NoRecycle__wav, 5);
				canMove = false;
			}
			else
			{
				move();
				canmove();
				mouseMove();
				if (!isOnScreen(FlxG.camera))
				{
					isGone = true;
					destroy();
				}
			}
		}
		super.update(elapsed);
	}

	function move() {}

	function recycleThis()
	{
		angle = 0;
		PlayState.oceanTrash.remove(this);
		PlayState.recycleTrash.push(this);
		isRecycle = true;
		setPosition(910 + (60 * (PlayState.recycleTrash.length - 1)) + intType(), 50.75);
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

	function intType():Int
	{
		var re = 0;
		switch (type)
		{
			case 'Bag':
				re = 5;
			case 'Tin':
				re = 5;
			case 'Straw':
				re = 3;
			case 'Bottle':
				re = 8;
		}
		return re;
	}
}
