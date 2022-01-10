package states;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import objects.Dialogue;
import states.Animal.Spot;

class Giraffe extends Animal
{
	var tutDialog:Dialogue;
	var eyeColor:FlxSprite;
	var eye:FlxSprite;
	var jaw:FlxSprite;
	var tweeningJaw:Bool = false;
	var em:FlxPoint;

	override function create()
	{
		eyeColor = new FlxSprite(540, 280).makeGraphic(150, 130, FlxColor.WHITE);
		add(eyeColor);
		em = eyeColor.getMidpoint();
		em.y += 20;

		add(baseAniml);

		eye = new FlxSprite(em.x - 32, em.y - 32, 'assets/images/eye.png');
		add(eye);

		jaw = new FlxSprite(570 - 381, 530 - 216, "assets/images/giraffe/giraffe_jaw.png");
		jaw.origin.set(380, 220);
		add(jaw);
		FlxMouseEventManager.add(jaw, null, null, mouse_over, not_mouse_over);

		tutDialog = new Dialogue('tutorial');
		add(tutDialog);

		super.create();
	}

	override function update(elapsed:Float)
	{
		// vector magic thanks Markl :-)
		var eyeVector:FlxVector = FlxVector.get(FlxG.mouse.x - em.x, FlxG.mouse.y - em.y);
		var og_mag = eyeVector.length;
		var dist_scale = Math.min(1.0, og_mag / (FlxG.width / 2));

		eyeVector.length = eyeColor.width / 2 - eye.width / 2;
		eyeVector.length *= dist_scale;
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
				eyeColor.color = FlxColor.interpolate(FlxColor.GREEN, FlxColor.WHITE, closestSpot());

			spotDistance();
		}

		super.update(elapsed);
	}

	public function new()
	{
		super([
			new Spot(810, 680, 85),
			new Spot(770, 480, 60),
			new Spot(580, 690, 35),
			new Spot(340, 270, 85),
			new Spot(290, 200, 75),
			new Spot(650, 180, 65),
			new Spot(680, 290, 70),
			new Spot(730, 230, 75)
		], "giraffe");
	}

	override function express(happy:Bool)
	{
		super.express(happy);

		FlxTween.tween(jaw, {angle: -90}, 1, {
			onStart: (_) -> tweeningJaw = true,
			onUpdate: (_) ->
			{
				eyeColor.color = happy ? FlxColor.GREEN : FlxColor.RED;
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
