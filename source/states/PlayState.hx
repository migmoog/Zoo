package states;

import flixel.FlxState;
import flixel.tweens.FlxEase;
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
		#end

		bg = new FlxSprite(steps * -1280, 0, "assets/images/testBG.png");
		c = new FlxSprite().loadGraphic("assets/images/char.png");
		d = new Dialogue('$steps');

		add(bg);
		add(d);
		add(c);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (!d.alive && canTranslate)
		{
			FlxTween.tween(bg, {x: bg.x - (bg.width / 4)}, 2.5, {
				onStart: (_) ->
				{
					canTranslate = false;
				},
				onComplete: (_) ->
				{
					d.restart('$steps');
				}
			});
		}

		super.update(elapsed);
	}
}
