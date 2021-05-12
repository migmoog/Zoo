package states;

import flixel.ui.FlxBar;

class Animal extends FlxState
{
	// The eyes and sliding/rotating bits will be individual to each animal
	var spots:FlxTypedGroup<Spot>;
	var baseAniml:FlxSprite;
	var happyBar:FlxBar;

	override function create()
	{
		var w = 80;
		var h = 680;
		happyBar = new FlxBar(FlxG.width - (w + 25), 0, BOTTOM_TO_TOP, w, h);
		happyBar.screenCenter(Y);
		add(happyBar);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function new(?spots:FlxTypedGroup<Spot>, sprName:String)
	{
		super();
		this.spots = spots;

		baseAniml = new FlxSprite(0, 0, 'assets/images/${sprName}.png');
	}
}
