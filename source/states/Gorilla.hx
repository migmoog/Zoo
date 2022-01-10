package states;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.math.FlxPoint;
import states.Animal.Spot;

class Gorilla extends Animal
{
	// Arm
	var ogArmPoint:FlxPoint;
	var armBase:FlxSprite;
	var arm:FlxEffectSprite;
	var armShake:FlxShakeEffect;

	// Jaw
	var ogJawPoint:FlxPoint;
	var jaw:FlxSprite;

	// Snout
	var ogSnoutPoint:FlxPoint;
	var snout:FlxSprite;

	var tweeningJaw:Bool = false;

	override function create()
	{
		add(baseAniml);

		armBase = new FlxSprite(30, 270, "assets/images/gorilla/gorilla_arm.png");
		ogArmPoint = armBase.getPosition();
		// add(arm);

		jaw = new FlxSprite(590, 380, "assets/images/gorilla/gorilla_jaw.png");
		jaw.origin.x = 150 / 2;
		ogJawPoint = baseAniml.getMidpoint();
		add(jaw);

		snout = new FlxSprite(560, 280, "assets/images/gorilla/gorilla_snout.png");
		snout.origin.x = 100;
		ogSnoutPoint = snout.getPosition();
		add(snout);

		armShake = new FlxShakeEffect(closestSpot(), 1);
		arm = new FlxEffectSprite(armBase, [armShake]);
		arm.setPosition(ogArmPoint.x, ogArmPoint.y);
		add(arm);

		super.create();
	}

	override function update(elapsed:Float)
	{
		var mouse_pos = FlxPoint.weak(FlxG.mouse.x, FlxG.mouse.y);
		var jaw_dist = ((FlxG.height / 2 + 50) - mouse_pos.y) / 5;
		var snout_dist = ogSnoutPoint.distanceTo(mouse_pos) / 100;

		if (!tweeningJaw)
		{
			armShake.intensity = closestSpot();
			armShake.start();

			jaw.y = ogJawPoint.y + jaw_dist / 2;
			snout.y = ogSnoutPoint.y + snout_dist;
			spotDistance();
		}

		arm.y = ogArmPoint.y + jaw_dist;

		super.update(elapsed);
	}

	override function express(happy:Bool)
	{
		super.express(happy);

		FlxTween.tween(jaw, {y: ogJawPoint.y + 75}, 1, {
			onStart: (_) -> tweeningJaw = true,
			onComplete: (_) ->
			{
				FlxTween.tween(jaw, {y: ogJawPoint.y}, 0.5, {
					onComplete: (_) ->
					{
						canClickAgain = true;
						tweeningJaw = false;
					}
				});
			}
		});
	}

	public function new()
	{
		super([new Spot(450, 600, 50), new Spot(760, 350, 50), new Spot(820, 450, 60)], 'gorilla');
	}
}
