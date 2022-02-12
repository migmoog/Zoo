package;

import objects.Dialogue;
import states.*;

class Intro extends FlxState
{
	var cutscene:FlxSprite;
	var d:Dialogue;
	var nextState:Class<FlxState>;
	var faces:FlxSprite;

	public static var steps:Int = 0;

	public var changedStep:Bool = false;

	override function create()
	{
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic('assets/music/room.mp3');

		var timeOfDay:String;

		switch steps
		{
			default:
				timeOfDay = 'morning';
				nextState = PlayState;
			case 1:
				timeOfDay = 'afternoon';
				nextState = Dream;
			case 2:
				timeOfDay = 'night';
		}
		cutscene = new FlxSprite('assets/images/backgrounds/${timeOfDay}_bedroom.png');
		add(cutscene);

		d = new Dialogue(timeOfDay, () ->
		{
			if (nextState != null)
				FlxG.camera.fade(FlxColor.WHITE, () ->
				{
					FlxG.sound.music.stop();
					FlxG.sound.music = null;
					FlxG.switchState(Type.createInstance(nextState, []));
				});
			else
				commenceEnding();
		}, 'You');
		add(d);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function commenceEnding()
	{
		faces = new FlxSprite('assets/images/brofaces.png');
		faces.scale.set(0.0, 0.0);
		faces.alpha = 0;
		add(faces);

		FlxTween.tween({f: faces, b: cutscene}, {
			"f.scale.x": 1,
			"f.scale.y": 1,
			"f.alpha": 1,
			"b.alpha": 0
		}, 2.5, {
			onStart: (_) ->
			{
				FlxG.sound.music.stop();
				FlxG.sound.music = null;
				FlxG.sound.playMusic('assets/music/petting.mp3');
			},
			onComplete: (_) ->
			{
				var dScream = new Dialogue('post-dream', () ->
				{
					FlxG.switchState(new Creds());
				}, "You");
				add(dScream);
			}
		});
	}
}
