package states;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import states.Animal.Spot;

// TODO: finish this rhino
class Rhino extends Animal
{
	var chest:FlxSprite;
	var jaw:FlxSprite;
	var head:FlxSprite;
	var fart:FlxSprite;

	var expressing:Bool = false;

	override function create()
	{
		#if debug
		members[0].visible = false;
		#end

		fart = new FlxSprite(0, 0).loadGraphic("assets/images/fart.png", true, FlxG.width, FlxG.height);
		fart.animation.add('prt', [for (i in 0...17) i]);
		fart.animation.play('prt');
		add(fart);

		add(baseAniml);

		// BODY ASSETS
		// maybe change file name
		chest = new FlxSprite(0, 0, "assets/images/rhino/rhino_front.png");
		add(chest);

		jaw = new FlxSprite(520, 400, "assets/images/rhino/rhino_jaw.png");
		jaw.origin.set(jaw.width / 2, 0);
		add(jaw);

		head = new FlxSprite(450, 6, "assets/images/rhino/rhino_head.png");
		head.origin.set(head.width / 2, head.height);
		add(head);
		FlxTween.tween(head, {y: head.y - 35}, 2.5, {ease: FlxEase.cubeOut, type: PINGPONG});
		FlxTween.tween(jaw, {y: jaw.y + 35}, 2.5, {ease: FlxEase.cubeInOut, type: PINGPONG});

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!expressing)
		{
			// TODO: make it so if the mouse is below the head, set the angle. else keep the angle the same
			var angle_mirror = Math.atan2(FlxG.mouse.y - head.origin.y, FlxG.mouse.x - head.origin.x) * FlxAngle.TO_DEG;
			head.angle = FlxMath.bound(angle_mirror, -15, 15);
			jaw.angle = -head.angle;
		}

		super.update(elapsed);
	}

	public function new()
	{
		// the base image is the rhino's ass
		super([new Spot(470, 310, 50)], 'rhino');
	}
}
