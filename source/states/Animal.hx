package states;

import flixel.input.mouse.FlxMouseEventManager;
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
	public var mouseSpritePixels:Bool = false;

	override function create()
	{
		FlxG.plugins.add(new FlxMouseEventManager());

		#if debug
		FlxG.watch.add(this, 'happiness', "spots clicked: ");
		FlxG.watch.add(this, 'chances', "chances left: ");
		// FlxG.debugger.visible = true;
		#end

		var w = 65;
		var h = 550;
		happyBar = new FlxBar(FlxG.width - (w + 25), 0, BOTTOM_TO_TOP, w, h, this, 'happiness', 0, spots.members.length, true);
		happyBar.createColoredEmptyBar(TRANSPARENT, true, RED);
		happyBar.createColoredFilledBar(fromString('#fff23b'));

		happyBar.screenCenter(Y);
		happyBar.percent = 0;
		add(happyBar);

		FlxMouseEventManager.add(baseAniml, null, null, mouse_pixel_perfect);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (happiness == spots.length && canClickAgain)
		{
			canClickAgain = false;
			FlxG.switchState(new PlayState());
		}

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
		// add(baseAniml);
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
			if (FlxG.mouse.justPressed && canClickAgain && mouseSpritePixels)
			{
				if (within_spot(s))
				{
					express(true);

					happiness++;

					s.petted = true;
					return;
				}
				else
				{
					express(false);

					chances--;
					return;
				}
			}
		}
	}

	function closest_spot()
	{
		// FIXME eyecolor needs to reset after click
		var distance = (s:Spot) ->
		{
			if (!s.petted)
			{
				var x1 = FlxG.mouse.x - s.x;
				var y1 = FlxG.mouse.y - s.y;

				return Math.sqrt((x1 * x1) + (y1 * y1)) / 100;
			}
			else
				return null;
		};

		var dists:Array<Float> = [
			for (s in spots)
			{
				var d = distance(s);

				if (d != null)
					d;
			}
		];

		var temp:Float;
		for (i in 0...dists.length)
		{
			if (dists[i] > dists[i + 1])
			{
				temp = dists[i];
				dists[i] = dists[i + 1];
				dists[i + 1] = temp;
			}
		}

		return dists[0];
	}

	function express(happy:Bool)
	{
		// animal will have its child tween the jaw and allow clicks again
		canClickAgain = false;
		FlxG.sound.play('assets/music/${happy ? "ehh" : "uhh"}.mp3', 0.6, false, null, true);
	}

	function mouse_pixel_perfect(_)
		mouseSpritePixels = true;
}
