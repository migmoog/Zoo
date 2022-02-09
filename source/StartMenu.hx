package;

import flixel.ui.FlxButton;

class StartMenu extends FlxState
{
	var title:FlxSprite;

	var button:FlxButton;
	var messWithPlayer:Int = 5;
	var moveToRandom:FlxTween;
	var movingBtn:Bool = false;

	override function create()
	{
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic('assets/music/title.mp3');

		button = new FlxButton(0, 0, "Start teh epicness", () ->
		{
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
			FlxG.switchState(new Intro());
		});
		var nw:Int = cast button.width * 4;
		var nh:Int = cast button.height * 4;
		button.setGraphicSize(nw, nh);
		button.setSize(nw, nh);
		button.centerOffsets(true);
		button.screenCenter();
		button.label.setSize(50, 50);
		add(button);

		moveToRandom = FlxTween.tween(button, {
			x: FlxG.random.float(0, FlxG.width - button.width),
			y: FlxG.random.float(FlxG.height - button.height)
		}, 0.5, {});
		moveToRandom.cancel();

		super.create();
	}

	override function update(elapsed:Float)
	{
		// FIXME: this stuff
		var btnPos = button.getMidpoint();
		var mousePos = FlxG.mouse.getPosition();
		if (btnPos.distanceTo(mousePos) <= 200 && !movingBtn)
		{
			movingBtn = true;
			// tween button to random position
			FlxTween.tween(button, {
				x: FlxG.random.float(0, FlxG.width - button.width),
				y: FlxG.random.float(FlxG.height - button.height)
			}, 0.5, {onComplete: (_) -> movingBtn = false});
		}

		btnPos.put();
		mousePos.put();

		super.update(elapsed);
	}
}
