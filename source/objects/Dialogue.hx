package objects;

import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.utils.Assets;

using flixel.util.FlxSpriteUtil;

var nameTagX = 180;

class Dialogue extends FlxSpriteGroup
{
	var dialogue:Array<String> = [];
	var currentLine:Int = 0;
	var bgVerts:Array<FlxPoint> = [
		new FlxPoint(0, 0),
		new FlxPoint(nameTagX, 0),
		new FlxPoint(nameTagX, 50),
		new FlxPoint(850, 50),
		new FlxPoint(850, 290),
		new FlxPoint(0, 290)
	];

	public var name:String;

	var bg:FlxSprite;
	var nameBox:FlxText;
	var text:FlxTypeText;

	public var canAdvance:Bool = false;

	public function new(fileName:String)
	{
		super();

		// FIXME current issue is that splitting is returning a 1 element array
		dialogue = Assets.getText('assets/data/dialogues/${fileName}.txt').split('\n');
		trace(dialogue.length);

		bg = new FlxSprite(25, 400);
		bg.makeGraphic(875, 720, FlxColor.TRANSPARENT);
		bg.alpha = 0.25;
		add(bg);
		bg.drawPolygon(bgVerts, FlxColor.WHITE, {color: FlxColor.WHITE});

		var x_dist = 15;
		// Name will obviously change
		name = "Best Friend";
		nameBox = new FlxText(bg.x + x_dist, bg.y + 10, 0, name, 32);
		nameBox.setFormat("assets/data/monogram_extended.ttf", 32);
		nameBox.color = FlxColor.YELLOW;
		add(nameBox);

		text = new FlxTypeText(bg.x + x_dist, bg.y + 60, 875, dialogue[currentLine], 32, true);
		text.setFormat("assets/data/monogram_extended.ttf", 32);
		add(text);
		text.start(null, false, false, [SPACE], () -> canAdvance = true);

		#if debug
		FlxG.watch.add(this, "currentLine");
		#end
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed && canAdvance)
		{
			trace(dialogue.length);

			canAdvance = false;
			currentLine++;

			if (currentLine >= dialogue.length)
				this.kill();
			else
			{
				text.resetText(dialogue[currentLine]);
				text.start(null, false, false, [SPACE], () -> canAdvance = true);
			}
		}

		super.update(elapsed);
	}

	function advance() {}
}
