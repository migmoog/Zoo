package objects;

import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.utils.Assets;
import states.PlayState;

using flixel.util.FlxSpriteUtil;

private var name_tag_x = 180;

class Dialogue extends FlxSpriteGroup
{
	var inPlayState:Bool;

	var dialogue:Array<String> = [];
	var currentLine:Int = 0;
	var bgVerts:Array<FlxPoint> = [
		new FlxPoint(0, 0),
		new FlxPoint(name_tag_x, 0),
		new FlxPoint(name_tag_x, 50),
		new FlxPoint(850, 50),
		new FlxPoint(850, 290),
		new FlxPoint(0, 290)
	];

	public var name:String;

	var bg:FlxSprite;
	var nameBox:FlxText;
	var text:FlxTypeText;
	var finishCallback:Void->Void;

	public var canAdvance:Bool = false;

	public function new(fileName:String, inPlayState:Bool, ?finishCallback:Void->Void)
	{
		super();

		this.inPlayState = inPlayState;
		this.finishCallback = finishCallback;
		dialogue = Assets.getText('assets/data/dialogues/${fileName}.txt').split('\n');

		bg = new FlxSprite(25, 400);
		bg.makeGraphic(875, 720, FlxColor.TRANSPARENT);
		bg.alpha = 0.25;
		add(bg);
		bg.drawPolygon(bgVerts, FlxColor.WHITE, {color: FlxColor.WHITE});

		var x_dist = 15;

		name = "Best Friend";
		nameBox = new FlxText(bg.x + x_dist, bg.y + 10, 0, name, 32);
		nameBox.setFormat("assets/data/monogram_extended.ttf", 32);
		nameBox.color = FlxColor.YELLOW;
		add(nameBox);

		text = new FlxTypeText(bg.x + x_dist, bg.y + 60, 850, dialogue[currentLine], 48, true);
		text.setFormat("assets/data/monogram_extended.ttf", 48);
		text.completeCallback = () -> canAdvance = true;
		add(text);
		text.start(null, false, false, [SPACE], () ->
		{
			canAdvance = true;
		});
	}

	public function restart(fileName:String)
	{
		this.revive();

		dialogue = Assets.getText('assets/data/dialogues/${fileName}.txt').split('\n');
		currentLine = 0;

		text.resetText(dialogue[currentLine]);
		text.start(null, false, false, [SPACE], () -> canAdvance = true);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed && canAdvance)
		{
			canAdvance = false;
			currentLine++;

			if (currentLine >= dialogue.length)
			{
				this.kill();
			}
			else
			{
				text.resetText(dialogue[currentLine]);
				text.start(null, false, false, [SPACE], () -> canAdvance = true);
			}
		}
		else if (FlxG.mouse.justPressed && !canAdvance)
		{
			text.skip();
			canAdvance = true;
		}

		super.update(elapsed);
	}

	override function kill()
	{
		if (inPlayState)
		{
			var s:PlayState = cast FlxG.state;
			PlayState.steps++;

			if (PlayState.steps > s.dialogueSteps)
				s.canTranslate = false;
			else
				s.canTranslate = true;
		}
		else if (finishCallback != null)
			finishCallback();

		super.kill();
	}
}
