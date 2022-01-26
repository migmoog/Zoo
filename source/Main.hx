package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.Dream;
import states.Giraffe;
import states.PlayState;
import states.Rhino;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, #if final Intro #else Intro #end, 1, 60, 60, #if debug true #else false #end));
	}
}
