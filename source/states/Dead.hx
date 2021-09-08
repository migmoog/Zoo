package states;

class Dead extends FlxState
{
	var key:String;
	var animal:Class<Animal>;

	public function new(whichAnimal:Animal)
	{
		super();

		animal = Type.getClass(whichAnimal);
		key = Type.getClassName(animal).toLowerCase();
	}

	override function create()
	{
		add(new FlxSprite().loadGraphic('assets/images/dead screens/${key}_death.png'));
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.mouse.justPressed)
		{
			FlxG.switchState(Type.createInstance(animal, []));
		}

		super.update(elapsed);
	}
}
