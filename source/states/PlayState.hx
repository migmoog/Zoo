package states;

import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.Dialogue;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var canTranslate:Bool = false;

	public static var steps:Int = 0;

	// think of this as ids in an array, not a total of existing objects
	public final dialogueSteps:Int = 4;

	var bg:FlxSprite;
	var c:FlxSprite;
	var d:Dialogue;

	override public function create()
	{
		// FIXME: REPLACE CURSOR WITH 128x128 one
		FlxG.mouse.load("assets/images/ui/cursor.png");
		#if debug
		FlxG.log.redirectTraces = true;
		// DEBUG CRAP COMMENT OUT FOR RELEASE
		FlxG.switchState(new Rhino());
		#end

		bg = new FlxSprite((steps == 0 ? steps : steps - 1) * -1280, 0, "assets/images/backgrounds/BG.png");
		c = new FlxSprite().loadGraphic("assets/images/char.png");
		d = new Dialogue('$steps');

		add(bg);
		add(c);

		if (steps != 0)
		{
			// Finish callback won't run bc inPlayState bool doesn't exist any more
			// need a different way
			var pre_dialogue = new Dialogue('pre-${steps}', () ->
			{
				FlxTween.tween(bg, {x: bg.x - 1280}, 1.5, {onComplete: (_) -> add(d)});
			});
			add(pre_dialogue);
		}
		else
			add(d);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (!d.alive && canTranslate)
		{
			canTranslate = false;
			FlxG.camera.fade(FlxColor.WHITE, 1.25, false, () ->
			{
				// how to pick new scenes
				switch (steps)
				{
					case 1:
						FlxG.switchState(new Giraffe());
					case 2:
						FlxG.switchState(new Gorilla());
					case 3:
						FlxG.switchState(new Rhino());
					case 4:
						FlxG.switchState(new Dream());
				}
			});
		}

		super.update(elapsed);
	}
}
