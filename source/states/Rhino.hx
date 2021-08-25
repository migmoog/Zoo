package states;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.tweens.FlxEase;

class Rhino extends Animal
{
	var chest:FlxSprite;
	var jaw:FlxSprite;
	var head:FlxSprite;

	var fart:FlxEmitter;
	// controls how far away the particles can move
	var box_in:Float = 400;
	var freq:Float = 0.019;

	override function create()
	{
		#if debug
		members[0].visible = false;
		#end

		fart = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 50);
		fart.launchMode = CIRCLE;
		fart.lifespan.set(10);

		var p_x_dist:Float = 1280 - box_in;
		var p_y_dist:Float = 720 - box_in;
		fart.acceleration.set(-p_x_dist, -p_y_dist, p_x_dist, p_y_dist, -p_x_dist, -p_y_dist, p_x_dist, p_y_dist);

		fart.alpha.set(1, 1, 0.1, 0.1);
		fart.scale.set(1, 1, 5, 5, 4, 4, 7, 7);
		fart.loadParticles("assets/images/fart.png");
		add(fart);
		// fart.start(false, freq);
		fart.focusOn(baseAniml);

		add(baseAniml);

		// BODY ASSETS
		// maybe change file name
		chest = new FlxSprite(0, 0, "assets/images/rhino_front.png");
		add(chest);

		jaw = new FlxSprite(520, 400, "assets/images/rhino_jaw.png");
		add(jaw);

		head = new FlxSprite(450, 6, "assets/images/rhino_head.png");
		add(head);
		FlxTween.tween(head, {y: head.y - 35}, 2.5, {ease: FlxEase.cubeOut, type: PINGPONG});
		FlxTween.tween(jaw, {y: jaw.y + 35}, 2.5, {ease: FlxEase.cubeInOut, type: PINGPONG});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function new()
	{
		// the base image is the rhino's ass
		super([new Spot(470, 310, 50)], 'rhino');
	}
}
