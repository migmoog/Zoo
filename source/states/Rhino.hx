package states;

import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import states.Animal.Spot;

private var setFartCountdown:Float = 0.85;

class Rhino extends Animal
{
	var chest:FlxSprite;
	var jaw:FlxSprite;
	var head:FlxSprite;
	var fart:FlxSprite;
	var backShake:FlxEffectSprite;
	var backShakeEffect:FlxShakeEffect;

	var ogPos:FlxPoint;

	var fartCountdown:Float = setFartCountdown;

	var pooStages:Int = 0;
	var expressing:Bool = false;

	override function create()
	{
		bg.loadGraphic("assets/images/backgrounds/rhino_bg.png", true, 1280, 720);

		fart = new FlxSprite(0, 0).loadGraphic("assets/images/fart.png", true, FlxG.width, FlxG.height);
		fart.alpha = 0.8;
		fart.animation.add('prt', [for (i in 0...17) i], 30, false);

		fart.animation.callback = (n:String, ?_, ?__) -> if (n == 'prt') fart.visible = true;
		fart.animation.finishCallback = (n:String) -> if (n == 'prt') fart.visible = false;

		fart.animation.play('prt');
		add(fart);

		backShakeEffect = new FlxShakeEffect(50, 0.35);
		backShake = new FlxEffectSprite(baseAniml, [backShakeEffect]);
		add(backShake);

		// BODY ASSETS
		// maybe change file name
		chest = new FlxSprite(0, 0, "assets/images/rhino/rhino_front.png");
		add(chest);

		jaw = new FlxSprite(520, 400, "assets/images/rhino/rhino_jaw.png");
		jaw.origin.set(jaw.width / 2, 0);
		add(jaw);

		head = new FlxSprite(450, 6, "assets/images/rhino/rhino_head.png");
		head.origin.set(head.width / 2, head.height);
		head.angle = -180;
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
				fartCountdown = FlxG.random.float(0.5, 1.5);
			}

			var d = closestSpot();
			fart.color = FlxColor.interpolate(FlxColor.WHITE, FlxColor.GREEN, d > 1.0 ? 0 : d);
			spotDistance();
		}

		super.update(elapsed);
	}

	override function express(happy:Bool)
	{
		expressing = true;

		fart.color = FlxColor.YELLOW;
		backShakeEffect.onComplete = () ->
		{
			if (happy)
			{
				bg.animation.frameIndex = ++pooStages;
			}
			expressing = false;
			canClickAgain = true;
		}

		if (happy)
			backShakeEffect.start();
		else
		{
			expressing = false;
			canClickAgain = true;
		}

		super.express(happy);
	}

	public function new()
	{
		// the base image is the rhino's ass
		super([new Spot(470, 310, 100), new Spot(770, 380, 125), new Spot(470, 680, 148)], 'rhino');
	}
}
