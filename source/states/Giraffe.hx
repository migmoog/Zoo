package states;

import objects.Dialogue;

class Giraffe extends Animal
{
	var tutDialog:Dialogue;

	override function create()
	{
		tutDialog = new Dialogue('tutorial', false);
		add(tutDialog);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function new()
	{
		// null for now
		super(null, "giraffe");
	}
}
