package;

class UpgradeList
{
	public static var ul:Array<Array<Dynamic>> = [
		[
			["Auto-Recycle", "This upgrade makes the box auto-recycle when it is full!"],
			[
				"Lower Spawn Rate",
				"This will make the spawn amount decrease by a bit each level!"
			],
			["More Money", "This will increase the amount of money you gain from trash!"],
			["Lower Trash Speed", "This upgrade will reduce the speed of the trash!"],
			["Lower Trash Amount", "This will decrease the amount of trash that spawns!"],
			[
				"No More Upgrades!",
				"Congrats! You have got all the upgrades available! Great job!"
			]
		],
		[[1, 125], [5, 130], [3, 175], [5, 250], [5, 325], [0, 0]]
	];

	public static function getInfo(index:Int)
	{
		var array:Array<Int> = [];
		array.push(index);
		array.push(0);
		var ints = ul[1];
		var yoink = ints[index];
		for (i in 0...yoink.length)
		{
			array.push(yoink[i]);
		}
		return array;
	}

	public static function getNameDesc(index:Int)
	{
		var ok = ul[0];
		var re = "";
		var array = ok[index];
		for (i in 0...array.length)
		{
			re += array[i];
			re += "\n";
		}
		return re;
	}
}
