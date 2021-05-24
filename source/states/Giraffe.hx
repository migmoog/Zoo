package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.util.FlxColor;
import objects.Dialogue;

class Giraffe extends Animal
{
	var tutDialog:Dialogue;
	var eyeColor:FlxSprite;
	var eye:FlxSprite;
	var jaw:FlxSprite;
	var tweeningJaw:Bool = false;

	override function create()
	{
		eyeColor = new FlxSprite(560, 300).makeGraphic(120, 120, FlxColor.WHITE);
		add(eyeColor);

		add(baseAniml);

		eye = new FlxSprite(560, 300, 'assets/images/eye.png');
		add(eye);

		jaw = new FlxSprite(570 - 381, 530 - 216, "assets/images/giraffe_jaw.png");
		jaw.origin.set(381, 216);
		add(jaw);
		FlxMouseEventManager.add(jaw, null, null, mouse_pixel_perfect);

		tutDialog = new Dialogue('tutorial', false);
		add(tutDialog);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!tweeningJaw)
		{
			var x1 = FlxG.mouse.x - jaw.origin.x;
			var y1 = FlxG.mouse.y - jaw.origin.y;
			var distance = (Math.sqrt((x1 * x1) + (y1 * y1)) / 100);

			jaw.angle = -distance;
			eye.angle = Math.atan2(FlxG.mouse.y - eye.y, FlxG.mouse.x - eye.x) * (180 / Math.PI);
		}

		if (!tutDialog.alive)
		{
			eyeColor.color = FlxColor.interpolate(FlxColor.GREEN, FlxColor.WHITE, closest_spot());
			spotDistance();
		}

		super.update(elapsed);
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

		var dists:Array<Float> = [for (s in spots) distance(s)];

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

	public function new()
	{
		super([new Spot(600, 350, 60, this)], "giraffe");
	}

	// returns the distance of the spot the mouse is closest to

	override function express(happy:Bool)
	{
		super.express(happy);

		eyeColor.color = FlxColor.WHITE;
		FlxTween.tween(jaw, {angle: -90}, 1, {
			onStart: (_) -> tweeningJaw = true,
			onComplete: (_) ->
			{
				FlxTween.tween(jaw, {angle: jaw.angle + 90}, 0.5, {
					onComplete: (_) ->
					{
						canClickAgain = true;
						tweeningJaw = false;
					}
				});
			}
		});
	}
}
