package states;

import flixel.FlxState;
import objects.Dialogue;

class PlayState extends FlxState
{
	var c:FlxSprite;
	var d:Dialogue;

	override public function create()
	{
		FlxG.mouse.load("assets/images/cursor.png");
		#if debug
		FlxG.log.redirectTraces = true;
		#end

		c = new FlxSprite().loadGraphic("assets/images/char.png");
		add(c);

		d = new Dialogue("test");
		add(d);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
