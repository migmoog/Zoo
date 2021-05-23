package states;

import flixel.FlxObject;
import flixel.input.mouse.FlxMouseEventManager;

class Spot extends FlxObject
{
	public var petted:Bool = false;
	public var parent:Animal;
	public var r:Float;

	public function new(x:Float, y:Float, r:Float, parent:Animal)
	{
		super(x, y, 1, 1);
		this.r = r;
	}
}
