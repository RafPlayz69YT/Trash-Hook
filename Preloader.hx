import flixel.system.FlxBasePreloader;
import flixel.system.FlxPreloader;

class Preloader extends FlxPreloader
{
	override public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>):Void
	{
		super(0, ["https://rafplayz69yt.itch.io/trash-hook", FlxBasePreloader.LOCAL]);
		siteLockTitleText = "Not poggers :(";
		siteLockBodyText = "Ok this is not epic as you did a not pog move there partner.\n I will cancel you on my twitter.com and you will suffer by the hands of the world.\nGood luck.\n also here is the link so you can be poggers :)";
	}
}
