package;

class Intro extends FlxState
{
	var cutscene:FlxSprite;

	override function create()
	{
		cutscene = new FlxSprite(0, 0);
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
