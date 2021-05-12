package states;

import flixel.FlxObject;

enum SpotType
{
	GOOD;
	BAD;
}

class Spot extends FlxObject
{
	public var type:SpotType;
	public var petted:Bool = false;

	public function new(x:Float, y:Float, parent:Animal, type:SpotType)
	{
		this.type = type;

		super(x, y, 10, 10);
	}
}
