package;

import flixel.addons.ui.FlxButtonPlus;
import flixel.ui.FlxButton;

class StartMenu extends FlxState
{
	var title:FlxSprite;

	var button:FlxButtonPlus;
	var messWithPlayer:Int = 5;
	var moveToRandom:FlxTween;
	var movingBtn:Bool = false;

	override function create()
	{
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic('assets/music/title.mp3');

		add(new FlxSprite('assets/images/ui/titlescreen.png'));

		button = new FlxButtonPlus(0, 0, () ->
		{
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
			FlxG.switchState(new Intro());
		});
		button.loadButtonGraphic(new FlxSprite('assets/images/ui/start.png'), new FlxSprite('assets/images/ui/startclicked.png'));
		button.screenCenter();
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
