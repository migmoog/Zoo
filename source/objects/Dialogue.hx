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
	var dialogue:Array<String>;
	var currentLine:Int = 0;

	var bgVerts:Array<FlxPoint> = [
		FlxPoint.weak(0, 0),
		FlxPoint.weak(name_tag_x, 0),
		FlxPoint.weak(name_tag_x, 50),
		FlxPoint.weak(850, 50),
		FlxPoint.weak(850, 290),
		FlxPoint.weak(0, 290)
	];

	public var name:String;

	var bg:FlxSprite;
	var nameBox:FlxText;
	var text:FlxTypeText;
	var finishCallback:Void->Void;

	public var canAdvance:Bool = false;

	public function new(fileName:String, ?finishCallback:Void->Void, ?n:String = "Best Friend")
	{
		super();

		this.finishCallback = finishCallback;
		dialogue = Assets.getText('assets/data/dialogues/${fileName}.txt').split('\n');

		bg = new FlxSprite(25, 400);
		bg.makeGraphic(875, 720, FlxColor.TRANSPARENT);
		bg.alpha = 0.50;
		add(bg);
		bg.drawPolygon(bgVerts, FlxColor.BLUE, {color: FlxColor.PURPLE});

		var x_dist = 15;

		name = n;
		nameBox = new FlxText(bg.x + x_dist, bg.y + 10, 0, name, 32);
		nameBox.setFormat("assets/data/monogram_extended.ttf", 32);
		nameBox.color = FlxColor.YELLOW;
		add(nameBox);

		text = new FlxTypeText(bg.x + x_dist, bg.y + 60, 825, dialogue[currentLine], 48, true);
		text.setFormat("assets/data/monogram_extended.ttf", 48);
		text.completeCallback = () -> canAdvance = true;
		add(text);
		text.start(null, false, false, [SPACE], () ->
		{
			canAdvance = true;
		});
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed && canAdvance)
		{
			canAdvance = false;
			currentLine++;

			if (currentLine >= dialogue.length)
				this.kill();
			else
			{
				text.resetText(dialogue[currentLine]);
				start();
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
		if (FlxG.state is PlayState)
		{
			var s:PlayState = cast FlxG.state;
			if (!s.changedStep)
			{
				s.changedStep = true;
				PlayState.steps++;
			}

			if (PlayState.steps > s.dialogueSteps)
				s.canTranslate = false;
			else
				s.canTranslate = true;
		}
		else if (FlxG.state is Intro)
		{
			var s:Intro = cast FlxG.state;
			if (!s.changedStep)
			{
				s.changedStep = true;
				Intro.steps++;
			}
		}

		if (finishCallback != null)
			finishCallback();

		super.kill();
	}

	function start()
		text.start(null, false, false, [SPACE], () -> canAdvance = true);
}
