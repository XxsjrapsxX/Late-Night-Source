package;

import flixel.FlxSprite;
import lime.utils.Assets;
import lime.system.System;
#if sys
import sys.io.File;
import haxe.io.Path;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
import sys.FileSystem;
#end
import haxe.Json;
import haxe.format.JsonParser;
import tjson.TJSON;
using StringTools;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		#if sys
		var charJson:Dynamic = CoolUtil.parseJson(File.getContent("assets/images/custom_chars/custom_chars.jsonc"));
		#end
		antialiasing = true;
		switch (char) {
			case 'bf':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [0, 1, 24], 0, false, isPlayer);

			case 'bf-car':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [0, 1,24], 0, false, isPlayer);
			case 'bf-christmas':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [0, 1,24], 0, false, isPlayer);
			case 'spooky':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [2, 3], 0, false, isPlayer);
			case 'pico':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [4, 5], 0, false, isPlayer);
			case 'mom':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [6, 7], 0, false, isPlayer);
			case 'mom-car':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [6, 7], 0, false, isPlayer);
			case 'tankman':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [8, 9], 0, false, isPlayer);
			case 'face':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [10, 11], 0, false, isPlayer);
			case 'dad':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [12, 13], 0, false, isPlayer);
			case 'bf-old':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [14, 15], 0, false, isPlayer);
			case 'gf':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [16, 51], 0, false, isPlayer);
			case 'parents-christmas':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [17, 18], 0, false, isPlayer);
			case 'monster':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [19, 20], 0, false, isPlayer);
			case 'monster-christmas':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [19, 20], 0, false, isPlayer);
			case 'senpai':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [22, 42], 0, false, isPlayer);
			case 'senpai-angry':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [44, 45], 0, false, isPlayer);
			case 'spirit':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [23, 47], 0, false, isPlayer);
			case 'bf-pixel':
				loadGraphic('assets/images/iconGrid.png', true, 150, 150);
				animation.add('icon', [21, 41, 25], 0, false, isPlayer);
			default:
				// check if there is an icon file
				if (FileSystem.exists('assets/images/custom_chars/'+char+"/icons.png")) {
					var rawPic:BitmapData = BitmapData.fromFile('assets/images/custom_chars/'+char+"/icons.png");
					loadGraphic(rawPic, true, 150, 150);
					animation.add('icon', Reflect.field(charJson,char).icons, false, isPlayer);
				} else {
					trace("ok so we here");
					loadGraphic('assets/images/iconGrid.png', true, 150, 150);
					animation.add('icon', Reflect.field(charJson,char).icons, false, isPlayer);
				}
		}
		animation.play('icon');
		scrollFactor.set();

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
