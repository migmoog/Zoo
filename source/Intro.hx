package;

class Intro extends FlxState
{
	var cutSprite:FlxSprite;

	override function create()
	{
		cutSprite = new FlxSprite(0, 0);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
