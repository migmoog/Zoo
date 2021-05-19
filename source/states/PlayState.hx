package states;

import flixel.FlxState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
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
		FlxG.mouse.load("assets/images/cursor.png");
		#if debug
		FlxG.log.redirectTraces = true;
		FlxG.switchState(new Giraffe());
		#end

		bg = new FlxSprite(steps * -1280, 0, "assets/images/testBG.png");
		c = new FlxSprite().loadGraphic("assets/images/char.png");
		d = new Dialogue('$steps', true);

		add(bg);
		add(d);
		add(c);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (!d.alive && canTranslate)
		{
			canTranslate = false;
			FlxG.camera.fade(FlxColor.BLUE, 1.25, false, () ->
			{
				FlxG.switchState(new Giraffe());
			});
			/* FlxTween.tween(bg, {x: bg.x - (bg.width / 4)}, 2.5, {
				onStart: (_) -> canTranslate = false,
				onComplete: (_) -> {
					// FlxG.switchState(new Giraffe());
					// d.restart('$steps');
				}
			});*/
		}

		super.update(elapsed);
	}
}
