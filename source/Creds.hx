package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import states.PlayState;

class Creds extends FlxState
{
	var credGroup:FlxSpriteGroup;
	var goobers:FlxSprite;
	var goobText:FlxText;

	override function create()
	{
		FlxG.sound.music.stop();
		FlxG.sound.playMusic('assets/music/credits.mp3');

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

		credGroup.x = mid - 10;
		credGroup.y = FlxG.height + spacing;
		add(credGroup);

		goobers = new FlxSprite(65, 320, 'assets/images/icons/lilgoobers.png');
		add(goobers);
		goobText = new FlxText(goobers.x, goobers.y - 128, 0, "CODE: MigMoog\nART: Tiny", 48);
		goobText.alignment = CENTER;
		add(goobText);

		super.create();
	}

	override function update(elapsed:Float)
	{
		var speed:Float;
		if (FlxG.mouse.pressed)
			speed = 225;
		else
			speed = 100;

		if (credGroup.length > 0)
		{
			var boon:FlxSprite = credGroup.members[credGroup.members.length - 2];
			if ((boon.y + boon.height + 10) > 0)
			{
				credGroup.y -= speed * elapsed;
			}
			else
			{
				goobText.text = "YOUR TIME IS UP\nCLICK TO RESUME YOUR COIL";
				if (FlxG.mouse.justPressed)
				{
					FlxG.camera.fade(FlxColor.LIME, 1, false, () ->

					{
						Intro.steps = PlayState.steps = 0;
						FlxG.switchState(new StartMenu());
					});
				}
			}
		}

		super.update(elapsed);
	}

	function sbtm(s:FlxSprite)
		return s.y + s.height;

	function ic(t:String)
		return 'assets/images/icons/${t + 'icon'}.png';

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
