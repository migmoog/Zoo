package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

class Creds extends FlxState
{
	var credGroup:FlxSpriteGroup;

	override function create()
	{
		var mid = FlxG.width / 2;
		credGroup = new FlxSpriteGroup();

		var spacing = 64;

		// MUSIC
		var musicCredText:FlxText = credText("Music & Sound");
		var con = new FlxSprite(0, sbtm(musicCredText) + spacing, ic('conun'));

		// adittional art
		var addArtCredText = credText("Additional Art");
		addArtCredText.y = (sbtm(con) + spacing) + spacing;
		var best = new FlxSprite(0, sbtm(addArtCredText) + spacing, ic('best'));
		var nohshy = new FlxSprite(0, sbtm(best) + spacing, ic('nohshy'));

		// pals
		var thankText = credText("Special Thanks To:");
		thankText.y = (nohshy.y + nohshy.height) + spacing;
		var marv = new FlxSprite(0, sbtm(thankText) + spacing, ic('toast'));
		var buhl = new FlxSprite(0, sbtm(marv) + spacing, ic('buhl'));
		var tom = new FlxSprite(0, sbtm(buhl) + spacing, ic('tom'));
		var boon = new FlxSprite(0, sbtm(tom) + spacing, ic('boon'));

		credGroup.add(musicCredText);

		credGroup.add(con);
		credGroup.add(usernameText('conundrynm', con));

		credGroup.add(addArtCredText);

		credGroup.add(best);
		credGroup.add(usernameText('Best\nStromboli', best));
		credGroup.add(nohshy);
		credGroup.add(usernameText('Nohshy', nohshy));

		credGroup.add(thankText);
		credGroup.add(marv);
		credGroup.add(usernameText('Marvelous\nToastbrand', marv));
		credGroup.add(buhl);
		credGroup.add(usernameText('BuhlBoy', buhl));
		credGroup.add(tom);
		credGroup.add(usernameText('Tom', tom));
		credGroup.add(boon);
		credGroup.add(usernameText('Boon', boon));

		credGroup.x = mid - 26;
		credGroup.y = FlxG.height + spacing;
		add(credGroup);

		super.create();
	}

	override function update(elapsed:Float)
	{
		var speed:Float;
		if (FlxG.mouse.pressed)
			speed = 225;
		else
			speed = 100;

		credGroup.y -= speed * elapsed;

		super.update(elapsed);
	}

	function sbtm(s:FlxSprite)
	{
		return s.y + s.height;
	}

	function ic(t:String)
	{
		return 'assets/images/icons/${t + 'icon'}.png';
	}

	function credText(t:String)
	{
		var out = new FlxText(0, 0, 0, t, 64);
		out.setFormat("assets/data/monogram_extended.ttf", 64, FlxColor.WHITE, CENTER);

		return out;
	}

	function usernameText(t:String, s:FlxSprite)
	{
		var out = new FlxText((s.x + s.width) + 32, s.y + s.height / 2, 0, t, 32);
		return out;
	}
}
