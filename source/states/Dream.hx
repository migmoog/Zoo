package states;

import flixel.text.FlxText;
import flixel.util.FlxTimer;
import objects.Dialogue;
import openfl.events.AsyncErrorEvent;
import openfl.events.NetStatusEvent;
import openfl.events.VideoTextureEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class Dream extends FlxState
{
	var d:Dialogue;
	var c:FlxSprite;

	var wall:FlxSprite;
	var clicks:Int = 0;

	var fadeComplete:Bool = false;
	var finishedCutscene:Bool = false;

	var shakeIntens:Float = 0.08;

	// TODO add cutscene
	override function create()
	{
		c = new FlxSprite('assets/images/char.png');

		d = new Dialogue('dream', () ->
		{
			FlxTween.tween({c: c, d: d}, {
				"c.x": FlxG.width + 25,
				"d.x": FlxG.width + 25,
				"c.alpha": 0.25,
				"d.alpha": 0.25
			}, 3.5, {
				onComplete: (_) ->
				{
					// fadeComplete = true;
					wall = new FlxSprite().loadGraphic('assets/images/backgrounds/dream_wall/wall.png', true, 1280, 720);
					add(wall);
					FlxG.camera.shake(0.015, 0.75, () -> fadeComplete = true);
				}
			});
		});

		add(c);
		add(d);

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (fadeComplete && FlxG.mouse.justPressed)
		{
			if (clicks < 4)
			{
				fadeComplete = false;

				FlxG.camera.shake(shakeIntens, 0.5, () ->
				{
					wall.animation.frameIndex = ++clicks;
					shakeIntens *= 1.25;
					fadeComplete = true;
				});
			}
			else if (clicks >= 4 && netStream == null)
			{
				playEnding();
			}
		}

		if (FlxG.mouse.justPressed && finishedCutscene)
			FlxG.switchState(new Intro());

		super.update(elapsed);
	}

	var video:Video;
	var netStream:NetStream;

	function playEnding()
	{
		video = new Video();
		FlxG.stage.addChild(video);

		var netConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: client_onMetaData};
		netStream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);

		netConnection.addEventListener(NetStatusEvent.NET_STATUS, (e:NetStatusEvent) ->
		{
			if (e.info.code == "NetStream.Play.Start")
			{
				wall.visible = false;
			}
			else if (e.info.code == "NetStream.Play.Complete")
			{
				video.alpha = 0;
				FlxG.camera.fade(FlxColor.WHITE, 1, true, () ->
				{
					FlxG.stage.removeChild(video);

					var first = new FlxText(0, 0, 0, "TEAM MAX HOG", 46);
					first.screenCenter();
					first.alpha = 0;
					first.y -= first.height * 1.5;
					add(first);
					var second = new FlxText(0, 0, 0, "IS NOW REAL", 46);
					second.color = FlxColor.RED;
					second.screenCenter();
					second.alpha = 0;
					add(second);
					FlxTween.tween(first, {alpha: 1}, 1.5, {
						onComplete: (_) ->
						{
							FlxTween.tween(second, {alpha: 1}, 1.5).onComplete = (_) ->
							{
								new FlxTimer().start(1, (_) ->
								{
									finishedCutscene = true;
								});
							};
						}
					});
				});
			}
		});

		netStream.play('assets/images/hog_attack.mp4');
	}

	private function client_onMetaData(metaData:Dynamic)
	{
		video.attachNetStream(netStream);

		video.width = video.videoWidth;
		video.height = video.videoHeight;
	}

	private function netStream_onAsyncError(event:AsyncErrorEvent):Void
	{
		trace("Error loading video");
	}
}
