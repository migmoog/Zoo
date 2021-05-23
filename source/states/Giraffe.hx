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
		if (!tutDialog.alive)
			spotDistance();

		super.update(elapsed);
	}

	public function new()
	{
		super([new Spot(600, 350, 25, this)], "giraffe");
	}
}
