package states;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.math.FlxPoint;

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

	override function create()
	{
		add(baseAniml);

		armBase = new FlxSprite(30, 335, "assets/images/gorilla_arm.png");
		ogArmPoint = armBase.getPosition();
		// add(arm);

		jaw = new FlxSprite(590, 380, "assets/images/gorilla_jaw.png");
		jaw.origin.x = 150 / 2;
		ogJawPoint = baseAniml.getMidpoint();
		add(jaw);

		snout = new FlxSprite(560, 280, "assets/images/gorilla_snout.png");
		snout.origin.x = 100;
		ogSnoutPoint = snout.getPosition();
		add(snout);

		armShake = new FlxShakeEffect(closest_spot(), 1);
		arm = new FlxEffectSprite(armBase, [armShake]);
		arm.setPosition(ogArmPoint.x, ogArmPoint.y);
		add(arm);

		super.create();
	}

	override function update(elapsed:Float)
	{
		armShake.intensity = closest_spot();
		armShake.start();

		var mouse_pos = FlxG.mouse.getPosition();
		var jaw_dist = ((FlxG.height / 2 + 50) - mouse_pos.y) / 5;
		var snout_dist = ogSnoutPoint.distanceTo(mouse_pos) / 100;

		jaw.y = ogJawPoint.y + jaw_dist / 2;
		arm.y = ogArmPoint.y + jaw_dist;
		snout.y = ogSnoutPoint.y + snout_dist;

		super.update(elapsed);
	}

	public function new()
	{
		super([new Spot(450, 600, 50)], 'gorilla');
	}
}
