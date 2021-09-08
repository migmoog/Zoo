package states;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.tweens.FlxEase;
import states.Animal.Spot;

// TODO: finish this rhino
class Rhino extends Animal
{
	var chest:FlxSprite;
	var jaw:FlxSprite;
	var head:FlxSprite;

	override function create()
	{
		#if debug
		members[0].visible = false;
		#end

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
