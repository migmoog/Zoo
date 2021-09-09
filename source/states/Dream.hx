package states;

import objects.Dialogue;

class Dream extends FlxState
{
	var d:Dialogue;
	var c:FlxSprite;

	var fadeComplete:Bool = false;

	override function create()
	{
		c = new FlxSprite().loadGraphic('assets/images/char.png');

		d = new Dialogue('dream', false, () ->
		{
			FlxTween.tween({c: c, d: d}, {"c.alpha": 0, "d.alpha": 0}, 1, {onComplete: (_) -> fadeComplete = true});
		});

		add(c);
		add(d);

		super.create();
	}
}
