package states;

import flixel.FlxObject;
import flixel.ui.FlxBar;

class Animal extends FlxState
{
	// The eyes and sliding/rotating bits will be individual to each animal
	var spots:FlxTypedGroup<FlxObject>;
	var baseAniml:FlxSprite;
	var happyBar:FlxBar;

	override function create()
	{
		var w = 80;
		var h = 680;
		happyBar = new FlxBar(FlxG.width - w, 0, BOTTOM_TO_TOP, w, h);
		happyBar.screenCenter(Y);
		add(happyBar);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
