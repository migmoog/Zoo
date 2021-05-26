package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.util.FlxColor;
import objects.Dialogue;

class Giraffe extends Animal
{
	var tutDialog:Dialogue;
	var eyeColor:FlxSprite;
	// var eyeVector:FlxVector;
	var eye:FlxSprite;
	var jaw:FlxSprite;
	var tweeningJaw:Bool = false;
	var em:FlxPoint;

	override function create()
	{
		eyeColor = new FlxSprite(540, 280).makeGraphic(150, 150, FlxColor.WHITE);
		add(eyeColor);
		em = eyeColor.getMidpoint();

		add(baseAniml);

		eye = new FlxSprite(em.x - 32, em.y - 32, 'assets/images/eye.png');
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
		var eyeVector:FlxVector = FlxVector.get(FlxG.mouse.x - em.x, FlxG.mouse.y - em.y);
		eyeVector.length = 10;
		eye.x = em.x + eyeVector.x - eye.width / 2;
		eye.y = em.y + eyeVector.y - eye.height / 2;
		eyeVector.put();

		if (!tweeningJaw)
		{
			var x1 = FlxG.mouse.x - jaw.origin.x;
			var y1 = FlxG.mouse.y - jaw.origin.y;
			var distance = (Math.sqrt((x1 * x1) + (y1 * y1)) / 100);

			jaw.angle = -distance;
		}

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
