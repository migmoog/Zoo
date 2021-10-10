package states;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import states.Animal.Spot;

private var setFartCountdown:Float = 2.5;

// TODO: finish this rhino
class Rhino extends Animal
{
	var chest:FlxSprite;
	var jaw:FlxSprite;
	var head:FlxSprite;
	var fart:FlxSprite;

	var fartCountdown:Float = setFartCountdown;

	var expressing:Bool = false;

	override function create()
	{
		fart = new FlxSprite(0, 0).loadGraphic("assets/images/fart.png", true, FlxG.width, FlxG.height);
		fart.alpha = 0.4;
		fart.animation.add('prt', [for (i in 0...17) i], 30, false);

		fart.animation.callback = (n:String, ?_, ?__) -> if (n == 'prt') fart.visible = true;
		fart.animation.finishCallback = (n:String) -> if (n == 'prt') fart.visible = false;

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
			var angle_mirror = Math.atan2(FlxG.mouse.y - head.origin.y, FlxG.mouse.x - head.origin.x) * FlxAngle.TO_DEG;
			head.angle = FlxMath.bound(angle_mirror, -15, 15);
			jaw.angle = -head.angle;

			if (!fart.visible)
				fartCountdown -= elapsed;

			if (fartCountdown <= 0)
			{
				fart.animation.play('prt');
				fartCountdown = setFartCountdown;
			}

			fart.color = FlxColor.interpolate(FlxColor.RED, FlxColor.GREEN, closest_spot());
		}

		super.update(elapsed);
	}

	public function new()
	{
		// the base image is the rhino's ass
		super([new Spot(470, 310, 50)], 'rhino');
	}
}
