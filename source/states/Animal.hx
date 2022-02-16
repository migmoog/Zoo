package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.ui.FlxBar;
import flixel.util.FlxColor.*;

class Animal extends FlxState
{
	// The eyes and sliding/rotating bits will be individual to each animal
	var bg:FlxSprite;
	var allSpotChoices:Array<Spot>;
	var spots:FlxTypedGroup<Spot>;
	var baseAniml:FlxSprite;
	var happyBar:FlxBar;
	var chanceBar:FlxTypedGroup<FlxSprite>;

	// name for audio files
	public var name:String;

	public var happiness:Int = 0;
	public var chances:Int = 3;
	public var canClickAgain:Bool = true;
	public var mouseSpritePixels:Bool = false;

	override function create()
	{
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic('assets/music/petting.mp3');
		else
		{
			FlxG.sound.music = null;
			FlxG.sound.playMusic('assets/music/petting.mp3');
		}

		FlxG.plugins.add(new FlxMouseEventManager());

		var w = 65;
		var h = 550;
		happyBar = new FlxBar(FlxG.width - (w + 25), 0, BOTTOM_TO_TOP, w, h, this, 'happiness', 0, spots.members.length, true);
		happyBar.createColoredEmptyBar(TRANSPARENT, true, BLACK);
		happyBar.createColoredFilledBar(fromString('#fff23b'));

		happyBar.screenCenter(Y);
		happyBar.percent = 0;
		add(happyBar);

		chanceBar = new FlxTypedGroup<FlxSprite>(3);
		for (i in 0...3)
		{
			var h = new FlxSprite(happyBar.x - 145, (happyBar.y) + ((175 * i))).loadGraphic("assets/images/ui/zoo_hearts.png", true, 125, 110);
			chanceBar.add(h);
		}
		add(chanceBar);

		FlxMouseEventManager.add(baseAniml, null, null, mouse_over, not_mouse_over);

		super.create();
	}

	override function update(elapsed:Float)
	{
		for (i in 0...3)
			chanceBar.members[i].animation.frameIndex = chances > i ? 0 : 1;

		if (happiness == spots.length && canClickAgain)
		{
			canClickAgain = false;
			FlxG.sound.music.destroy();
			FlxG.sound.music = null;
			FlxG.camera.fade(FlxColor.WHITE, 1, false, () -> FlxG.switchState(new PlayState()));
		}

		if (chances <= 0 && canClickAgain)
		{
			canClickAgain = false;
			FlxG.switchState(new Dead(this));
		}

		super.update(elapsed);
	}

	public function new(spots:Array<Spot>, sprName:String)
	{
		super();
		this.spots = new FlxTypedGroup<Spot>();

		FlxG.random.shuffle(spots);
		for (i in 0...3)
			this.spots.add(spots[i]);

		// Make sure to add() the sprite to the scene yourself
		baseAniml = new FlxSprite(0, 0, 'assets/images/${sprName}/${sprName}.png');
		name = sprName;

		bg = new FlxSprite(0, 0, 'assets/images/backgrounds/${sprName}_bg.png');
		add(bg);
	}

	// will be called at certain times dependant on each animal
	function spotDistance()
	{
		var spot_within:Spot = null;
		for (s in spots.iterator(within_spot))
			spot_within = s;

		if (mouseSpritePixels)
			if (FlxG.mouse.justPressed && canClickAgain)
			{
				if (spot_within != null)
				{
					express(true);
					happiness++;
					spot_within.petted = true;
				}
				else
				{
					express(false);
					chances--;
				}
			}
	}

	function within_spot(s:Spot)
	{
		var m = FlxG.mouse;

		var d_x = m.x - s.x;
		var d_y = m.y - s.y;

		var d = Math.sqrt((d_x * d_x) + (d_y * d_y));

		return d <= s.r && !s.petted;
	}

	function closestSpot()
	{
		var distance = (s:Spot) ->
		{
			var x1 = FlxG.mouse.x - s.x;
			var y1 = FlxG.mouse.y - s.y;

			return Math.sqrt((x1 * x1) + (y1 * y1)) / 100;
		};

		var dists:Array<Float> = [
			for (s in spots.iterator((s) -> !s.petted))
				distance(s)
		];

		var min:Float = dists[0];
		for (i in dists)
			if (i < min)
				min = i;

		return min;
	}

	function express(happy:Bool)
	{
		// animal will have its child tween the jaw and allow clicks again
		canClickAgain = false;
		FlxG.sound.play('assets/sounds/${name}_${happy ? "good" : "bad"}.mp3', 0.5, false, null, true);
	}

	function mouse_over(_)
		mouseSpritePixels = true;

	function not_mouse_over(_)
		mouseSpritePixels = false;
}

class Spot extends FlxObject
{
	public var petted:Bool = false;
	public var r:Float;

	public function new(x:Float, y:Float, r:Float)
	{
		super(x, y, 1, 1);
		this.r = r;
	}
}
