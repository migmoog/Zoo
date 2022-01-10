package states;

import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import objects.Dialogue;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	public var canTranslate:Bool = false;
	public var changedStep:Bool = false;

	public static var steps:Int = 0;

	// think of this as ids in an array, not a total of existing objects
	public final dialogueSteps:Int = 4;

	var bg:FlxSprite;
	var c:FlxSprite;
	var d:Dialogue;

	var overworldSprites:FlxSpriteGroup;

	override public function create()
	{
		FlxG.mouse.load("assets/images/ui/cursor.png");
		#if debug
		// DEBUG CRAP COMMENT OUT FOR RELEASE
		// FlxG.switchState(new Dream());
		#end

		bg = new FlxSprite((steps == 0 ? steps : steps - 1) * -1280, 0, "assets/images/backgrounds/BG.png");
		c = new FlxSprite("assets/images/char.png");
		d = new Dialogue('$steps');

		add(bg);

		overworldSprites = new FlxSpriteGroup();
		add(overworldSprites);

		var silPath = 'assets/images/backgrounds/sils/';
		var giraffeSil = new FlxSprite(bg.x + 455, 77, silPath + '${steps < 1 ? 'giraffesil' : 'girafferev'}.png');
		overworldSprites.add(giraffeSil);
		if (steps >= 1)
			giraffeSil.setPosition(bg.x + 410, 130);

		var gorilSil = new FlxSprite(bg.x + 1714, 124, silPath + '${steps < 2 ? 'gorillasil' : 'gorillarev'}.png');
		overworldSprites.add(gorilSil);
		if (steps >= 2)
			gorilSil.setPosition(bg.x + 1750, 140);

		var rhinoSil = new FlxSprite(bg.x + 2967, 180, silPath + '${steps < 3 ? 'rhinosil' : 'rhinorev'}.png');
		overworldSprites.add(rhinoSil);
		if (steps >= 3)
			rhinoSil.setPosition(bg.x + 2970, 120);

		add(c);

		if (steps != 0)
		{
			var pre_dialogue = new Dialogue('pre-${steps}', () ->
			{
				FlxTween.tween(overworldSprites, {x: overworldSprites.x - 1280}, 1.5);
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
						FlxG.switchState(new Intro());
				}
			});
		}

		super.update(elapsed);
	}
}
