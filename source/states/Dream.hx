package states;

import objects.Dialogue;

class Dream extends FlxState
{
	var d:Dialogue;
	var c:FlxSprite;

	var wall:FlxSprite;
	var clicks:Int = 0;

	var fadeComplete:Bool = false;

	var shakeIntens:Float = 0.08;

	override function create()
	{
		c = new FlxSprite('assets/images/char.png');

		d = new Dialogue('dream', () ->
		{
			FlxTween.tween({c: c, d: d}, {"c.alpha": 0, "d.alpha": 0}, 1, {
				onComplete: (_) ->
				{
					fadeComplete = true;
					wall = new FlxSprite().loadGraphic('assets/images/backgrounds/dream_wall/wall.png', true, 1280, 720);
					add(wall);
				}
			});
		});

		add(c);
		add(d);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (fadeComplete && FlxG.mouse.justPressed)
		{
			if (clicks < 4)
			{
				fadeComplete = false;

				FlxG.camera.shake(shakeIntens, 0.5, () ->
				{
					wall.animation.frameIndex = ++clicks;
					shakeIntens *= 1.25;
					fadeComplete = true;
				});
			}
			else if (clicks >= 4)
			{
				trace("Fun stuff");
			}
		}

		super.update(elapsed);
	}
}
