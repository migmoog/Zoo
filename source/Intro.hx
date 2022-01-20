package;

import objects.Dialogue;
import states.*;

class Intro extends FlxState
{
	var cutscene:FlxSprite;
	var d:Dialogue;
	var nextState:Class<FlxState>;

	public static var steps:Int = 0;

	public var changedStep:Bool = false;

	override function create()
	{
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
			FlxG.camera.fade(FlxColor.WHITE, () ->
			{
				if (nextState != null)
					FlxG.switchState(Type.createInstance(nextState, []));
				else
					commenceEnding();
			});
		}, 'You');
		add(d);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function commenceEnding() {}
}
