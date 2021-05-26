package states;

import flixel.FlxObject;

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
