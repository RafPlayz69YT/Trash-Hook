package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import states.SplashScreenState;

class Main extends Sprite
{
	var fpsCounter:FPS;

	public static var ms:String;

	public function new()
	{
		getMoneySign();
		super();
		addChild(new FlxGame(0, 0, SplashScreenState, 1, 100, 70, true));
		fpsCounter = new FPS(10, 3, 0xFF00e3f7);
		addChild(fpsCounter);
	}

	function getMoneySign()
	{
		var ipYoinker = new haxe.Http("https://api.ipify.org/?format=json");
		ipYoinker.onData = function yoink(data:String)
		{
			var ip = haxe.Json.parse(data);
			var geo = new haxe.Http("http://www.geoplugin.net/json.gp?ip=" + ip.ip);
			geo.onData = function moneySign(data:String)
			{
				var info = haxe.Json.parse(data);
				ms = info.geoplugin_currencySymbol;
			}
			geo.onError = function nooooo(error)
			{
				ms = "$";
			}
			geo.request();
		}
		ipYoinker.onError = function nooo(error)
		{
			ms = "$";
		}
		ipYoinker.request();
	}
}
