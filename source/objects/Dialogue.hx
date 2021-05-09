package objects;

import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Dialogue extends FlxGroup
{
	var dialogue:Array<String> = ["God f-ing damn you're handsome.", "Wanna kiss :0)?"];
	var bgVerts:Array<FlxPoint> = [
		new FlxPoint(0, 0),
		new FlxPoint(150, 0),
		new FlxPoint(150, 50),
		new FlxPoint(850, 50),
		new FlxPoint(850, 290),
		new FlxPoint(0, 290)
	];

	public var name:String;

	var bg:FlxSprite;
	var nameBox:FlxText;
	var text:FlxTypeText;

	public function new(fileName:String)
	{
		super();

		bg = new FlxSprite(25, 400);
		bg.makeGraphic(875, 720, FlxColor.TRANSPARENT);
		bg.alpha = 0.25;
		add(bg);
		bg.drawPolygon(bgVerts, FlxColor.WHITE, {color: FlxColor.WHITE});

		name = "Grondo";
		nameBox = new FlxText(bg.x + 20, bg.y + 10, 0, name, 32);
		nameBox.setFormat("assets/data/monogram_extended.ttf", 32);
		nameBox.color = FlxColor.YELLOW;
		add(nameBox);

		text = new FlxTypeText(bg.x + 20, bg.y + 60, 875, dialogue[0], 32, true);
		text.setFormat("assets/data/monogram_extended.ttf", 32);
		add(text);
		text.start();
	}

	function advance() {}
}
