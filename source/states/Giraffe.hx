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

		if (FlxG.mouse.justPressed)
			eyeColor.makeGraphic(120, 120, FlxColor.WHITE);

		if (!tutDialog.alive)
		{
			if (!tweeningJaw)
				eyeColor.color = FlxColor.interpolate(FlxColor.GREEN, FlxColor.WHITE, closest_spot());

			spotDistance();
		}

		super.update(elapsed);
	}

	public function new()
	{
		super([new Spot(340, 270, 60, this), new Spot(800, 180, 60, this)], "giraffe");
	}

	override function express(happy:Bool)
	{
		super.express(happy);

		FlxTween.tween(jaw, {angle: -90}, 1, {
			onStart: (_) -> tweeningJaw = true,
			onUpdate: (_) ->
			{
				if (happy)
					eyeColor.color = FlxColor.GREEN;
				else
					eyeColor.color = FlxColor.RED;
			},
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
