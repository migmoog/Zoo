package states;

import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.util.FlxColor.*;

class Animal extends FlxState
{
	// The eyes and sliding/rotating bits will be individual to each animal
	var spots:FlxTypedGroup<Spot>;
	var baseAniml:FlxSprite;
	var happyBar:FlxBar;

	public var happiness:Int = 0;
	public var chances:Int = 3;
	public var canClickAgain:Bool = true;

	override function create()
	{
		#if debug
		FlxG.watch.add(this, 'happiness', "spots clicked: ");
		FlxG.watch.add(this, 'chances', "chances left: ");
		FlxG.debugger.visible = true;
		#end

		var w = 65;
		var h = 550;
		happyBar = new FlxBar(FlxG.width - (w + 25), 0, BOTTOM_TO_TOP, w, h, this, 'happiness', 0, spots.members.length, true);
		happyBar.createColoredEmptyBar(TRANSPARENT, true, RED);
		happyBar.createColoredFilledBar(fromString('#fff23b'));

		happyBar.screenCenter(Y);
		happyBar.percent = 0;
		add(happyBar);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (chances <= 0 && canClickAgain)
		{
			canClickAgain = false;
			FlxG.resetState();
		}

		super.update(elapsed);
	}

	public function new(spots:Array<Spot>, sprName:String)
	{
		super();
		this.spots = new FlxTypedGroup<Spot>(spots.length);
		for (s in spots)
			this.spots.add(s);

		baseAniml = new FlxSprite(0, 0, 'assets/images/${sprName}.png');
		add(baseAniml);
	}

	// will be called at certain times dependant on each animal
	function spotDistance()
	{
		var within_spot = (s:Spot) ->
		{
			var m = FlxG.mouse;

			var d_x = m.x - s.x;
			var d_y = m.y - s.y;

			var d = Math.sqrt((d_x * d_x) + (d_y * d_y));

			var result = d <= s.r && !s.petted;

			return result;
		};

		for (s in spots.members)
		{
			#if debug
			if (within_spot(s))
				trace("Within a spot");
			else
				trace("Isn't within a spot");
			#end

			if (FlxG.mouse.justPressed && canClickAgain)
			{
				if (within_spot(s))
				{
					express(true);

					happiness++;

					#if debug
					trace("clicked a spot");
					#end

					s.petted = true;
					return;
				}
				else
				{
					express(false);

					chances--;
					#if debug
					trace("didn't click within a spot");
					#end
					return;
				}
			}
		}
	}

	function express(happy:Bool)
	{
		canClickAgain = false;
		FlxG.sound.play('assets/music/${happy ? "ehh" : "uhh"}.mp3', 0.6, false, null, true, () -> canClickAgain = true);
	}
}
