package states;

class Dead extends FlxState
{
	var key:String;
	var animal:Class<Animal>;

	public function new(whichAnimal:Animal)
	{
		super();

		animal = Type.getClass(whichAnimal);
		var strWithPckg = Type.getClassName(animal).toLowerCase();
		key = strWithPckg.substring(strWithPckg.indexOf('.') + 1);
	}

	override function create()
	{
		add(new FlxSprite('assets/images/dead screens/${key}_death.png'));
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
