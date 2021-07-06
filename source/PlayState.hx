package;

import flixel.math.FlxRandom;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import Shaders.PulseEffect;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

#if windows
import llua.Convert;
import llua.Lua;
import llua.State;
import llua.LuaL;
#end

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import DifficultyIcons;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import lime.system.System;
import flixel.util.FlxAxes;


#if windows
import Discord.DiscordClient;
#end
#if sys
import lime.media.AudioBuffer;
import flash.media.Sound;
#end
#if windows
import Sys;
import sys.io.File;
import openfl.utils.ByteArray;
import haxe.io.Path;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	public static var songPosBG:FlxSprite;
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public var noteShaked:Bool = false;
	public var crazyMode:Bool = false;
	public var isGenocide:Bool = false;
	public var minusHealth:Bool = false;
	public var justDoItMakeYourDreamsComeTrue:Bool = false;
	public var doIt:Bool = true;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	public var furiosityScale:Float = 1.5;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;
	public var curbg:FlxSprite;
	public var screenshader:Shaders.PulseEffect = new PulseEffect();

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	public var carhit:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;
	private var player2Strums:FlxTypedGroup<FlxSprite>;

	private var opponentKeyStatus:Array<Bool> = [false, false, false, false];


	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1;
	private var combo:Int = 0;
	public static var misses:Int = 0;
	private var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var floatshit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var shakeCam:Bool = false;
	private var vibrateCam:Bool = false;
	private var daveCam:Bool = false;
	private var startingSong:Bool = false;
	private var disableCamFollow:Bool = false;
	public static var changedDifficulty:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	private var BAMBICUTSCENEICONHURHURHUR:HealthIcon;
	private var camHUD:FlxCamera;
	private var noteCam:FlxCamera;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var bgv2:FlxSprite;

	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var sweetstagecity:FlxSprite;
	var sweetstagehouse:FlxSprite;
	var sweetstagemackie:FlxSprite;

	var bgcrowd:FlxSprite;
	var smallbgcrowd:FlxSprite;
	var bgcrowdjump:FlxSprite;
	var alya:FlxSprite;
	var anchor:FlxSprite;
	var tricky:FlxSprite;

	public var stupidx:Float = 0;
	public var stupidy:Float = 0; //stupid velocities for cutscene
	public var updatevels:Bool = false;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	
	// have to initialize alllll of this so it can be called by beatHit
	var garageBg:FlxSprite;
	var fgLightbulb:FlxSprite;
	var vignette:FlxSprite;
	var spotlightDJ:FlxSprite;
	var spotlightPlayer:FlxSprite;
	var spotlightDJFloor:FlxSprite;
	var spotlightPlayerFloor:FlxSprite;
	var strobeBlue:FlxSprite;
	var strobeRed:FlxSprite;
	var dreamCrowd:FlxSprite;
	var dreamCrowdBG:FlxSprite;
	var dreamCrowdStrobeBG:FlxSprite;
	var sadie:FlxSprite;
	var sadieDanced:Bool = false;
	var chief:FlxSprite;
	var pantheon:FlxSprite;
	var exterminator:FlxSprite;
	var zball:FlxSprite;
	var radBeatsUntilReaction:Int = -1;
	var bawnebylbg:FlxSprite;
	var thing:FlxSprite;
	var flamebeat:FlxSprite;
	var bawnebylbgBumped:Bool = false;

	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var littleGuys:FlxSprite;
	var santa:FlxSprite;
	var bgBoppers:FlxSprite;
	var boshi:FlxSprite;
	var lights:FlxSprite;
	var speakers:FlxSprite;

	var lookup:FlxSprite;
	var end:FlxSprite;
	var backup:FlxSprite;

	var crowd:FlxSprite;
	var doot:FlxSprite;

	var fc:Bool = true;
	public var elapsedtime:Float = 0;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var noteSpeed:Float = 0.45;

	public static var campaignScore:Int = 0;

	public static var deathCounter:Int = 0;

	var genocideBG:FlxSprite;
	var genocideBoard:FlxSprite;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public static var isNew:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	public var dust:FlxSprite;
	public var car:FlxSprite;

	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	
	var pc:Character;

	var areYouReady:FlxTypedGroup<FlxSprite>;

	var theEntireFuckingStage:FlxTypedGroup<FlxSprite>;

	var mini:FlxSprite;
	var mordecai:FlxSprite;


	private var executeModchart = false;
	var walked:Bool = false;
	var walkingRight:Bool = true;
	var stopWalkTimer:Int = 0;
	// LUA SHIT
		
	public static var lua:State = null;

	function callLua(func_name : String, args : Array<Dynamic>, ?type : String) : Dynamic
	{
		var result : Any = null;

		Lua.getglobal(lua, func_name);

		for( arg in args ) {
		Convert.toLua(lua, arg);
		}

		result = Lua.pcall(lua, args.length, 1, 0);

		if (getLuaErrorMessage(lua) != null)
			if (Lua.tostring(lua,result) != null)
				throw(func_name + ' LUA CALL ERROR ' + Lua.tostring(lua,result));
			else
				trace(func_name + ' prolly doesnt exist lol');

		if( result == null) {
			return null;
		} else {
			return convert(result, type);
		}

	}

	function getType(l, type):Any
	{
		return switch Lua.type(l,type) {
			case t if (t == Lua.LUA_TNIL): null;
			case t if (t == Lua.LUA_TNUMBER): Lua.tonumber(l, type);
			case t if (t == Lua.LUA_TSTRING): (Lua.tostring(l, type):String);
			case t if (t == Lua.LUA_TBOOLEAN): Lua.toboolean(l, type);
			case t: throw 'you don goofed up. lua type error ($t)';
		}
	}

	function getReturnValues(l) {
		var lua_v:Int;
		var v:Any = null;
		while((lua_v = Lua.gettop(l)) != 0) {
			var type:String = getType(l,lua_v);
			v = convert(lua_v, type);
			Lua.pop(l, 1);
		}
		return v;
	}


	private function convert(v : Any, type : String) : Dynamic { // I didn't write this lol
		if( Std.is(v, String) && type != null ) {
		var v : String = v;
		if( type.substr(0, 4) == 'array' ) {
			if( type.substr(4) == 'float' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Float> = new Array();

			for( vars in array ) {
				array2.push(Std.parseFloat(vars));
			}

			return array2;
			} else if( type.substr(4) == 'int' ) {
			var array : Array<String> = v.split(',');
			var array2 : Array<Int> = new Array();

			for( vars in array ) {
				array2.push(Std.parseInt(vars));
			}

			return array2;
			} else {
			var array : Array<String> = v.split(',');
			return array;
			}
		} else if( type == 'float' ) {
			return Std.parseFloat(v);
		} else if( type == 'int' ) {
			return Std.parseInt(v);
		} else if( type == 'bool' ) {
			if( v == 'true' ) {
			return true;
			} else {
			return false;
			}
		} else {
			return v;
		}
		} else {
		return v;
		}
	}

	function getLuaErrorMessage(l) {
		var v:String = Lua.tostring(l, -1);
		Lua.pop(l, 1);
		return v;
	}

	public function setVar(var_name : String, object : Dynamic){
		// trace('setting variable ' + var_name + ' to ' + object);

		Lua.pushnumber(lua,object);
		Lua.setglobal(lua, var_name);
	}

	public function getVar(var_name : String, type : String) : Dynamic {
		var result : Any = null;

		// trace('getting variable ' + var_name + ' with a type of ' + type);

		Lua.getglobal(lua, var_name);
		result = Convert.fromLua(lua,-1);
		Lua.pop(lua,1);

		if( result == null ) {
		return null;
		} else {
		var result = convert(result, type);
		//trace(var_name + ' result: ' + result);
		return result;
		}
	}

	function getActorByName(id:String):Dynamic
	{
		// pre defined names
		switch(id)
		{
			case 'boyfriend':
				return boyfriend;
			case 'girlfriend':
				return gf;
			case 'dad':
				return dad;
		}
		// lua objects or what ever
		if (luaSprites.get(id) == null)
			return strumLineNotes.members[Std.parseInt(id)];
		return luaSprites.get(id);
	}

	public static var luaSprites:Map<String,FlxSprite> = [];



	function makeLuaSprite(spritePath:String,toBeCalled:String, drawBehind:Bool)
	{
		#if sys
		var data:BitmapData = BitmapData.fromFile(Sys.getCwd() + "assets/data/" + PlayState.SONG.song.toLowerCase() + '/' + spritePath + ".png");

		var sprite:FlxSprite = new FlxSprite(0,0);
		var imgWidth:Float = FlxG.width / data.width;
		var imgHeight:Float = FlxG.height / data.height;
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;

		// Cap the scale at x1
		if (scale > 1)
		{
			scale = 1;
		}

		sprite.makeGraphic(Std.int(data.width * scale),Std.int(data.width * scale),FlxColor.TRANSPARENT);

		var data2:BitmapData = sprite.pixels.clone();
		var matrix:Matrix = new Matrix();
		matrix.identity();
		matrix.scale(scale, scale);
		data2.fillRect(data2.rect, FlxColor.TRANSPARENT);
		data2.draw(data, matrix, null, null, null, true);
		sprite.pixels = data2;
		
		luaSprites.set(toBeCalled,sprite);
		// and I quote:
		// shitty layering but it works!
		if (drawBehind)
		{
			remove(gf);
			remove(boyfriend);
			remove(dad);
		}
		add(sprite);
		if (drawBehind)
		{
			add(gf);
			add(boyfriend);
			add(dad);
		}
		#end
		return toBeCalled;
	}

	// LUA SHIT

	override public function create()
	{
	
		isNew = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;

		misses = 0;

		repPresses = 0;
		repReleases = 0;

		#if sys
		executeModchart = FileSystem.exists(Paths.lua(PlayState.SONG.song.toLowerCase()  + "/modchart"));
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart"));

		#if windows
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "Alt";
			case 4:
				storyDifficultyText = "Crazy";
			case 5:
				storyDifficultyText = "Unnerfed";
		}

		iconRPC = SONG.player2;

		isGenocide = (SONG.song.toLowerCase() == 'genocide');
		minusHealth = false;
		justDoItMakeYourDreamsComeTrue = false;
		doIt = true;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		noteCam = new FlxCamera();
		noteCam.bgColor.alpha = 0;


		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(noteCam);



		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		// prefer player 1
		if (FileSystem.exists('assets/images/custom_chars/'+SONG.player1+'/'+SONG.song.toLowerCase()+'Dialog.txt')) {
			dialogue = CoolUtil.coolDynamicTextFile('assets/images/custom_chars/'+SONG.player1+'/'+SONG.song.toLowerCase()+'Dialog.txt');
		// if no player 1 unique dialog, use player 2
		} else if (FileSystem.exists('assets/images/custom_chars/'+SONG.player2+'/'+SONG.song.toLowerCase()+'Dialog.txt')) {
			dialogue = CoolUtil.coolDynamicTextFile('assets/images/custom_chars/'+SONG.player2+'/'+SONG.song.toLowerCase()+'Dialog.txt');
		// if no player dialog, use default
		}	else if (FileSystem.exists('assets/data/'+SONG.song.toLowerCase()+'/dialog.txt')) {
			dialogue = CoolUtil.coolDynamicTextFile('assets/data/'+SONG.song.toLowerCase()+'/dialog.txt');
		} else if (FileSystem.exists('assets/data/'+SONG.song.toLowerCase()+'/dialogue.txt')){
			// nerds spell dialogue properly gotta make em happy
			dialogue = CoolUtil.coolDynamicTextFile('assets/data/' + SONG.song.toLowerCase() + '/dialogue.txt');
		// otherwise, make the dialog an error message
		} else {
			dialogue = [':dad: The game tried to get a dialog file but couldn\'t find it. Please make sure there is a dialog file named "dialog.txt".'];
		}

		if (SONG.stage == 'spooky')
			{
				curStage = "spooky";
				halloweenLevel = true;
	
				var hallowTex = FlxAtlasFrames.fromSparrow('assets/images/halloween_bg.png', 'assets/images/halloween_bg.xml');
	
				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);
	
				isHalloween = true;
			}
			else if (SONG.stage == 'philly')
			{
				curStage = 'philly';
	
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic('assets/images/philly/sky.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
	
				var city:FlxSprite = new FlxSprite(-10).loadGraphic('assets/images/philly/city.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);
	
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);
	
				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic('assets/images/philly/win' + i + '.png');
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}
	
				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic('assets/images/philly/behindTrain.png');
				add(streetBehind);
	
				phillyTrain = new FlxSprite(2000, 360).loadGraphic('assets/images/philly/train.png');
				add(phillyTrain);
	
				trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
				FlxG.sound.list.add(trainSound);
	
				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
	
				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic('assets/images/philly/street.png');
				add(street);
			}
			else if (SONG.stage == 'limo')
			{
				curStage = 'limo';
				defaultCamZoom = 0.90;
	
				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic('assets/images/limo/limoSunset.png');
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);
	
				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = FlxAtlasFrames.fromSparrow('assets/images/limo/bgLimo.png', 'assets/images/limo/bgLimo.xml');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);
	
				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);
	
				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}
	
				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic('assets/images/limo/limoOverlay.png');
				overlayShit.alpha = 0.5;
				// add(overlayShit);
	
				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);
	
				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);
	
				// overlayShit.shader = shaderBullshit;
	
				var limoTex = FlxAtlasFrames.fromSparrow('assets/images/limo/limoDrive.png', 'assets/images/limo/limoDrive.xml');
	
				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;
	
				fastCar = new FlxSprite(-300, 160).loadGraphic('assets/images/limo/fastCarLol.png');
				// add(limo);
			}
			else if (SONG.stage == 'mall')
			{
				curStage = 'mall';
	
				defaultCamZoom = 0.80;
	
				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic('assets/images/christmas/bgWalls.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/upperBop.png', 'assets/images/christmas/upperBop.xml');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);
	
				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic('assets/images/christmas/bgEscalator.png');
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);
	
				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic('assets/images/christmas/christmasTree.png');
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);
	
				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/bottomBop.png', 'assets/images/christmas/bottomBop.xml');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);
	
				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic('assets/images/christmas/fgSnow.png');
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);
	
				santa = new FlxSprite(-840, 150);
				santa.frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/santa.png', 'assets/images/christmas/santa.xml');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			}
			else if (SONG.stage == 'mallEvil')
			{
				curStage = 'mallEvil';
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic('assets/images/christmas/evilBG.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
	
				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic('assets/images/christmas/evilTree.png');
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);
	
				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic("assets/images/christmas/evilSnow.png");
				evilSnow.antialiasing = true;
				add(evilSnow);
			}
			else if (SONG.stage == 'school')
			{
				curStage = 'school';
				// defaultCamZoom = 0.9;
	
				var bgSky = new FlxSprite().loadGraphic('assets/images/weeb/weebSky.png');
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);
	
				var repositionShit = -200;
	
				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic('assets/images/weeb/weebSchool.png');
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);
	
				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic('assets/images/weeb/weebStreet.png');
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);
	
				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic('assets/images/weeb/weebTreesBack.png');
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);
	
				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = FlxAtlasFrames.fromSpriteSheetPacker('assets/images/weeb/weebTrees.png', 'assets/images/weeb/weebTrees.txt');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
	
				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/petals.png', 'assets/images/weeb/petals.xml');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);
	
				var widShit = Std.int(bgSky.width * 6);
	
				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);
	
				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();
	
				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);
	
				if (SONG.isMoody)
				{
					bgGirls.getScared();
				}
	
				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			}
			else if (SONG.stage == 'schoolEvil')
			{
				curStage = 'schoolEvil';
	
				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
	
				var posX = 400;
				var posY = 200;
	
				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/animatedEvilSchool.png', 'assets/images/weeb/animatedEvilSchool.xml');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
				trace("schoolEvilComplete");
				/*
					var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/weeb/evilSchoolBG.png');
					bg.scale.set(6, 6);
					// bg.setGraphicSize(Std.int(bg.width * 6));
					// bg.updateHitbox();
					add(bg);
	
					var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic('assets/images/weeb/evilSchoolFG.png');
					fg.scale.set(6, 6);
					// fg.setGraphicSize(Std.int(fg.width * 6));
					// fg.updateHitbox();
					add(fg);
	
					wiggleShit.effectType = WiggleEffectType.DREAMY;
					wiggleShit.waveAmplitude = 0.01;
					wiggleShit.waveFrequency = 60;
					wiggleShit.waveSpeed = 0.8;
				 */
	
				// bg.shader = wiggleShit.shader;
				// fg.shader = wiggleShit.shader;
	
				/*
					var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
					var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
	
					// Using scale since setGraphicSize() doesnt work???
					waveSprite.scale.set(6, 6);
					waveSpriteFG.scale.set(6, 6);
					waveSprite.setPosition(posX, posY);
					waveSpriteFG.setPosition(posX, posY);
	
					waveSprite.scrollFactor.set(0.7, 0.8);
					waveSpriteFG.scrollFactor.set(0.9, 0.8);
	
					// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
					// waveSprite.updateHitbox();
					// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
					// waveSpriteFG.updateHitbox();
	
					add(waveSprite);
					add(waveSpriteFG);
				 */
			}
			else if (SONG.stage == "stage")
			{
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/stageback.png');
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic('assets/images/stagefront.png');
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
	
				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic('assets/images/stagecurtains.png');
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
	
				add(stageCurtains);
			} else {
				// use assets
				var parsedStageJson = CoolUtil.parseJson(File.getContent("assets/images/custom_stages/custom_stages.json"));
				switch (Reflect.field(parsedStageJson, SONG.stage)) {
					case 'stage':
						defaultCamZoom = 0.9;
						// pretend it's stage, it doesn't check for correct images
						curStage = 'stage';
						// peck it no one is gonna build this for html5 so who cares if it doesn't compile
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stageback.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stageback.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
	
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
						// bg.setGraphicSize(Std.int(bg.width * 2.5));
						// bg.updateHitbox();
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
						var frontPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stagefront.png")) {
							frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stagefront.png");
						} else {
							// fall back on base game file to avoid crashes
							frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
						}
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(frontPic);
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = true;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
						var curtainPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stagecurtains.png")) {
							curtainPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stagecurtains.png");
						} else {
							// fall back on base game file to avoid crashes
							curtainPic = BitmapData.fromImage(Assets.getImage("assets/images/stagecurtains.png"));
						}
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(curtainPic);
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = true;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
					case 'village':
				{
						defaultCamZoom = 0.6;
						curStage = 'village';

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg:FlxSprite = new FlxSprite(0, -100).loadGraphic(bgPic);
						bg.setGraphicSize(Std.int(bg.width * 1.4));
						bg.antialiasing = true;
						bg.scrollFactor.set(0, 0.9);
						bg.active = false;
						add(bg);
						
						var hillPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hill.png")) {
							hillPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/hill.png");
						} else {
							// fall back on base game file to avoid crashes
							hillPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var hill:FlxSprite = new FlxSprite(-200, -480).loadGraphic(hillPic);
						hill.setGraphicSize(Std.int(hill.width * 1.45));
						hill.antialiasing = true;
						hill.scrollFactor.set(0.6, 0.5);
						hill.active = false;
						add(hill);
						
						var treePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bg_trees.png")) {
							treePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bg_trees.png");
						} else {
							// fall back on base game file to avoid crashes
							treePic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bgtree:FlxSprite = new FlxSprite(-850, -320).loadGraphic(treePic);
						bgtree.setGraphicSize(Std.int(bgtree.width * 1.45));
						bgtree.antialiasing = true;
						bgtree.scrollFactor.set(0.7, 0.6);
						bgtree.active = false;
						add(bgtree);
						
						var bgtPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/background.png")) {
							bgtPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/background.png");
						} else {
							// fall back on base game file to avoid crashes
							bgtPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bgt:FlxSprite = new FlxSprite(-600, -500).loadGraphic(bgtPic);
						bgt.setGraphicSize(Std.int(bgt.width * 1.15));
						bgt.updateHitbox();
						bgt.antialiasing = true;
						bgt.scrollFactor.set(1.1, 1.01);
						bgt.active = false;
						add(bgt);						
						
						var mgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/middleground.png")) {
							mgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/middleground.png");
						} else {
							// fall back on base game file to avoid crashes
							mgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var mg:FlxSprite = new FlxSprite(-1050, -470).loadGraphic(mgPic);
						mg.setGraphicSize(Std.int(mg.width * 1.2));
						mg.updateHitbox();
						mg.antialiasing = true;
						mg.scrollFactor.set(1, 1.05);
						mg.active = false;
						add(mg);
						
						var fgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/terrain.png")) {
							fgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/terrain.png");
						} else {
							// fall back on base game file to avoid crashes
							fgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var fg:FlxSprite = new FlxSprite(-1450, -650).loadGraphic(fgPic);
						fg.setGraphicSize(Std.int(fg.width * 1.45));
						fg.updateHitbox();
						fg.antialiasing = true;
						fg.scrollFactor.set(1, 1);
						fg.active = false;
						add(fg);	
						
						var housemgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/housemg.png")) {
							housemgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/housemg.png");
						} else {
							// fall back on base game file to avoid crashes
							housemgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var housemg:FlxSprite = new FlxSprite(-1350, -470).loadGraphic(housemgPic);
						housemg.setGraphicSize(Std.int(housemg.width * 1.2));
						housemg.updateHitbox();
						housemg.antialiasing = true;
						housemg.scrollFactor.set(1.02, 1.02);
						housemg.active = false;
						add(housemg);		
						
						var housePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/house.png")) {
							housePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/house.png");
						} else {
							// fall back on base game file to avoid crashes
							housePic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var house:FlxSprite = new FlxSprite(-1450, -600).loadGraphic(housePic);
						house.setGraphicSize(Std.int(housemg.width * 1.2));
						house.updateHitbox();
						house.antialiasing = true;
						house.scrollFactor.set(1.01, 1);
						house.active = false;
						add(house);	
	
						

				}
				case 'garage':
					{
						curStage = 'garage';

						var garagebgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/garage-bg.png")) {
							garagebgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/garage-bg.png");
						} else {
							// fall back on base game file to avoid crashes
							garagebgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						garageBg = new FlxSprite(-114, -131).loadGraphic(garagebgPic);
						garageBg.antialiasing = true;
						garageBg.scrollFactor.set(0.9, 0.9);
						garageBg.active = false;
						garageBg.alpha = 1;
						
						var fglightPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/garage-fg.png")) {
							fglightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/garage-fg.png");
						} else {
							// fall back on base game file to avoid crashes
							fglightPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						fgLightbulb = new FlxSprite(-14, -31).loadGraphic(fglightPic);
						fgLightbulb.screenCenter(X);
						fgLightbulb.x += 75;
						fgLightbulb.updateHitbox();
						fgLightbulb.antialiasing = true;
						fgLightbulb.scrollFactor.set(0.95, 0.95);
						fgLightbulb.active = false;
						fgLightbulb.alpha = 1;

						var spotlightPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spotlight-dj.png")) {
							spotlightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/spotlight-dj.png");
						} else {
							// fall back on base game file to avoid crashes
							spotlightPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
						
						spotlightDJ = new FlxSprite(0, 0).loadGraphic(spotlightPic);
						spotlightDJ.screenCenter(X);
						spotlightDJ.x -= 185;
						spotlightDJ.y -= 580;
						spotlightDJ.setGraphicSize(Std.int(spotlightDJ.width * 1.3));
						spotlightDJ.updateHitbox();
						spotlightDJ.antialiasing = true;
						spotlightDJ.scrollFactor.set(0.95, 0.95);
						spotlightDJ.active = false;
						spotlightDJ.alpha = 0;
						
						var djfloorPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spotlight-dj-floor.png")) {
							djfloorPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/spotlight-dj-floor.png");
						} else {
							// fall back on base game file to avoid crashes
							djfloorPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}


						spotlightDJFloor = new FlxSprite(0, 0).loadGraphic(djfloorPic);
						spotlightDJFloor.setGraphicSize(Std.int(spotlightDJFloor.width * 1.265));
						spotlightDJFloor.setPosition(spotlightDJ.x - 25, spotlightDJ.y + 1335);
						spotlightDJFloor.updateHitbox();
						spotlightDJFloor.antialiasing = true;
						spotlightDJFloor.scrollFactor.set(0.95, 0.95);
						spotlightDJFloor.active = false;
						spotlightDJFloor.alpha = 0;

						var spotplayerPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spotlight-player.png")) {
							spotplayerPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/spotlight-player.png");
						} else {
							// fall back on base game file to avoid crashes
							spotplayerPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						
						spotlightPlayer = new FlxSprite(0, 0).loadGraphic(spotplayerPic);
						spotlightPlayer.screenCenter(X);
						spotlightPlayer.x += 265;
						spotlightPlayer.y -= 600;
						spotlightPlayer.setGraphicSize(Std.int(spotlightPlayer.width * 1.3));
						spotlightPlayer.updateHitbox();
						spotlightPlayer.antialiasing = true;
						spotlightPlayer.scrollFactor.set(0.95, 0.95);
						spotlightPlayer.active = false;
						spotlightPlayer.alpha = 0;
						
						var playerfloorPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spotlight-player-floor.png")) {
							playerfloorPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/spotlight-player-floor.png");
						} else {
							// fall back on base game file to avoid crashes
							playerfloorPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}


						spotlightPlayerFloor = new FlxSprite(0, 0).loadGraphic(playerfloorPic);
						spotlightPlayerFloor.setGraphicSize(Std.int(spotlightPlayerFloor.width * 1.285));
						spotlightPlayerFloor.setPosition(spotlightPlayer.x, spotlightPlayer.y + 1400);
						spotlightPlayerFloor.updateHitbox();
						spotlightPlayerFloor.antialiasing = true;
						spotlightPlayerFloor.scrollFactor.set(0.95, 0.95);
						spotlightPlayerFloor.active = false;
						spotlightPlayerFloor.alpha = 0;

						var strobebgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/blackblock.png")) {
							strobebgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/blackblock.png");
						} else {
							// fall back on base game file to avoid crashes
							strobebgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						
						dreamCrowdStrobeBG = new FlxSprite(0, 415).loadGraphic(strobebgPic);
						dreamCrowdStrobeBG.antialiasing = true;
						dreamCrowdStrobeBG.scrollFactor.set(0.70, 0.70);
						dreamCrowdStrobeBG.active = false;
						
						var standsPic:BitmapData;
						var standsXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowdBG.png")) {
						   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/crowdBG.png");
						} else {
						   // fall back on base game file to avoid crashes
							 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowd.xml")) {
						   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/crowd.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
						}

						dreamCrowdBG = new FlxSprite(0, 252);
						dreamCrowdBG.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
						dreamCrowdBG.antialiasing = true;
						dreamCrowdBG.animation.addByPrefix('crowd', 'crowd', 30, true);
						dreamCrowdBG.animation.play('crowd');
						dreamCrowdBG.scrollFactor.set(0.70, 0.70);
						
						var stands2Pic:BitmapData;
						var stands2Xml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowd.png")) {
						   stands2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/crowd.png");
						} else {
						   // fall back on base game file to avoid crashes
							 stands2Pic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowd.xml")) {
						   stands2Xml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/crowd.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 stands2Xml = Assets.getText("assets/images/christmas/upperBop.xml");
						}


						dreamCrowd = new FlxSprite(0, 250);
						dreamCrowd.frames = FlxAtlasFrames.fromSparrow(stands2Pic, stands2Xml);
						dreamCrowd.animation.addByPrefix('crowd', 'crowd', 30, true);
						dreamCrowd.animation.play('crowd');
						dreamCrowd.scrollFactor.set(0.70, 0.70);

						var bgPic:BitmapData;
						var bgXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/strobelight-red.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/strobelight-red.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
						}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/strobelight-red.xml")) {
						   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/strobelight-red.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 bgXml = Assets.getText("assets/images/halloween_bg.xml");
						}
						var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

						
						strobeRed = new FlxSprite(100, -185);
						strobeRed.frames = hallowTex;
						strobeRed.animation.addByPrefix('strobelight', 'strobelight-red', 24, true);
						strobeRed.animation.play('strobelight');
						strobeRed.scrollFactor.set(0.50, 0.50);
						strobeRed.setGraphicSize(Std.int(strobeRed.width * 0.6));
						strobeRed.alpha = 0.01;
						strobeRed.updateHitbox();
						
						var bg2Pic:BitmapData;
						var bg2Xml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/strobelight-blue.png")) {
							bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/strobelight-blue.png");
						} else {
							// fall back on base game file to avoid crashes
							bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
						}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/strobelight-blue.xml")) {
						   bg2Xml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/strobelight-blue.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 bg2Xml = Assets.getText("assets/images/halloween_bg.xml");
						}
						var hallowTex2 = FlxAtlasFrames.fromSparrow(bg2Pic, bg2Xml);

						
						strobeBlue = new FlxSprite(50, -185);
						strobeBlue.frames = hallowTex2;
						strobeBlue.animation.addByPrefix('strobelight', 'strobelight-blue', 24, true);
						strobeBlue.animation.play('strobelight');
						strobeBlue.scrollFactor.set(0.50, 0.50);
						strobeBlue.setGraphicSize(Std.int(strobeBlue.width * 0.6));
						strobeBlue.alpha = 0.01;
						strobeBlue.updateHitbox();
						
						var vignettePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/vignette.png")) {
							vignettePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/vignette.png");
						} else {
							// fall back on base game file to avoid crashes
							vignettePic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}


						vignette = new FlxSprite(64, 36).loadGraphic(vignettePic);
						vignette.antialiasing = true;
						vignette.scrollFactor.set(0, 0);
						vignette.setGraphicSize(Std.int(vignette.width * 1));
						vignette.active = false;
						vignette.screenCenter();
						vignette.alpha = 0;
						
						// layering bs
						add(strobeRed);
						add(strobeBlue);
						add(dreamCrowdStrobeBG);
						add(dreamCrowdBG);
						add(dreamCrowd);
						add(spotlightDJFloor);
						add(spotlightPlayerFloor);
						add(garageBg);
					}
					case 'rucksburg':
						{
							defaultCamZoom = 0.75;
							curStage = 'rucksburg';

							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rucksburg.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rucksburg.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							
							var bg:FlxSprite = new FlxSprite(-420, -300).loadGraphic(bgPic);
							bg.setGraphicSize(Std.int(bg.width * 0.6));
							bg.updateHitbox();
							bg.antialiasing = true;
							bg.scrollFactor.set(0.35, 0.35);
							bg.active = false;
							// tower

							var bg2Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tower.png")) {
								bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tower.png");
							} else {
								// fall back on base game file to avoid crashes
								bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	

							var tower:FlxSprite = new FlxSprite(-445, -275).loadGraphic(bg2Pic);
							tower.setGraphicSize(Std.int(tower.width * 0.625));
							tower.updateHitbox();
							tower.antialiasing = true;
							tower.scrollFactor.set(0.45, 0.45);
							tower.active = false;
							// clouds

							var bg3Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/clouds.png")) {
								bg3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/clouds.png");
							} else {
								// fall back on base game file to avoid crashes
								bg3Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}


							var clouds:FlxSprite = new FlxSprite(-225, -205).loadGraphic(bg3Pic);
							clouds.setGraphicSize(Std.int(clouds.width * 0.5));
							clouds.updateHitbox();
							clouds.antialiasing = true;
							clouds.scrollFactor.set(0.4, 0.4);
							clouds.active = false;
							// middleground

							var bg4Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/middleground.png")) {
								bg4Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/middleground.png");
							} else {
								// fall back on base game file to avoid crashes
								bg4Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}


							var middleground:FlxSprite = new FlxSprite(-420, 0).loadGraphic(bg4Pic);
							middleground.setGraphicSize(Std.int(middleground.width * 0.775));
							middleground.updateHitbox();
							middleground.antialiasing = true;
							middleground.scrollFactor.set(0.95, 0.95);
							middleground.active = false;
							middleground.screenCenter();
							middleground.y += 112;
							// bushes

							var bg5Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bushes.png")) {
								bg5Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bushes.png");
							} else {
								// fall back on base game file to avoid crashes
								bg5Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}


							var bushes:FlxSprite = new FlxSprite(-420, 0).loadGraphic(bg5Pic);
							bushes.setGraphicSize(Std.int(bushes.width * 0.600));
							bushes.updateHitbox();
							bushes.antialiasing = true;
							bushes.scrollFactor.set(0.98, 0.98);
							bushes.active = false;
							bushes.screenCenter(Y);
							bushes.y += 40;
							// sadie

							var santaPic:BitmapData;
							var santaXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Sadie.png")) {
							   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/Sadie.png");
							} else {
							   // fall back on base game file to avoid crashes
								 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Sadie.xml")) {
							   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/Sadie.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 santaXml = Assets.getText("assets/images/christmas/santa.xml");
							}
	

							sadie = new FlxSprite(-70, 225);
							sadie.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
							sadie.animation.addByIndices('sadieRight', "Sadie", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26], "", 24, false);
							sadie.animation.addByIndices('sadieLeft', "Sadie", [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
							sadie.animation.play('sadieRight');
							sadie.scrollFactor.set(0.95, 0.95);
							sadie.setGraphicSize(Std.int(sadie.width * 1.06));
							sadie.updateHitbox();
							// Chief

							var santa2Pic:BitmapData;
							var santa2Xml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Chief Edwards.png")) {
							   santa2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/Chief Edwards.png");
							} else {
							   // fall back on base game file to avoid crashes
								 santa2Pic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Chief Edwards.xml")) {
							   santa2Xml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/Chief Edwards.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 santa2Xml = Assets.getText("assets/images/christmas/santa.xml");
							}
	

							chief = new FlxSprite(-340, 185);
							chief.frames = FlxAtlasFrames.fromSparrow(santa2Pic, santa2Xml);
							chief.animation.addByPrefix('chief', 'Chief', 24, true);
							chief.animation.play('chief');
							chief.scrollFactor.set(0.95, 0.95);
							chief.setGraphicSize(Std.int(chief.width * 1.06));
							chief.updateHitbox();
							// Pantheon

							var santa3Pic:BitmapData;
							var santa3Xml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Pantheon.png")) {
							   santa3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/Pantheon.png");
							} else {
							   // fall back on base game file to avoid crashes
								 santa3Pic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Pantheon.xml")) {
							   santa3Xml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/Pantheon.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 santa3Xml = Assets.getText("assets/images/christmas/santa.xml");
							}
	

							pantheon = new FlxSprite(1320, 95);
							pantheon.frames = FlxAtlasFrames.fromSparrow(santa3Pic, santa3Xml);
							pantheon.animation.addByPrefix('pantheon', 'Pantheon', 24, true);
							pantheon.animation.play('pantheon');
							pantheon.scrollFactor.set(0.95, 0.95);
							pantheon.setGraphicSize(Std.int(pantheon.width * 0.9));
							pantheon.updateHitbox();
							/*
							
							exterminator no longer exists at of 0.9.
							I wish I could give an answer why, but at the end
							of the day nobody actually cares this much about
							a background asset. 3 updates from now nobody will
							even know it existed. the reason it got removed is
							because of very petty drama, so it's not worth 
							explaining anyways.
							
							*/
							// exterminator = new FlxSprite(1600, 250);
							// exterminator.frames = FlxAtlasFrames.fromSparrow('assets/images/Mr. Rad/Exterminator.png','assets/images/Mr. Rad/Exterminator.xml');
							// exterminator.animation.addByPrefix('exterminator', 'exterminator', 24, true);
							// exterminator.animation.play('exterminator');
							// exterminator.scrollFactor.set(0.60, 0.60);
							// exterminator.setGraphicSize(Std.int(exterminator.width * 0.35));
							// exterminator.updateHitbox();
							// zball

							var santa4Pic:BitmapData;
							var santa4Xml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Z-Ball.png")) {
							   santa4Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/Z-Ball.png");
							} else {
							   // fall back on base game file to avoid crashes
								 santa4Pic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Z-Ball.xml")) {
							   santa4Xml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/Z-Ball.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 santa4Xml = Assets.getText("assets/images/christmas/santa.xml");
							}
	

							zball = new FlxSprite(-10000, 200);
							zball.frames = FlxAtlasFrames.fromSparrow(santa4Pic, santa4Xml);
							zball.animation.addByPrefix('zball', 'zball', 24, true);
							zball.animation.play('zball');
							zball.scrollFactor.set(0.40, 0.40);
							zball.setGraphicSize(Std.int(zball.width * 0.3));
							zball.updateHitbox();
							// layering
							add(bg);
							add(clouds);
							add(zball);
							add(tower);
							// add(exterminator);
							add(middleground);
							add(chief);
							add(pantheon);
							add(sadie);
							add(bushes);
							FlxTween.tween(zball, {x: 10000}, 30, {ease: FlxEase.linear, type: LOOPING});
							FlxTween.tween(zball, {y: 202}, 0.5, {ease: FlxEase.linear, type: LOOPING});
							// FlxTween.tween(exterminator, {y: 150}, 0.8, {ease: FlxEase.smootherStepInOut, type: PINGPONG});	
						}
					case 'wocky':
						{
							defaultCamZoom = 0.9;
							curStage = 'wocky';

							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stageback.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stageback.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
				

							var frontPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stagefront.png")) {
								frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stagefront.png");
							} else {
								// fall back on base game file to avoid crashes
								frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
							}
	
							var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(frontPic);
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);
													
							phillyCityLights = new FlxTypedGroup<FlxSprite>();
							add(phillyCityLights);
				
							for (i in 0...4)
							{

								var lightPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png")) {
									lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png");
								} else {
									// fall back on base game file to avoid crashes
									lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
								}

									var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('philly/win' + i));
									light.scrollFactor.set(0.9, 0.9);
									light.visible = false;
									light.updateHitbox();
									light.antialiasing = true;
									phillyCityLights.add(light);
							
							}
							// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
				
						}
						case 'momiStage':
							{
									defaultCamZoom = 0.9;
									curStage = 'momiStage';

									var bgPic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bg.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bg.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
									}
		
									var bg:FlxSprite = new FlxSprite(-175.3, -225.95).loadGraphic(bgPic);
									bg.antialiasing = true;
									bg.scrollFactor.set(0.9, 1);
									bg.active = false;
									add(bg);
									
									var dustPic:BitmapData;
									var dustXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/dust.png")) {
										dustPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/dust.png");
									} else {
										// fall back on base game file to avoid crashes
										dustPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/dust.xml")) {
									   dustXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/dust.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 dustXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(dustPic, dustXml);
		
									dust = new FlxSprite( -238.3, 371.55);
									dust.frames = hallowTex;
									dust.animation.addByPrefix("bop", "dust", 24, false);
									dust.scrollFactor.set(1.2, 1.2);
									dust.visible = false;
									dust.animation.play("bop");
									
									var hitPic:BitmapData;
									var hitXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/carhit.png")) {
										hitPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/carhit.png");
									} else {
										// fall back on base game file to avoid crashes
										hitPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/carhit.xml")) {
									   hitXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/carhit.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 hitXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(hitPic, hitXml);

									carhit = new FlxSprite( -807.15, -999);
									carhit.frames = hallowTex;
									carhit.animation.addByPrefix("hit", "hit", 12, false);
									//carhit.alpha = 0;
									carhit.animation.play("hit");
									
									var carPic:BitmapData;
									var carXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/car.png")) {
										carPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/car.png");
									} else {
										// fall back on base game file to avoid crashes
										carPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/car.xml")) {
									   carXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/car.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 carXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(carPic, carXml);

									car = new FlxSprite( -1514.4, 199.8);
									car.scrollFactor.set(1.2,1.2);
									car.frames = hallowTex;
									car.animation.addByPrefix("go", "car", 24, false);
									car.visible = true;
									car.animation.play("go");
									if(SONG.song.toLowerCase() == "nazel")dust.visible = true;
							}
			
						case 'beathoven':
							{
									defaultCamZoom = 0.9;
									curStage = 'beathoven';

									var bgPic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stageback.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stageback.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
									}
		
									var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
									bg.antialiasing = true;
									bg.scrollFactor.set(0.9, 0.9);
									bg.active = false;
									add(bg);
				

									var frontPic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stagefront.png")) {
										frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stagefront.png");
									} else {
										// fall back on base game file to avoid crashes
										frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
									}
		
									var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(frontPic);
									stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
									stageFront.updateHitbox();
									stageFront.antialiasing = true;
									stageFront.scrollFactor.set(0.9, 0.9);
									stageFront.active = false;
									add(stageFront);
													
									phillyCityLights = new FlxTypedGroup<FlxSprite>();
									add(phillyCityLights);
				
									for (i in 0...4)
									{

										var lightPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png")) {
											lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png");
										} else {
											// fall back on base game file to avoid crashes
											lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
										}
		
											var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(lightPic);
											light.scrollFactor.set(0.9, 0.9);
											light.visible = false;
											light.updateHitbox();
											light.antialiasing = true;
											phillyCityLights.add(light);
									
									}
									// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
				

									var crowdPic:BitmapData;
									var crowdXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/littleguys.png")) {
									   crowdPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/littleguys.png");
									} else {
									   // fall back on base game file to avoid crashes
										 crowdPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bottomBop.png"));
									}
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/littleguys.xml")) {
									   crowdXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/littleguys.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 crowdXml = Assets.getText("assets/images/christmas/bottomBop.xml");
									}
			
									littleGuys = new FlxSprite(25, 200);
											 littleGuys.frames = FlxAtlasFrames.fromSparrow(crowdPic, crowdXml);
											  littleGuys.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
											  littleGuys.antialiasing = true;
												 littleGuys.scrollFactor.set(0.9, 0.9);
									 littleGuys.setGraphicSize(Std.int(littleGuys.width * 1));
											 littleGuys.updateHitbox();
												 add(littleGuys);
				
							}
							case 'nyaw':
								{					
										defaultCamZoom = 0.9;
										curStage = 'nyaw';

										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/closed.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/closed.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
	
										var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
										bg.antialiasing = true;
										bg.scrollFactor.set(0.9, 0.9);
										bg.active = false;
										add(bg);
										
										var crowdPic:BitmapData;
										var crowdXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.png")) {
										   crowdPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.png");
										} else {
										   // fall back on base game file to avoid crashes
											 crowdPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bottomBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.xml")) {
										   crowdXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 crowdXml = Assets.getText("assets/images/christmas/bottomBop.xml");
										}

										bottomBoppers = new FlxSprite(-600, -200);
												 bottomBoppers.frames = FlxAtlasFrames.fromSparrow(crowdPic, crowdXml);
												  bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
												  bottomBoppers.antialiasing = true;
													  bottomBoppers.scrollFactor.set(0.92, 0.92);
											 bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
												  bottomBoppers.updateHitbox();
													  add(bottomBoppers);

										var frontPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stagefront.png")) {
										  frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stagefront.png");
										} else {
										  // fall back on base game file to avoid crashes
										frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
										}
				  
										var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(frontPic);
										stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
										stageFront.updateHitbox();
										stageFront.antialiasing = true;
										stageFront.scrollFactor.set(0.9, 0.9);
										stageFront.active = false;
										add(stageFront);
					
										phillyCityLights = new FlxTypedGroup<FlxSprite>();
										add(phillyCityLights);
					
										for (i in 0...4)
										{

											var lightPic:BitmapData;
											if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png")) {
												lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png");
											} else {
												// fall back on base game file to avoid crashes
												lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
											}
	
												var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(lightPic);
												light.scrollFactor.set(0.9, 0.9);
												light.visible = false;
												light.updateHitbox();
												light.antialiasing = true;
												phillyCityLights.add(light);
										
										}
										// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
					
										var standsPic:BitmapData;
										var standsXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/upperBop.png")) {
										   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/upperBop.png");
										} else {
										   // fall back on base game file to avoid crashes
											 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/upperBop.xml")) {
										   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/upperBop.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
										}
	
									upperBoppers = new FlxSprite(-600, -200);
											  upperBoppers.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
											  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
											  upperBoppers.antialiasing = true;
											  upperBoppers.scrollFactor.set(1.05, 1.05);
											  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1));
											  upperBoppers.updateHitbox();
											  add(upperBoppers);
									 
									
								}					
							case 'hairball':
								{
					
									defaultCamZoom = 0.9;
									curStage = 'hairball';

									var bgPic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sunset.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sunset.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
									}

									var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
									bg.antialiasing = true;
									bg.scrollFactor.set(0.9, 0.9);
									bg.active = false;
									add(bg);
					
									var frontPic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stagefront.png")) {
										frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stagefront.png");
									} else {
										// fall back on base game file to avoid crashes
										frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
									}

									var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(frontPic);
									stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
									stageFront.updateHitbox();
									stageFront.antialiasing = true;
									stageFront.scrollFactor.set(0.9, 0.9);
									stageFront.active = false;
									add(stageFront);
					
									phillyCityLights = new FlxTypedGroup<FlxSprite>();
									add(phillyCityLights);
					
									for (i in 0...4)
									{

										var lightPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png")) {
											lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png");
										} else {
											// fall back on base game file to avoid crashes
											lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
										}

											var light:FlxSprite = new FlxSprite(-600, -200).loadGraphic(lightPic);
											light.scrollFactor.set(0.9, 0.9);
											light.visible = false;
											light.updateHitbox();
											light.antialiasing = true;
											phillyCityLights.add(light);
									
									}
									// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);
					
									var standsPic:BitmapData;
									var standsXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/upperBop.png")) {
									   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/upperBop.png");
									} else {
									   // fall back on base game file to avoid crashes
										 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
									}
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/upperBop.xml")) {
									   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/upperBop.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
									}
			
									upperBoppers = new FlxSprite(-600, -200);
									upperBoppers.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
										  upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
										  upperBoppers.antialiasing = true;
										  upperBoppers.scrollFactor.set(1.05, 1.05);
										  upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1));
										  upperBoppers.updateHitbox();
										  add(upperBoppers);
										 
										  var crowdPic:BitmapData;
										  var crowdXml:String;
										  if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/littleguys.png")) {
											 crowdPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/littleguys.png");
										  } else {
											 // fall back on base game file to avoid crashes
											   crowdPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bottomBop.png"));
										  }
										  if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/littleguys.xml")) {
											 crowdXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/littleguys.xml");
										  } else {
											 // fall back on base game file to avoid crashes
											   crowdXml = Assets.getText("assets/images/christmas/bottomBop.xml");
										  }
	  
									littleGuys = new FlxSprite(25, 200);
											 littleGuys.frames = FlxAtlasFrames.fromSparrow(crowdPic, crowdXml);
											  littleGuys.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
											  littleGuys.antialiasing = true;
												 littleGuys.scrollFactor.set(0.9, 0.9);
									 littleGuys.setGraphicSize(Std.int(littleGuys.width * 1));
											 littleGuys.updateHitbox();
												  add(littleGuys);
									
								}
					case 'bawnebyl':
						{
							defaultCamZoom = 0.55;
							curStage = 'bawnebyl';
								
							// sky bg

							var bgPic:BitmapData;
							var bgXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
							}
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.xml")) {
							   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/sky.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 bgXml = Assets.getText("assets/images/halloween_bg.xml");
							}
							var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);	

							bawnebylbg = new FlxSprite(-600, -380);
							bawnebylbg.frames = hallowTex;
							bawnebylbg.animation.addByIndices('sky1', "sky-background", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26], "", 24, false);
							bawnebylbg.animation.addByIndices('sky2', "sky-background", [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
							bawnebylbg.animation.play('sky1');
							bawnebylbg.setGraphicSize(Std.int(bawnebylbg.width * 1.25));
							bawnebylbg.updateHitbox();
							bawnebylbg.antialiasing = true;
							bawnebylbg.scrollFactor.set(0.35, 0.35);
							// bg old
							// var bg:FlxSprite = new FlxSprite(-600, -380).loadGraphic('assets/images/Kath/sky.png');
							// bg.setGraphicSize(Std.int(bg.width * 1.25));
							// bg.updateHitbox();
							// bg.antialiasing = true;
							// bg.scrollFactor.set(0.35, 0.35);
							// bg.active = false;
							// newthing

							var santaPic:BitmapData;
							var santaXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/beam-beat.png")) {
							   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/beam-beat.png");
							} else {
							   // fall back on base game file to avoid crashes
								 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/beam-beat.xml")) {
							   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/beam-beat.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 santaXml = Assets.getText("assets/images/christmas/santa.xml");
							}

							thing = new FlxSprite(200, -1100);
							thing.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
							thing.animation.addByIndices('thing1', "beam-beat", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26], "", 24, false);
							thing.animation.addByIndices('thing2', "beam-beat", [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
							thing.animation.play('thing1');
							thing.setGraphicSize(Std.int(thing.width * 1.30));
							thing.updateHitbox();
							thing.antialiasing = true;
							thing.scrollFactor.set(0.40, 0.40);
							// thing
							// var thing:FlxSprite = new FlxSprite(-650, -360).loadGraphic('assets/images/Kath/thing.png');
							// thing.setGraphicSize(Std.int(thing.width * 1.30));
							// thing.updateHitbox();
							// thing.antialiasing = true;
							// thing.scrollFactor.set(0.40, 0.40);
							// thing.active = false;
							// buildings

							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/buildings.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/buildings.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}

							var buildings:FlxSprite = new FlxSprite(-610, -250).loadGraphic(bgPic);
							buildings.setGraphicSize(Std.int(buildings.width * 1.27));
							buildings.updateHitbox();
							buildings.antialiasing = true;
							buildings.scrollFactor.set(0.55, 0.55);
							buildings.active = false;
							// foreground

							var bg2Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/foreground.png")) {
								bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/foreground.png");
							} else {
								// fall back on base game file to avoid crashes
								bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}

							var foreground:FlxSprite = new FlxSprite(-680, -480).loadGraphic(bg2Pic);
							foreground.setGraphicSize(Std.int(foreground.width * 1.34));
							foreground.updateHitbox();
							foreground.antialiasing = true;
							foreground.scrollFactor.set(0.96, 0.96);
							foreground.active = false;
							// flamebeat

							var standsPic:BitmapData;
							var standsXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/flamebeat.png")) {
							   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/flamebeat.png");
							} else {
							   // fall back on base game file to avoid crashes
								 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/flamebeat.xml")) {
							   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/flamebeat.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
							}
	
							flamebeat = new FlxSprite(-50, 390);
							flamebeat.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
							flamebeat.animation.addByIndices('flamebeat1', "flamebeat", [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26], "", 24, false);
							flamebeat.animation.addByIndices('flamebeat2', "flamebeat", [27, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
							flamebeat.animation.play('flamebeat1');
							flamebeat.setGraphicSize(Std.int(flamebeat.width * 0.7));
							flamebeat.updateHitbox();
							flamebeat.antialiasing = true;
							flamebeat.scrollFactor.set(0, 0);
							add(bawnebylbg);
							add(thing);
							add(buildings);
							add(foreground);
							if (SONG.song.toLowerCase() == 'resistance')
							{
								add(flamebeat);
							}
						}	
				case 'restaurante':
					{
						defaultCamZoom = 0.60;
						curStage = 'restaurante';

						var floorPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bedrock.png")) {
							floorPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bedrock.png");
						} else {
							// fall back on base game file to avoid crashes
							floorPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
						
						var tablePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sit.png")) {
							tablePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sit.png");
						} else {
							// fall back on base game file to avoid crashes
							tablePic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var table2Pic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/UHM.png")) {
							table2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/UHM.png");
						} else {
							// fall back on base game file to avoid crashes
							table2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var standsPic:BitmapData;
						var standsXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/doot.png")) {
						   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/doot.png");
						} else {
						   // fall back on base game file to avoid crashes
							 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/doot.xml")) {
						   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/doot.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
						}

						var bgPic:BitmapData;
						var bgXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/SUSSY_IMPOSER.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/SUSSY_IMPOSER.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/SUSSY_IMPOSER.xml")) {
							bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/SUSSY_IMPOSER.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 bgXml = Assets.getText("assets/images/halloween_bg.xml");
						}
						var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

						var stands2Pic:BitmapData;
						var stands2Xml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spectator_mode.png")) {
						   stands2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/spectator_mode.png");
						} else {
						   // fall back on base game file to avoid crashes
							 stands2Pic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spectator_mode.xml")) {
						   stands2Xml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/spectator_mode.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 stands2Xml = Assets.getText("assets/images/christmas/upperBop.xml");
						}

						
						var floor:FlxSprite = new FlxSprite(-1262.95, -138.7).loadGraphic(floorPic);
						floor.antialiasing = true;
						floor.scrollFactor.set(0.9, 0.9);
						floor.active = false;
						add(floor);
			
						doot = new FlxSprite(1276.65, 154.1);
						doot.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
						doot.animation.addByPrefix('idle', 'doot', 24, false);
						doot.antialiasing = true;
						add(doot);
			
						var tableA:FlxSprite = new FlxSprite(1918.1, 282.15).loadGraphic(tablePic);
						tableA.antialiasing = true;
						tableA.scrollFactor.set(0.9, 0.9);
						tableA.active = false;
						add(tableA);
				
						var tableB:FlxSprite = new FlxSprite(1664.95, 581.65).loadGraphic(table2Pic);
						tableB.antialiasing = true;
						tableB.scrollFactor.set(0.9, 0.9);
						tableB.active = false;
						add(tableB);
				
						var REEboy:FlxSprite = new FlxSprite( -358.25, -142.2);
						REEboy.frames = hallowTex;
						REEboy.animation.addByPrefix('blink', 'wall', 24, true);
						REEboy.animation.play('blink');
						add(REEboy);
			
						crowd = new FlxSprite(256.6, 1069.85);
						crowd.frames = FlxAtlasFrames.fromSparrow(stands2Pic, stands2Xml);
						crowd.animation.addByPrefix('idle', 'spectator mode', 24, false);
						crowd.antialiasing = true;
						add(crowd);
			
					}
			
				case 'ego':
					{
						defaultCamZoom = 0.66;
						curStage = 'ego';
						
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/back.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/back.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg2Pic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/front.png")) {
							bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/front.png");
						} else {
							// fall back on base game file to avoid crashes
							bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}



						var bg:FlxSprite = new FlxSprite(-410, 0).loadGraphic(bgPic);
						var bg2:FlxSprite = new FlxSprite(-410, 0).loadGraphic(bg2Pic);
		
						phillyCityLights = new FlxTypedGroup<FlxSprite>();
						add(phillyCityLights);
						for (i in 1...4)
						{
							var lightPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/windows"+i+".png")) {
								lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/windows"+i+".png");
							} else {
								// fall back on base game file to avoid crashes
								lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
							}
	
								var light:FlxSprite = new FlxSprite(-410).loadGraphic(lightPic);
								if (i != 1)
								light.visible = false;
								light.updateHitbox();
								light.antialiasing = true;
								phillyCityLights.add(light);
						}
						
						bg.antialiasing = true;
						bg2.antialiasing = true;
						add(bg);
						add(bg2);
					}
					case 'limbo': 
						{
						defaultCamZoom = 1.11;
						curStage = 'limbo';
	
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(bgPic);
						bg.scrollFactor.set(0.1, 0.1);
						add(bg);
	
						var rockPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rockBG.png")) {
							rockPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rockBG.png");
						} else {
							// fall back on base game file to avoid crashes
							rockPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var city:FlxSprite = new FlxSprite(-10).loadGraphic(rockPic);
						city.scrollFactor.set(0.3, 0);
						city.setGraphicSize(Std.int(city.width * 0.85));
						city.updateHitbox();
						add(city);
	
						var behindPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rockBETWEEN.png")) {
							behindPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rockBETWEEN.png");
						} else {
							// fall back on base game file to avoid crashes
							behindPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(behindPic);
						add(streetBehind);
	
						var streetPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rockPLAYER.png")) {
							streetPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rockPLAYER.png");
						} else {
							// fall back on base game file to avoid crashes
							streetPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var street:FlxSprite = new FlxSprite(-230, streetBehind.y).loadGraphic(streetPic);
						add(street);
				}
				case 'mortemhell': 
					{
					defaultCamZoom = 1.11;
					curStage = 'mortemhell';

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hellsky.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/hellsky.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hellsky.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/hellsky.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var bg:FlxSprite = new FlxSprite(-100);
					bg.frames = hallowTex;
					bg.animation.addByPrefix("bgAnim", "hell", 8, true);
					bg.animation.play("bgAnim", true, false, -1);
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var rockPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rockBG.png")) {
						rockPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rockBG.png");
					} else {
						// fall back on base game file to avoid crashes
						rockPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(rockPic);
					city.scrollFactor.set(0.3, 0);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					var behindPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rockBETWEEN.png")) {
						behindPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rockBETWEEN.png");
					} else {
						// fall back on base game file to avoid crashes
						behindPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(behindPic);
					add(streetBehind);

					var streetPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rockPLAYER.png")) {
						streetPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rockPLAYER.png");
					} else {
						// fall back on base game file to avoid crashes
						streetPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var street:FlxSprite = new FlxSprite(-230, streetBehind.y).loadGraphic(streetPic);
					add(street);
					
			}
			case 'sweetstage':
			{
				curStage = 'sweetstage';

				defaultCamZoom = 0.90;

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompombg.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompombg.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sweetstagebg:FlxSprite = new FlxSprite(-500, -300).loadGraphic(bgPic);
				sweetstagebg.antialiasing = true;
				sweetstagebg.scrollFactor.set(0.4, 0.4);
				sweetstagebg.active = false;
				sweetstagebg.updateHitbox();
				add(sweetstagebg);

				var standsPic:BitmapData;
				var standsXml:String;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomcity.png")) {
				   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompomcity.png");
				} else {
				   // fall back on base game file to avoid crashes
					 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
				}
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomcity.xml")) {
				   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/pompomcity.xml");
				} else {
				   // fall back on base game file to avoid crashes
					 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
				}

				sweetstagecity = new FlxSprite(-300, 260);
				sweetstagecity.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
				sweetstagecity.animation.addByPrefix('cityflash', 'pompom city', 24, false);
				sweetstagecity.antialiasing = true;
				sweetstagecity.scrollFactor.set(0.6, 0.6);
				add(sweetstagecity);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompombgtrees1.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompombgtrees1.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sweetstagebgtrees1:FlxSprite = new FlxSprite(-600, 300).loadGraphic(bgPic);
				sweetstagebgtrees1.antialiasing = true;
				sweetstagebgtrees1.scrollFactor.set(0.82, 0.82);
				sweetstagebgtrees1.active = false;
				add(sweetstagebgtrees1);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomtreemid.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompomtreemid.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sweetstagetreemid:FlxSprite = new FlxSprite(550, 150).loadGraphic(bgPic);
				sweetstagetreemid.antialiasing = true;
				sweetstagetreemid.active = false;
				add(sweetstagetreemid);

				var bgPic:BitmapData;
				var bgXml:String;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomhouse.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompomhouse.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
				}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomhouse.xml")) {
				   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/pompomhouse.xml");
				} else {
				   // fall back on base game file to avoid crashes
					 bgXml = Assets.getText("assets/images/halloween_bg.xml");
				}

				sweetstagehouse = new FlxSprite(-160, 30);
				sweetstagehouse.frames = FlxAtlasFrames.fromSparrow(bgPic, bgXml);
				sweetstagehouse.animation.addByPrefix('smoke', 'pompom house', 24, false);
				sweetstagehouse.scrollFactor.set(0.92, 0.92);
				sweetstagehouse.antialiasing = true;
				add(sweetstagehouse);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomfg.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompomfg.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sweetstagefg:FlxSprite = new FlxSprite(-500, 0).loadGraphic(bgPic);
				sweetstagefg.antialiasing = true;
				sweetstagefg.active = false;
				add(sweetstagefg);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomfgtree2.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompomfgtree2.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sweetstagefgtree2:FlxSprite = new FlxSprite(1300, -10).loadGraphic(bgPic);
				sweetstagefgtree2.antialiasing = true;
				sweetstagefgtree2.scrollFactor.set(1, 1);
				sweetstagefgtree2.active = false;
				add(sweetstagefgtree2);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pompomtreefg.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pompomtreefg.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sweetstagetreefg:FlxSprite = new FlxSprite(500, -200).loadGraphic(bgPic);
				sweetstagetreefg.antialiasing = true;
				sweetstagetreefg.active = false;
				add(sweetstagetreefg);

				var santaPic:BitmapData;
				var santaXml:String;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mackiebob.png")) {
				   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/mackiebob.png");
				} else {
				   // fall back on base game file to avoid crashes
					 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
				}
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mackiebob.xml")) {
				   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/mackiebob.xml");
				} else {
				   // fall back on base game file to avoid crashes
					 santaXml = Assets.getText("assets/images/christmas/santa.xml");
				}

				sweetstagemackie = new FlxSprite(1350, 600);
				sweetstagemackie.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
				sweetstagemackie.animation.addByPrefix('mackbob', 'mackie', 24, false);
				sweetstagemackie.antialiasing = true;
				add(sweetstagemackie);
				}
				case 'biscuit':
					{
						curStage = 'biscuit';
		
						defaultCamZoom = 0.60;
		
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/citybg.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/citybg.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
		
						var mackiebg:FlxSprite = new FlxSprite(-2150, -1000).loadGraphic(bgPic);
						mackiebg.antialiasing = true;
						mackiebg.active = false;
						mackiebg.updateHitbox();
						mackiebg.scrollFactor.set(0.1, 0.1);
						mackiebg.scale.set(0.8, 0.8);
						add(mackiebg);
		
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/citymid.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/citymid.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
		
						var mackiemid:FlxSprite = new FlxSprite(-600, -40).loadGraphic(bgPic);
						mackiemid.antialiasing = true;
						mackiemid.active = false;
						mackiemid.updateHitbox();
						mackiemid.scrollFactor.set(0.8, 0.8);
						add(mackiemid);
		
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/interior.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/interior.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
		
						var mackieinterior:FlxSprite = new FlxSprite(-1300, -400).loadGraphic(bgPic);
						mackieinterior.antialiasing = true;
						mackieinterior.active = false;
						mackieinterior.updateHitbox();
						mackieinterior.scrollFactor.set(0.95, 0.95);
						add(mackieinterior);
		
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mackiecity.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/mackiecity.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
		
						var mackiecity:FlxSprite = new FlxSprite(-2470, -1140).loadGraphic(bgPic);
						mackiecity.antialiasing = true;
						mackiecity.active = false;
						mackiecity.updateHitbox();
						add(mackiecity);
		
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sewer.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sewer.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
		
						var sewer:FlxSprite = new FlxSprite(1400, 722).loadGraphic(bgPic);
						sewer.antialiasing = true;
						sewer.active = false;
						sewer.updateHitbox();
						add(sewer);
						}
						case 'gateau':
							{
								curStage = 'gateau';
				
								defaultCamZoom = 0.60;
				
								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/citybg.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/citybg.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
		
								var mackiebg:FlxSprite = new FlxSprite(-2150, -1000).loadGraphic(bgPic);
								mackiebg.antialiasing = true;
								mackiebg.active = false;
								mackiebg.updateHitbox();
								mackiebg.scrollFactor.set(0.1, 0.1);
								mackiebg.scale.set(0.8, 0.8);
								add(mackiebg);
				
								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/citymid.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/citymid.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
		
								var mackiemid:FlxSprite = new FlxSprite(-600, -40).loadGraphic(bgPic);
								mackiemid.antialiasing = true;
								mackiemid.active = false;
								mackiemid.updateHitbox();
								mackiemid.scrollFactor.set(0.8, 0.8);
								add(mackiemid);
				
								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/interior.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/interior.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
		
								var mackieinterior:FlxSprite = new FlxSprite(-1300, -400).loadGraphic(bgPic);
								mackieinterior.antialiasing = true;
								mackieinterior.active = false;
								mackieinterior.updateHitbox();
								mackieinterior.scrollFactor.set(0.95, 0.95);
								add(mackieinterior);
				
								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mackiecity.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/mackiecity.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
		
								var mackiecity:FlxSprite = new FlxSprite(-2470, -1140).loadGraphic(bgPic);
								mackiecity.antialiasing = true;
								mackiecity.active = false;
								mackiecity.updateHitbox();
								add(mackiecity);
				
								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sewer.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sewer.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
		
								var sewer:FlxSprite = new FlxSprite(1400, 722).loadGraphic(bgPic);
								sewer.antialiasing = true;
								sewer.active = false;
								sewer.updateHitbox();
								add(sewer);
				
								var standsPic:BitmapData;
								var standsXml:String;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/smallcrowdbob.png")) {
								   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/smallcrowdbob.png");
								} else {
								   // fall back on base game file to avoid crashes
									 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
								}
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/smallcrowdbob.xml")) {
								   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/smallcrowdbob.xml");
								} else {
								   // fall back on base game file to avoid crashes
									 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
								}
		
								smallbgcrowd = new FlxSprite(-1050, 580);
								smallbgcrowd.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
								smallbgcrowd.animation.addByPrefix('smallbob', 'small crowd bob', 24, false);
								smallbgcrowd.antialiasing = true;
								add(smallbgcrowd);
								}
								case 'pom-pomeranian':
									{
										curStage = 'pom-pomeranian';
						
										defaultCamZoom = 0.60;
						
										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/citybgtwo.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/citybgtwo.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
		
										var mackiebg:FlxSprite = new FlxSprite(-2150, -1000).loadGraphic(bgPic);
										mackiebg.antialiasing = true;
										mackiebg.active = false;
										mackiebg.updateHitbox();
										mackiebg.scrollFactor.set(0.1, 0.1);
										mackiebg.scale.set(0.8, 0.8);
										add(mackiebg);
						
										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/citymid.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/citymid.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
		
										var mackiemid:FlxSprite = new FlxSprite(-600, -40).loadGraphic(bgPic);
										mackiemid.antialiasing = true;
										mackiemid.active = false;
										mackiemid.updateHitbox();
										mackiemid.scrollFactor.set(0.8, 0.8);
										add(mackiemid);
						
										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/interior.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"interior.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
		
										var mackieinterior:FlxSprite = new FlxSprite(-1300, -400).loadGraphic(bgPic);
										mackieinterior.antialiasing = true;
										mackieinterior.active = false;
										mackieinterior.updateHitbox();
										mackieinterior.scrollFactor.set(0.95, 0.95);
										add(mackieinterior);
						
										var santaPic:BitmapData;
										var santaXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/alyabob.png")) {
										   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/alyabob.png");
										} else {
										   // fall back on base game file to avoid crashes
											 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/alyabob.xml")) {
										   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/alyabob.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 santaXml = Assets.getText("assets/images/christmas/santa.xml");
										}
				
										alya = new FlxSprite(-900, 150);
										alya.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
										alya.animation.addByPrefix('alyabob', 'alya bob', 24, false);
										alya.antialiasing = true;
										alya.scrollFactor.set(0.95, 0.95);
										add(alya);
						
										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mackiecity.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/mackiecity.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
		
										var mackiecity:FlxSprite = new FlxSprite(-2470, -1140).loadGraphic(bgPic);
										mackiecity.antialiasing = true;
										mackiecity.active = false;
										mackiecity.updateHitbox();
										add(mackiecity);
						
										var santaPic:BitmapData;
										var santaXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sewertricky.png")) {
										   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sewertricky.png");
										} else {
										   // fall back on base game file to avoid crashes
											 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sewertricky.xml")) {
										   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/sewertricky.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 santaXml = Assets.getText("assets/images/christmas/santa.xml");
										}
				
										tricky = new FlxSprite(1400, 722);
										tricky.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
										tricky.animation.addByPrefix('trickybob', 'sewertricky', 24, false);
										tricky.antialiasing = true;
										add(tricky);
						
										var standsPic:BitmapData;
										var standsXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowdbob.png")) {
										   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/crowdbob.png");
										} else {
										   // fall back on base game file to avoid crashes
											 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowdbob.xml")) {
										   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/crowdbob.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
										}
		
										bgcrowd = new FlxSprite(-1020, 460);
										bgcrowd.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
										bgcrowd.animation.addByPrefix('bob', 'crowd bob', 24, false);
										bgcrowd.antialiasing = true;
										add(bgcrowd);
						
										var standsPic:BitmapData;
										var standsXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowdjump.png")) {
										   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/crowdjump.png");
										} else {
										   // fall back on base game file to avoid crashes
											 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/crowdjump.xml")) {
										   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/crowdjump.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
										}
		
										bgcrowdjump = new FlxSprite(-1020, 460);
										bgcrowdjump.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
										bgcrowdjump.animation.addByPrefix('jump', 'crowd jump', 24, false);
										bgcrowdjump.antialiasing = true;
						
										var santaPic:BitmapData;
										var santaXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/anchor.png")) {
										   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/anchor.png");
										} else {
										   // fall back on base game file to avoid crashes
											 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/anchor.xml")) {
										   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/anchor.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 santaXml = Assets.getText("assets/images/christmas/santa.xml");
										}
				
										anchor = new FlxSprite(-720, 22);
										anchor.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
										anchor.animation.addByPrefix('anchorbob', 'anchorbob', 24, false);
										anchor.antialiasing = true;
										add(anchor);
										}
						
					case 'ridzak':
						{
							defaultCamZoom = 0.66;
							curStage = 'ridzak';

							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/back.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/back.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}

							var bg2Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/front.png")) {
								bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/front.png");
							} else {
								// fall back on base game file to avoid crashes
								bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg:FlxSprite = new FlxSprite(-410, 0).loadGraphic(bgPic);
							var bg2:FlxSprite = new FlxSprite(-410, 0).loadGraphic(bg2Pic);
			
							phillyCityLights = new FlxTypedGroup<FlxSprite>();
							add(phillyCityLights);
							for (i in 1...4)
							{
								var lightPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/veryBack"+i+".png")) {
									lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/veryBack"+i+".png");
								} else {
									// fall back on base game file to avoid crashes
									lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
								}
	
									var light:FlxSprite = new FlxSprite(-410).loadGraphic(lightPic);
									if (i != 1)
										light.visible = false;
									light.updateHitbox();
									light.antialiasing = true;
									phillyCityLights.add(light);
							}
							bg.antialiasing = true;
							bg2.antialiasing = true;
							add(bg);
							add(bg2);
						}

						case 'vibe':
							{
								curStage = 'vibe';

								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/back back.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/back back.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}

								var bg2Pic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/back.png")) {
									bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/back.png");
								} else {
									// fall back on base game file to avoid crashes
									bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}

								var bg4Pic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Front.png")) {
									bg4Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/Front.png");
								} else {
									// fall back on base game file to avoid crashes
									bg4Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
	
								var bg:FlxSprite = new FlxSprite(-140, 0).loadGraphic(bgPic);
								var bg2:FlxSprite = new FlxSprite(-140, 0).loadGraphic(bg2Pic);
								var bg4:FlxSprite = new FlxSprite(-140, 0).loadGraphic(bg4Pic);
								bg.antialiasing = true;
								bg2.antialiasing = true;
								bg4.antialiasing = true;
								bg.scrollFactor.set(0.5, 0.5);
								bg2.scrollFactor.set(0.8, 0.8);
								add(bg);
								add(bg2);
								add(bg4);
							}
							case 'island':
								{
										defaultCamZoom = 0.78;
										curStage = 'island';
			
										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
		
										var bgsky:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
										bgsky.antialiasing = true;
										bgsky.scrollFactor.set(0.9, 0.9);
										bgsky.active = false;
										add(bgsky);
					
										var bg2Pic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/back.png")) {
											bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/back.png");
										} else {
											// fall back on base game file to avoid crashes
											bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
		
										var backPillers:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bg2Pic);
										backPillers.antialiasing = true;
										backPillers.scrollFactor.set(0.9, 0.9);
										backPillers.active = false;
										add(backPillers);
			
										var boshiPic:BitmapData;
										var boshiXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boshi.png")) {
										   boshiPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boshi.png");
										} else {
										   // fall back on base game file to avoid crashes
											 boshiPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boshi.xml")) {
										   boshiXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boshi.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 boshiXml = Assets.getText("assets/images/christmas/upperBop.xml");
										}
				
										boshi = new FlxSprite(862, 194);
										boshi.frames = FlxAtlasFrames.fromSparrow(boshiPic, boshiXml);
										boshi.antialiasing = true;
									//	boshi.screenCenter();
									//	boshi.scale.set(0.8, 0.8);
										boshi.animation.addByPrefix("peak", "boshi", 24);
									//	boshi.updateHitbox();
										boshi.animation.play("peak", true);
										add(boshi);
			
										var middlePic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/middle.png")) {
											middlePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/middle.png");
										} else {
											// fall back on base game file to avoid crashes
											middlePic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}

										var middleStage:FlxSprite = new FlxSprite(-650, -50).loadGraphic(middlePic);
										middleStage.setGraphicSize(Std.int(middleStage.width * 1.1));
										middleStage.updateHitbox();
										middleStage.antialiasing = true;
										middleStage.scrollFactor.set(0.9, 0.9);
										middleStage.active = false;
										add(middleStage);
					
										var bushesPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/front_bushes.png")) {
											bushesPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/front_bushes.png");
										} else {
											// fall back on base game file to avoid crashes
											bushesPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}

										var frontBushes:FlxSprite = new FlxSprite(-400, 800).loadGraphic(bushesPic);
										frontBushes.setGraphicSize(Std.int(frontBushes.width * 1.2));
										frontBushes.updateHitbox();
										frontBushes.antialiasing = true;
										frontBushes.scrollFactor.set(1.3, 1.3);
										frontBushes.active = false;
					
										add(frontBushes);
								}
				
							case 'cyb':
								{
									defaultCamZoom = 0.8;
									curStage = 'cyb';

									var bgPic:BitmapData;
									var bgXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stage.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stage.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stage.xml")) {
									    bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/stage.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 bgXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

				
						
									bgv2 = new FlxSprite( -512.45, -575.7);
									bgv2.frames = hallowTex;
									bgv2.animation.addByPrefix('idle', 'stage', 24, true);
									bgv2.animation.play('idle', true);
									bgv2.scrollFactor.set(0.8, 0.8);
									bgv2.antialiasing = true;
									add(bgv2);
					
									var bg2Pic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/danceOff.png")) {
										bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/danceOff.png");
									} else {
										// fall back on base game file to avoid crashes
										bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
									}
	
									var bgv3:FlxSprite = new FlxSprite(-449, -476).loadGraphic(bg2Pic);
									bgv3.antialiasing = true;
									bgv3.active = false;
									add(bgv3);
					
									phillyCityLights = new FlxTypedGroup<FlxSprite>();
									add(phillyCityLights);
									for (i in 1...4)
									{
										var lightPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/dance"+i+".png")) {
											lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/dance"+i+".png");
										} else {
											// fall back on base game file to avoid crashes
											lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
										}
		
											var light:FlxSprite = new FlxSprite(-449, -476).loadGraphic(lightPic);
											light.visible = false;
											light.updateHitbox();
											light.antialiasing = true;
											phillyCityLights.add(light);
									}
									
								}
					
					case 'kou':
						defaultCamZoom = 0.85;
						// pretend it's stage, it doesn't check for correct images
						curStage = 'kou';
						// peck it no one is gonna build this for html5 so who cares if it doesn't compile
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/koustage.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/koustage.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}
	
						var bg:FlxSprite = new FlxSprite(-360, -180).loadGraphic(bgPic);
						// bg.setGraphicSize(Std.int(bg.width * 2.5));
						// bg.updateHitbox();
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);

				case 'day':
				{
						defaultCamZoom = 0.75;
						curStage = 'day';

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG1.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG1.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(bgPic);
						bg1.antialiasing = true;
						bg1.scale.set(0.8, 0.8);
						bg1.scrollFactor.set(0.3, 0.3);
						bg1.active = false;
						add(bg1);

						var bg2Pic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG2.png")) {
							bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG2.png");
						} else {
							// fall back on base game file to avoid crashes
							bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(bg2Pic);
						bg2.antialiasing = true;
						bg2.scale.set(0.5, 0.5);
						bg2.scrollFactor.set(0.6, 0.6);
						bg2.active = false;
						add(bg2);

						var santaPic:BitmapData;
						var santaXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mini.png")) {
						   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/mini.png");
						} else {
						   // fall back on base game file to avoid crashes
							 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/mini.xml")) {
						   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/mini.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 santaXml = Assets.getText("assets/images/christmas/santa.xml");
						}

						mini = new FlxSprite(849, 189);
						mini.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
						mini.animation.addByPrefix('idle', 'mini', 24, true);
						mini.animation.play('idle');
						mini.scale.set(0.4, 0.4);
						mini.scrollFactor.set(0.6, 0.6);
						add(mini);

						var mordecaiPic:BitmapData;
						var mordecaiXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bluskystv.png")) {
						   mordecaiPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bluskystv.png");
						} else {
						   // fall back on base game file to avoid crashes
							 mordecaiPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bluskystv.xml")) {
						   mordecaiXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bluskystv.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 mordecaiXml = Assets.getText("assets/images/christmas/santa.xml");
						}

						mordecai = new FlxSprite(130, 160);
						mordecai.frames = FlxAtlasFrames.fromSparrow(mordecaiPic, mordecaiXml);
						mordecai.animation.addByIndices('walk1', 'bluskystv', [29, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13] , '', 24, false);
						mordecai.animation.addByIndices('walk2', 'bluskystv', [14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28] , '', 24, false);
						mordecai.animation.play('walk1');
						mordecai.scale.set(0.4, 0.4);
						mordecai.scrollFactor.set(0.6, 0.6);
						add(mordecai);

						var bg3Pic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG3.png")) {
							bg3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG3.png");
						} else {
							// fall back on base game file to avoid crashes
							bg3Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(bg3Pic);
						bg3.antialiasing = true;
						bg3.scale.set(0.8, 0.8);
						bg3.active = false;
						add(bg3);

						
						
				}
				case 'sunset':
					{
						defaultCamZoom = 0.75;
						curStage = 'sunset';
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG1.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG1.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(bgPic);
						bg1.antialiasing = true;
						bg1.scale.set(0.8, 0.8);
						bg1.scrollFactor.set(0.3, 0.3);
						bg1.active = false;
						add(bg1);
	
						var bg2Pic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG2.png")) {
							bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG2.png");
						} else {
							// fall back on base game file to avoid crashes
							bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg2:FlxSprite = new FlxSprite(-1240, -680).loadGraphic(bg2Pic);
						bg2.antialiasing = true;
						bg2.scale.set(0.5, 0.5);
						bg2.scrollFactor.set(0.6, 0.6);
						bg2.active = false;
						add(bg2);
	
						var santaPic:BitmapData;
						var santaXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/femboy and edgy jigglypuff.png")) {
						   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/femboy and edgy jigglypuff.png");
						} else {
						   // fall back on base game file to avoid crashes
							 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/femboy and edgy jigglypuff.xml")) {
						   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/femboy and edgy jigglypuff.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 santaXml = Assets.getText("assets/images/christmas/santa.xml");
						}

						mini = new FlxSprite(817, 190);
						mini.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
						mini.animation.addByPrefix('idle', 'femboy', 24, true);
						mini.animation.play('idle');
						mini.scale.set(0.5, 0.5);
						mini.scrollFactor.set(0.6, 0.6);
						add(mini);
	
						var mordecaiPic:BitmapData;
						var mordecaiXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/jacob.png")) {
						   mordecaiPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/jacob.png");
						} else {
						   // fall back on base game file to avoid crashes
							 mordecaiPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/jacob.xml")) {
						   mordecaiXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/jacob.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 mordecaiXml = Assets.getText("assets/images/christmas/santa.xml");
						}

						mordecai = new FlxSprite(141, 103);
						mordecai.frames = FlxAtlasFrames.fromSparrow(mordecaiPic, mordecaiXml);
						mordecai.animation.addByPrefix('idle', 'jacob', 24, true);
						mordecai.animation.play('idle');
						mordecai.scale.set(0.5, 0.5);
						mordecai.scrollFactor.set(0.6, 0.6);
						add(mordecai);
	
						var bg3Pic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG3.png")) {
							bg3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG3.png");
						} else {
							// fall back on base game file to avoid crashes
							bg3Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(bg3Pic);
						bg3.antialiasing = true;
						bg3.scale.set(0.8, 0.8);
						bg3.active = false;
						add(bg3);
							
					}
					case 'violastroStage':
						{
							defaultCamZoom = 0.45;
							curStage = 'violastroStage';
			
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgWall.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bgWall.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(bgPic);
							bg.antialiasing = true;
							bg.scrollFactor.set(0.2, 0.2);
							bg.active = false;
							add(bg);
			
							var standsPic:BitmapData;
							var standsXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/violastroSpeakers.png")) {
							   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/violastroSpeakers.png");
							} else {
							   // fall back on base game file to avoid crashes
								 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/violastroSpeakers.xml")) {
							   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/violastroSpeakers.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
							}
	
							speakers = new FlxSprite(-1000, -500);
							speakers.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
							speakers.animation.addByPrefix('bounce', 'speakersBounce', 24, false);
							speakers.antialiasing = true;
							speakers.scrollFactor.set(0.25, 0.25);
							add(speakers);
			
							var standsPic:BitmapData;
							var standsXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stageCrowd.png")) {
							   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/stageCrowd.png");
							} else {
							   // fall back on base game file to avoid crashes
								 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/stageCrowd.xml")) {
							   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/stageCrowd.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
							}
	
							crowd = new FlxSprite(-1000, -500);
							crowd.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
							crowd.animation.addByPrefix('bop', 'crowdBop', 24, false);
							crowd.antialiasing = true;
							crowd.scrollFactor.set(0.33, 0.33);
							add(crowd);
			
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/balconies.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/balconies.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var balcony:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(bgPic);
							balcony.antialiasing = true;
							balcony.scrollFactor.set(0.3, 0.3);
							balcony.active = false;
							add(balcony);
			
							var standsPic:BitmapData;
							var standsXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/violastroLights.png")) {
							   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/violastroLights.png");
							} else {
							   // fall back on base game file to avoid crashes
								 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/violastroLights.xml")) {
							   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/violastroLights.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
							}
	
							lights = new FlxSprite(-1000, -500);
							lights.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
							lights.animation.addByPrefix('flash', 'lightsFlash', 24, false);
							lights.antialiasing = true;
							lights.scrollFactor.set(0.5, 0.5);
							add(lights);
			
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/violastroPodium.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/violastroPodium.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var podium:FlxSprite = new FlxSprite(-875, -500).loadGraphic(bgPic);
							bg.antialiasing = true;
							bg.scrollFactor.set(0.3, 0.3);
							bg.active = false;
							add(podium);
						}			
					case 'night':
						{
							defaultCamZoom = 0.75;
							curStage = 'night';
							theEntireFuckingStage = new FlxTypedGroup<FlxSprite>();
							add(theEntireFuckingStage);
		
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG1.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG1.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg1:FlxSprite = new FlxSprite(-970, -580).loadGraphic(bgPic);
							bg1.antialiasing = true;
							bg1.scale.set(0.8, 0.8);
							bg1.scrollFactor.set(0.3, 0.3);
							bg1.active = false;
							theEntireFuckingStage.add(bg1);
		
							var bg2Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG2.png")) {
								bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG2.png");
							} else {
								// fall back on base game file to avoid crashes
								bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg2:FlxSprite = new FlxSprite(-1240, -650).loadGraphic(bg2Pic);
							bg2.antialiasing = true;
							bg2.scale.set(0.5, 0.5);
							bg2.scrollFactor.set(0.6, 0.6);
							bg2.active = false;
							theEntireFuckingStage.add(bg2);
		
							var santaPic:BitmapData;
							var santaXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bobsip.png")) {
							   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bobsip.png");
							} else {
							   // fall back on base game file to avoid crashes
								 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
							}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bobsip.xml")) {
							   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bobsip.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 santaXml = Assets.getText("assets/images/christmas/santa.xml");
							}
	
							mini = new FlxSprite(818, 189);
							mini.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
							mini.animation.addByPrefix('idle', 'bobsip', 24, true);
							mini.animation.play('idle');
							mini.scale.set(0.5, 0.5);
							mini.scrollFactor.set(0.6, 0.6);
							add(mini);
		
							var bg3Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG3.png")) {
								bg3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG3.png");
							} else {
								// fall back on base game file to avoid crashes
								bg3Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg3:FlxSprite = new FlxSprite(-630, -330).loadGraphic(bg3Pic);
							bg3.antialiasing = true;
							bg3.scale.set(0.8, 0.8);
							bg3.active = false;
							theEntireFuckingStage.add(bg3);
		
							var bg4Pic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/BG4.png")) {
								bg4Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/BG4.png");
							} else {
								// fall back on base game file to avoid crashes
								bg4Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
							}
	
							var bg4:FlxSprite = new FlxSprite(-1390, -740).loadGraphic(bg4Pic);
							bg4.antialiasing = true;
							bg4.scale.set(0.6, 0.6);
							bg4.active = false;
							theEntireFuckingStage.add(bg4);
		
							var pixelPic:BitmapData;
							var pixelXml:String;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pixelthing.png")) {
								pixelPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/pixelthing.png");
							} else {
								// fall back on base game file to avoid crashes
								pixelPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
							}
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/pixelthing.xml")) {
							   pixelXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/pixelthing.xml");
							} else {
							   // fall back on base game file to avoid crashes
								 pixelXml = Assets.getText("assets/images/halloween_bg.xml");
							}
							var hallowTex = FlxAtlasFrames.fromSparrow(pixelPic, pixelXml);
		
							var bg5:FlxSprite = new FlxSprite(-34, 90);
							bg5.antialiasing = true;
							bg5.scale.set(1.4, 1.4);
							bg5.frames = hallowTex;
							bg5.animation.addByPrefix('idle', 'pixelthing', 24);
							bg5.animation.play('idle');
							add(bg5);
			
							
						}
				case 'swordfight':
					{
						defaultCamZoom = 0.8;
						curStage = 'swordfight';

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/arena-bg.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/arena-bg.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.setGraphicSize(Std.int(bg.width * 1));
						bg.active = false;
						add(bg);

						var standsPic:BitmapData;
						var standsXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/arena-characters.png")) {
						   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/arena-characters.png");
						} else {
						   // fall back on base game file to avoid crashes
							 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/arena-characters.xml")) {
						   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/arena-characters.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
						}

						bgBoppers = new FlxSprite(-600, 140);
						bgBoppers.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
						bgBoppers.animation.addByPrefix('bop', "bg-characters", 24, false);
						bgBoppers.antialiasing = true;
						bgBoppers.scrollFactor.set(0.99, 0.9);
						bgBoppers.setGraphicSize(Std.int(bgBoppers.width * 1));
						bgBoppers.updateHitbox();
						add(bgBoppers);

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/railing.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/railing.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
						}

						var bgRail:FlxSprite = new FlxSprite(-600, 320).loadGraphic(bgPic);
						bgRail.antialiasing = true;
						bgRail.scrollFactor.set(0.9, 0.9);
						bgRail.active = false;
						bgRail.setGraphicSize(Std.int(bgRail.width * 1));
						bgRail.updateHitbox();
						add(bgRail);
			}
			case 'boxFC':
			{
					defaultCamZoom = 0.9;
					curStage = 'boxFC';

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxwall.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

                    var boxwall:FlxSprite = new FlxSprite(-400, -200);
					boxwall.frames = hallowTex;
					boxwall.animation.addByPrefix('wallbang', "wallboom", 24);
					boxwall.animation.play('wallbang');
					boxwall.scrollFactor.set(0.9, 0.9);
					add(boxwall);
					
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var boxfloor:FlxSprite = new FlxSprite(-400, -250);
					boxfloor.frames = hallowTex;
					boxfloor.animation.addByPrefix('floorbang', "floorboom", 24);
					boxfloor.animation.play('floorbang');
					boxfloor.scrollFactor.set(0.9, 0.9);
					add(boxfloor);
					
			}
			case 'boxDM':
			{
					defaultCamZoom = 0.9;
					curStage = 'boxDM';
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxwall.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

                    var boxwall:FlxSprite = new FlxSprite(-400, -200);
					boxwall.frames = hallowTex;
					boxwall.animation.addByPrefix('wallbang', "wallboom", 24);
					boxwall.animation.play('wallbang');
					boxwall.scrollFactor.set(0.9, 0.9);
					add(boxwall);
					
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var boxfloor:FlxSprite = new FlxSprite(-400, -250);
					boxfloor.frames = hallowTex;
					boxfloor.animation.addByPrefix('floorbang', "floorboom", 24);
					boxfloor.animation.play('floorbang');
					boxfloor.scrollFactor.set(0.9, 0.9);
					add(boxfloor);
					
			}
			case 'boxWU':
			{
					defaultCamZoom = 0.9;
					curStage = 'boxWU';
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxwall.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

                    var boxwall:FlxSprite = new FlxSprite(-400, -200);
					boxwall.frames = hallowTex;
					boxwall.animation.addByPrefix('wallbang', "wallboom", 24);
					boxwall.animation.play('wallbang');
					boxwall.scrollFactor.set(0.9, 0.9);
					add(boxwall);
					
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var boxfloor:FlxSprite = new FlxSprite(-400, -250);
					boxfloor.frames = hallowTex;
					boxfloor.animation.addByPrefix('floorbang', "floorboom", 24);
					boxfloor.animation.play('floorbang');
					boxfloor.scrollFactor.set(0.9, 0.9);
					add(boxfloor);
					
			}
			case 'boxKH':
			{
					defaultCamZoom = 0.9;
					curStage = 'boxKH';
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxwall.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxwall.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

                    var boxwall:FlxSprite = new FlxSprite(-400, -200);
					boxwall.frames = hallowTex;
					boxwall.animation.addByPrefix('wallbang', "wallboom", 24);
					boxwall.animation.play('wallbang');
					boxwall.scrollFactor.set(0.9, 0.9);
					add(boxwall);
					
					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boxfloor.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml")) {
						bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/boxfloor.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var boxfloor:FlxSprite = new FlxSprite(-400, -250);
					boxfloor.frames = hallowTex;
					boxfloor.animation.addByPrefix('floorbang', "floorboom", 24);
					boxfloor.animation.play('floorbang');
					boxfloor.scrollFactor.set(0.9, 0.9);
					add(boxfloor);
			}
			case 'boxTKO':
			{
					defaultCamZoom = 0.9;
					curStage = 'boxTKO';

					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/backwhite.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/backwhite.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

                    var whitewall:FlxSprite = new FlxSprite(-400, -200).loadGraphic(bgPic);
					whitewall.antialiasing = true;
					whitewall.scrollFactor.set(0.9, 0.9);
					whitewall.active = false;
					add(whitewall);
					
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/floorblack.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/floorblack.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var floorblack:FlxSprite = new FlxSprite(-400, -250).loadGraphic(bgPic);
					floorblack.antialiasing = true;
					floorblack.scrollFactor.set(0.9, 0.9);
					floorblack.active = false;
					add(floorblack);
			}
			case 'boxKHF':
			{
                    defaultCamZoom = 0.9;
					curStage = 'boxKHF';

					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/backtroll.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/backtroll.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

                    var backtroll:FlxSprite = new FlxSprite(-400, -200).loadGraphic(bgPic);
					backtroll.antialiasing = true;
					backtroll.scrollFactor.set(0.9, 0.9);
					backtroll.active = false;
					add(backtroll);
					
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/floortroll.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/floortroll.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var floortroll:FlxSprite = new FlxSprite(-400, -250).loadGraphic(bgPic);
					floortroll.antialiasing = true;
					floortroll.scrollFactor.set(0.9, 0.9);
					floortroll.active = false;
					add(floortroll);
			}
			case 'shzone':{
				curStage = 'shzone';
				defaultCamZoom = 1;

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bg.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bg.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var bg:FlxSprite = new FlxSprite( -90, -228).loadGraphic(bgPic);
				bg.scrollFactor.set();
				bg.active = false;
				
				add(bg);
				
				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/rock.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/rock.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var rock:FlxSprite = new FlxSprite( -32.05, 24.8).loadGraphic(bgPic);
				rock.scrollFactor.set(0.6,0.6);
				rock.active = false;
				
				add(rock);
				
				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/ground.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/ground.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var ground:FlxSprite = new FlxSprite( -488.35,349.25).loadGraphic(bgPic);
				ground.scrollFactor.set(0.8,0.8);
				ground.active = false;
				
				add(ground);
				
				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/glowshit.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/glowshit.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var glowshit:FlxSprite = new FlxSprite(-105.95,-252).loadGraphic(bgPic);
				glowshit.scrollFactor.set(0.8,0.8);
				glowshit.active = false;
				glowshit.blend = 'add';
				
				add(glowshit);
			}
			case 'curse':
				{
					defaultCamZoom = 0.8;
					curStage = 'curse';

					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/normal_stage.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/normal_stage.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}
	
					var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(bgPic);
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);
				}
				case 'genocide':
					{
						defaultCamZoom = 0.8;
						curStage = 'genocide';
						/*var bg:FlxSprite = new FlxSprite(-600, -300).loadGraphic(Paths.image('tabi/mad/youhavebeendestroyed'));
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
						var fireRow:FlxTypedGroup<TabiFire> = new FlxTypedGroup<TabiFire>();
						for (i in 0...3)
						{
							fireRow.add(new TabiFire(10 + (i * 450), 200));
						}
						add(fireRow);*/
						//and a 1 and a 2 and a 3 and your pc is fucked lol
						/*var prefixShit:String = 'fuckedpc/PNG_Sequence/StageFire';
						var shitList:Array<String> = [];
						for (i in 0...84)
						{
							var ourUse:Array<String> = [Std.string(i)];
							var ourUse2:Array<String> = Std.string(i).split("");
							while (ourUse2.length < 2)
							{
								ourUse.push("0");
								ourUse2.push("0");
							}
							ourUse.reverse();
							//trace(ourUse);
							shitList.push(prefixShit + ourUse.join(""));
						}*/
						
						
						//genocideBG = new SequenceBG(-600, -300, shitList, true, 2560, 1400, true);

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/wadsaaa.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/wadsaaa.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
						}
	
						genocideBG = new FlxSprite(-600, -300).loadGraphic(bgPic);
						genocideBG.antialiasing = true;
						genocideBG.scrollFactor.set(0.9, 0.9);
						add(genocideBG);
						
						//Time for sini's amazing fires lol
						//this one is behind the board
						//idk how to position this
						//i guess fuck my life lol
						
						//genocide board is already in genocidebg but u know shit layering for fire lol

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/boards.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/boards.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
						}
	
						genocideBoard = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(bgPic);
						genocideBoard.antialiasing = true;
						genocideBoard.scrollFactor.set(0.9, 0.9);
						add(genocideBoard);
						
						//front fire shit
									
						//more layering shit

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/glowyfurniture.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/glowyfurniture.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
						}
	
						var fuckYouFurniture:FlxSprite = new FlxSprite(genocideBG.x, genocideBG.y).loadGraphic(bgPic);
						fuckYouFurniture.antialiasing = true;
						fuckYouFurniture.scrollFactor.set(0.9, 0.9);
						add(fuckYouFurniture);

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/Destroyed_boombox.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/Destroyed_boombox.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/blank.png"));
						}

						var destBoombox:FlxSprite = new FlxSprite(400, 130).loadGraphic(bgPic);
						destBoombox.y += (destBoombox.height - 648) * -1;
						destBoombox.y += 150;
						destBoombox.x -= 110;
						destBoombox.scale.set(1.2, 1.2);
						add(destBoombox);

					}
					case 'daveHouse':
						{
							defaultCamZoom = 0.9;
							curStage = 'daveHouse';

							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
							}
	
							var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
							bg.antialiasing = true;
							bg.scrollFactor.set(0.9, 0.9);
							bg.active = false;
							add(bg);
			
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hills.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/hills.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
							}
	
							var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(bgPic);
							stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
							stageHills.updateHitbox();
							stageHills.antialiasing = true;
							stageHills.scrollFactor.set(1, 1);
							stageHills.active = false;
							add(stageHills);
			
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/gate.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/gate.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
							}
	
							var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(bgPic);
							gate.setGraphicSize(Std.int(gate.width * 1.2));
							gate.updateHitbox();
							gate.antialiasing = true;
							gate.scrollFactor.set(0.925, 0.925);
							gate.active = false;
							add(gate);
				
							var bgPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/grass.png")) {
								bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/grass.png");
							} else {
								// fall back on base game file to avoid crashes
								bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
							}
	
							var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(bgPic);
							stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
							stageFront.updateHitbox();
							stageFront.antialiasing = true;
							stageFront.scrollFactor.set(0.9, 0.9);
							stageFront.active = false;
							add(stageFront);
						}
		case 'bambiFarm':
			{
				defaultCamZoom = 0.9;
				curStage = 'bambiFarm';

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sun.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sun.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var sun:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				sun.antialiasing = true;
				sun.scrollFactor.set(1, 1);
				sun.active = false;
				add(sun);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/gm_flatgrass.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/gm_flatgrass.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var flatgrass:FlxSprite = new FlxSprite(-600, -100).loadGraphic(bgPic);
				flatgrass.setGraphicSize(Std.int(flatgrass.width * 0.85));
				flatgrass.updateHitbox();
				flatgrass.antialiasing = true;
				flatgrass.scrollFactor.set(0.7, 0.7);
				flatgrass.active = false;
				add(flatgrass);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/background.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/background.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var hills:FlxSprite = new FlxSprite(-600, -75).loadGraphic(bgPic);
				hills.setGraphicSize(Std.int(hills.width / 1.2));
				hills.updateHitbox();
				hills.antialiasing = true;
				hills.scrollFactor.set(0.7, 0.7);
				hills.active = false;
				add(hills);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/farm.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/farm.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var farm:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				farm.antialiasing = true;
				farm.scrollFactor.set(0.9, 0.9);
				farm.active = false;
				add(farm);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/corn.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/corn.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var corn:FlxSprite = new FlxSprite(-325, 40).loadGraphic(bgPic);
				corn.setGraphicSize(Std.int(corn.width * 0.75));
				corn.updateHitbox();
				corn.antialiasing = true;
				corn.scrollFactor.set(0.9, 0.9);
				corn.active = false;
				add(corn);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sign.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sign.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var sign:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				sign.antialiasing = true;
				sign.scrollFactor.set(0.9, 0.9);
				sign.active = false;
				add(sign);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/foreground.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/foreground.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var foreground:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				foreground.antialiasing = true;
				foreground.scrollFactor.set(1, 1);
				foreground.active = false;
				add(foreground);
			}
			case 'daveHouse_night':
				{
					defaultCamZoom = 0.9;
					curStage = 'daveHouse_night';

					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky_night.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky_night.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
					}
	
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);
	
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hills_night.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/hills_night.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
					}
	
					var stageHills:FlxSprite = new FlxSprite(-225, -125).loadGraphic(bgPic);
					stageHills.setGraphicSize(Std.int(stageHills.width * 1.25));
					stageHills.updateHitbox();
					stageHills.antialiasing = true;
					stageHills.scrollFactor.set(1, 1);
					stageHills.active = false;
					add(stageHills);
	
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/gate_night.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/gate_night.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
					}
	
					var gate:FlxSprite = new FlxSprite(-225, -125).loadGraphic(bgPic);
					gate.setGraphicSize(Std.int(gate.width * 1.2));
					gate.updateHitbox();
					gate.antialiasing = true;
					gate.scrollFactor.set(0.925, 0.925);
					gate.active = false;
					add(gate);
		
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/grass_night.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/grass_night.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
					}
	
					var stageFront:FlxSprite = new FlxSprite(-225, -125).loadGraphic(bgPic);
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
					stageFront.updateHitbox();
					stageFront.antialiasing = true;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);
					//UsingNewCam = true;
				}
				case 'daveEvilHouse':
					{
						defaultCamZoom = 0.9;
						curStage = 'daveEvilHouse';

						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/redsky.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/redsky.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
						}
	
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
						bg.antialiasing = true;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = true;
						add(bg);
						//below code assumes shaders are always enabled which is bad
						var testshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
						testshader.waveAmplitude = 0.1;
						testshader.waveFrequency = 5;
						testshader.waveSpeed = 2;
						bg.shader = testshader.shader;
						curbg = bg;
						//UsingNewCam = true;
					}
			case 'bambiFarmNight':
				{
					defaultCamZoom = 0.9;
				curStage = 'bambiFarmNight';

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky_night.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky_night.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/gm_flatgrass.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/gm_flatgrass.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var flatgrass:FlxSprite = new FlxSprite(-600, -100).loadGraphic(bgPic);
				flatgrass.setGraphicSize(Std.int(flatgrass.width * 0.85));
				flatgrass.updateHitbox();
				flatgrass.antialiasing = true;
				flatgrass.scrollFactor.set(0.7, 0.7);
				flatgrass.active = false;
				flatgrass.color = 0xFF878787;
				add(flatgrass);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/background.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/background.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var hills:FlxSprite = new FlxSprite(-600, -75).loadGraphic(bgPic);
				hills.setGraphicSize(Std.int(hills.width / 1.2));
				hills.updateHitbox();
				hills.antialiasing = true;
				hills.scrollFactor.set(0.7, 0.7);
				hills.active = false;
				hills.color = 0xFF878787;
				add(hills);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/farm.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/farm.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var farm:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				farm.antialiasing = true;
				farm.scrollFactor.set(0.9, 0.9);
				farm.active = false;
				farm.color = 0xFF878787;
				add(farm);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/corn.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/corn.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var corn:FlxSprite = new FlxSprite(-325, 40).loadGraphic(bgPic);
				corn.setGraphicSize(Std.int(corn.width * 0.75));
				corn.updateHitbox();
				corn.antialiasing = true;
				corn.scrollFactor.set(0.9, 0.9);
				corn.active = false;
				corn.color = 0xFF878787;
				add(corn);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sign.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sign.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var sign:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				sign.antialiasing = true;
				sign.scrollFactor.set(0.9, 0.9);
				sign.active = false;
				sign.color = 0xFF878787;
				add(sign);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/foreground.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/foreground.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				var foreground:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
				foreground.antialiasing = true;
				foreground.scrollFactor.set(1, 1);
				foreground.active = false;
				foreground.color = 0xFF878787;
				add(foreground);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/backup.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/backup.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				backup = new FlxSprite(-300, 360).loadGraphic(bgPic);
				backup.antialiasing = true;
				backup.scrollFactor.set(1, 1);
				backup.active = false;
				backup.visible = false;
				backup.color = 0xFF878787;
				add(backup);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/lookup.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/lookup.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				lookup = new FlxSprite(125, 360).loadGraphic(bgPic);
				lookup.antialiasing = true;
				lookup.scrollFactor.set(1, 1);
				lookup.active = false;
				lookup.visible = false;
				lookup.color = 0xFF878787;
				add(lookup);

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/end.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/end.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stage_light.png"));
				}

				end = new FlxSprite(-300, 360).loadGraphic(bgPic);
				end.antialiasing = true;
				end.scrollFactor.set(1, 1);
				end.visible = false;
				end.active = false;
				end.color = 0xFF878787;
				add(end);

				var santaPic:BitmapData;
				var santaXml:String;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bambi.png")) {
				   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bambi.png");
				} else {
				   // fall back on base game file to avoid crashes
					 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
				}
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bambi.xml")) {
				   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bambi.xml");
				} else {
				   // fall back on base game file to avoid crashes
					 santaXml = Assets.getText("assets/images/christmas/santa.xml");
				}
				santa = new FlxSprite(100,450);
				santa.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
				santa.animation.addByPrefix('idle', 'i', 24, false);
				santa.animation.addByPrefix('singDOWN', 'd', 24, false);
				santa.animation.addByPrefix('singUP', 'u', 24, false);
				santa.animation.addByPrefix('singLEFT', 'l', 24, false);
				santa.animation.addByPrefix('singRIGHT', 'r', 24, false);
				santa.visible = false;
				santa.antialiasing = true;
				santa.color = 0xFF878787;
				add(santa);

				}

				case 'tank':
					defaultCamZoom = 0.9;
					// pretend it's stage, it doesn't check for correct images
					curStage = 'tank';
					// peck it no one is gonna build this for html5 so who cares if it doesn't compile
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankSky.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankSky.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var bg = new FlxSprite(-400, -400).loadGraphic(bgPic);
					bg.scrollFactor.set();
					bg.antialiasing = true;
					add(bg);
					var frontPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankMountains.png")) {
						frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankMountains.png");
					} else {
						// fall back on base game file to avoid crashes
						frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
					}

					var mountains:FlxSprite = new FlxSprite(-300, -20).loadGraphic(frontPic);
					mountains.antialiasing = true;
					mountains.setGraphicSize(Std.int(mountains.width * 1.2));
					mountains.updateHitbox();
					mountains.scrollFactor.set(0.2, 0.2);
					add(mountains);

					var frontPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankBuildings.png")) {
						frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankBuildings.png");
					} else {
						// fall back on base game file to avoid crashes
						frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
					}

					var building:FlxSprite = new FlxSprite(-200).loadGraphic(frontPic);
					building.setGraphicSize(Std.int(building.width * 1.1));
                    building.antialiasing = true;
                    building.updateHitbox();
                    building.scrollFactor.set(0.3, 0.3);
					add(building);

					var frontPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankRuins.png")) {
						frontPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankRuins.png");
					} else {
						// fall back on base game file to avoid crashes
						frontPic = BitmapData.fromImage(Assets.getImage("assets/images/stagefront.png"));
					}

					var ruins:FlxSprite = new FlxSprite(-200).loadGraphic(frontPic);
					ruins.scrollFactor.set(0.35, 0.35);
                    ruins.setGraphicSize(Std.int(1.1 * ruins.width));
                    ruins.updateHitbox();
                    ruins.antialiasing = true;
					add(ruins);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/smokeLeft.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/smokeLeft.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/smokeLeft.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/smokeLeft.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var smokeLeft = new FlxSprite(-200 , -100);
					smokeLeft.frames = hallowTex;
					smokeLeft.animation.addByPrefix('idle', 'SmokeBlurLeft', 24, true);
                    smokeLeft.animation.play('idle', true);
                    smokeLeft.scrollFactor.set(0.4, 0.4);
                    smokeLeft.antialiasing = true;
					add(smokeLeft);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/smokeRight.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/smokeRight.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/smokeRight.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/smokeRight.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var smokeRight = new FlxSprite(1100, -100);
					smokeRight.frames = hallowTex;
					smokeRight.animation.addByPrefix('idle', 'SmokeRight', 24, true);
	                smokeRight.animation.play('idle', true);
	                smokeRight.scrollFactor.set(0.4, 0.4);
                    smokeRight.antialiasing = true;
					add(smokeRight);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankWatchtower.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankWatchtower.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankWatchtower.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tankWatchtower.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tower = new FlxSprite(100, 50);
					tower.frames = hallowTex;
					tower.animation.addByPrefix('idle', 'watchtower gradient color', 24, false);
	                tower.animation.play('idle', true);
	                tower.scrollFactor.set(0.5, 0.5);
	                tower.updateHitbox();
	                tower.antialiasing = true;
					add(tower);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankRolling.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankRolling.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankRolling.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tankRolling.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var steve = new FlxSprite(300, 300);
					steve.frames = hallowTex;
					steve.animation.addByPrefix('idle', "BG tank w lighting", 24, true);
					steve.animation.play('idle', true);
					steve.antialiasing = true;
					steve.scrollFactor.set(0.5, 0.5);
					add(steve);

					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tankGround.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tankGround.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					var bg:FlxSprite = new FlxSprite(-420, -150).loadGraphic(bgPic);
					// bg.setGraphicSize(Std.int(bg.width * 2.5));
					// bg.updateHitbox();
					bg.setGraphicSize(Std.int(1.15 * bg.width));
                    bg.updateHitbox();
                    bg.antialiasing = true;
					bg.active = false;
					add(bg);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank0.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tank0.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank0.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tank0.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tank0 = new FlxSprite(-500, 650);
					tank0.frames = hallowTex;
					tank0.antialiasing = true;
					tank0.animation.addByPrefix("idle", "fg", 24);
					tank0.scrollFactor.set(1.7, 1.5);
					tank0.animation.play("idle");
					add(tank0);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank1.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tank1.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank1.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tank1.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tank1 = new FlxSprite(-300, 750);
					tank1.frames = hallowTex;
					tank1.antialiasing = true;
	                tank1.animation.addByPrefix("idle", "fg", 24);
	                tank1.scrollFactor.set(2, 0.2);
	                tank1.animation.play("idle");
					add(tank1);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank2.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tank2.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank2.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tank2.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tank2 = new FlxSprite(450, 940);
					tank2.frames = hallowTex;
					tank2.antialiasing = true;
	                tank2.animation.addByPrefix("idle", "foreground", 24);
	                tank2.scrollFactor.set(1.5, 1.5);
	                tank2.animation.play("idle");
					add(tank2);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank4.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tank4.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank4.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tank4.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tank4 = new FlxSprite(1300, 900);
					tank4.frames = hallowTex;
					tank4.antialiasing = true;
	                tank4.animation.addByPrefix("idle", "fg", 24);
	                tank4.scrollFactor.set(1.5, 1.5);
	                tank4.animation.play("idle");
					add(tank4);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank5.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tank5.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank5.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tank5.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tank5 = new FlxSprite(1620, 700);
					tank5.frames = hallowTex;
					tank5.antialiasing = true;
                 	tank5.animation.addByPrefix("idle", "fg", 24);
                 	tank5.scrollFactor.set(1.5, 1.5);
	                tank5.animation.play("idle");
					add(tank5);

					var bgPic:BitmapData;
					var bgXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank3.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tank3.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
					}
					    if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tank3.xml")) {
					   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tank3.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgXml = Assets.getText("assets/images/halloween_bg.xml");
					}
					var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

					var tank3 = new FlxSprite(1300, 1200);
					tank3.frames = hallowTex;
					tank3.antialiasing = true;
                 	tank3.animation.addByPrefix("idle", "fg", 24);
	                tank3.scrollFactor.set(3.5, 2.5);
                 	tank3.animation.play("idle");
					add(tank3);

					case 'spooky':
						curStage = "spooky";
						halloweenLevel = true;
						var bgPic:BitmapData;
						var bgXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/halloween_bg.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/halloween_bg.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
						}
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/halloween_bg.xml")) {
						   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/halloween_bg.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 bgXml = Assets.getText("assets/images/halloween_bg.xml");
						}
						var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);
	
						halloweenBG = new FlxSprite(-200, -100);
						halloweenBG.frames = hallowTex;
						halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
						halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
						halloweenBG.animation.play('idle');
						halloweenBG.antialiasing = true;
						add(halloweenBG);
	
						isHalloween = true;

						case 'park1':
							{
									defaultCamZoom = 0.7;
									curStage = 'park1';
									
									var bgPic:BitmapData;
									var bgXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg.xml")) {
									   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 bgXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);
			
									halloweenBG = new FlxSprite(-600, -200);
									halloweenBG.frames = hallowTex;
									halloweenBG.animation.addByPrefix('idle', 'BackGround');
									halloweenBG.antialiasing = true;
									halloweenBG.scrollFactor.set(0.9, 0.9);
									halloweenBG.animation.play('idle');
									add(halloweenBG);	
				
							}
						case 'park2':
							{
									defaultCamZoom = 0.7;
									curStage = 'park2';
									
									var bgPic:BitmapData;
									var bgXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg2.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg2.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg2.xml")) {
									   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg2.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 bgXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

									halloweenBG = new FlxSprite(-600, -200);
									halloweenBG.frames = hallowTex;
									halloweenBG.animation.addByPrefix('idle', 'BackGround');
									halloweenBG.antialiasing = true;
									halloweenBG.scrollFactor.set(0.9, 0.9);
									halloweenBG.animation.play('idle');
									add(halloweenBG);	
				
							}
						case 'park3':
							{
									defaultCamZoom = 0.6;
									curStage = 'park3';

									var bgPic:BitmapData;
									var bgXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg3.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg3.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg3.xml")) {
									   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/tree_and_bg3.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 bgXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

									halloweenBG = new FlxSprite(-600, -200);
									halloweenBG.frames = hallowTex;
									halloweenBG.animation.addByPrefix('idle', 'BackGround');
									halloweenBG.antialiasing = true;
									halloweenBG.scrollFactor.set(0.9, 0.9);
									halloweenBG.animation.play('idle');
									add(halloweenBG);	
							}
						case 'park0':
							{
									defaultCamZoom = 0.7;
									curStage = 'park0';

									var bgPic:BitmapData;
									var bgXml:String;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/finalbg.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/finalbg.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/halloween_bg.png"));
									}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/finalbg.xml")) {
									   bgXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/finalbg.xml");
									} else {
									   // fall back on base game file to avoid crashes
										 bgXml = Assets.getText("assets/images/halloween_bg.xml");
									}
									var hallowTex = FlxAtlasFrames.fromSparrow(bgPic, bgXml);

									halloweenBG = new FlxSprite(-600, -200);
									halloweenBG.frames = hallowTex;
									halloweenBG.animation.addByPrefix('idle', 'BackGround');
									halloweenBG.antialiasing = true;
									halloweenBG.scrollFactor.set(0.9, 0.9);
									halloweenBG.animation.play('idle');
									add(halloweenBG);	
							}
						case 'park-1':
							{
								defaultCamZoom = 0.7;
								curStage = 'park-1';
			
								var bgPic:BitmapData;
								if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/grass.png")) {
									bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/grass.png");
								} else {
									// fall back on base game file to avoid crashes
									bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
								}
			
								halloweenBG = new FlxSprite(-600, -200).loadGraphic(bgPic);
								halloweenBG.antialiasing = true;
								halloweenBG.scrollFactor.set(0.9, 0.9);
								add(halloweenBG);	
							}	
							case 'hallway':
								{
									defaultCamZoom = 0.9;
									curStage = 'hallway';
									
									var bgPic:BitmapData;
									if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hallway.png")) {
										bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/hallway.png");
									} else {
										// fall back on base game file to avoid crashes
										bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
									}
	
									var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
									bg.antialiasing = true;
									bg.scrollFactor.set(1, 1);
									bg.active = false;
									add(bg);
						
								}
								case 'hallwaynoon':
									{
										defaultCamZoom = 0.9;
										curStage = 'hallwaynoon';

										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/hallwaynoon.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/hallwaynoon.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
	
										var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
										bg.antialiasing = true;
										bg.scrollFactor.set(1, 1);
										bg.active = false;
										add(bg);
							
										var crowdPic:BitmapData;
										var crowdXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/People.png")) {
										   crowdPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/People.png");
										} else {
										   // fall back on base game file to avoid crashes
											 crowdPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bottomBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/People.xml")) {
										   crowdXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/People.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 crowdXml = Assets.getText("assets/images/christmas/bottomBop.xml");
										}
				
										bottomBoppers = new FlxSprite(-95, 200);
												bottomBoppers.frames = FlxAtlasFrames.fromSparrow(crowdPic, crowdXml);
												bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
												bottomBoppers.antialiasing = true;
													bottomBoppers.scrollFactor.set(1, 1);
													bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 0.93));
												bottomBoppers.updateHitbox();
												add(bottomBoppers);
							
									}
								case 'darkhallway':
									{
										defaultCamZoom = 0.9;
										curStage = 'darkhallway';

										var bgPic:BitmapData;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/darkhallway.png")) {
											bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/darkhallway.png");
										} else {
											// fall back on base game file to avoid crashes
											bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
										}
	
										var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(bgPic);
										bg.antialiasing = true;
										bg.scrollFactor.set(1, 1);
										bg.active = false;
										add(bg);
								
										var crowdPic:BitmapData;
										var crowdXml:String;
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/PeopleNight.png")) {
										   crowdPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/PeopleNight.png");
										} else {
										   // fall back on base game file to avoid crashes
											 crowdPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bottomBop.png"));
										}
										if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/PeopleNight.xml")) {
										   crowdXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/PeopleNight.xml");
										} else {
										   // fall back on base game file to avoid crashes
											 crowdXml = Assets.getText("assets/images/christmas/bottomBop.xml");
										}
	
										bottomBoppers = new FlxSprite(-95, 200);
										bottomBoppers.frames = FlxAtlasFrames.fromSparrow(crowdPic, crowdXml);
										bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
										bottomBoppers.antialiasing = true;
										bottomBoppers.scrollFactor.set(1, 1);
										bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 0.93));
										bottomBoppers.updateHitbox();
										add(bottomBoppers);
							
							}
							case 'spaceship':
								{
									defaultCamZoom = 0.72;
											curStage = 'spaceship';

											var bgPic:BitmapData;
											if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/space.png")) {
												bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/space.png");
											} else {
												// fall back on base game file to avoid crashes
												bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
											}
	
											var bg:FlxSprite = new FlxSprite(-660, -487).loadGraphic(bgPic);
											bg.antialiasing = true;
											bg.scrollFactor.set(0.65, 0.65);
											bg.active = false;
											add(bg);
						
											var bgPic:BitmapData;
											if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/earth.png")) {
												bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/earth.png");
											} else {
												// fall back on base game file to avoid crashes
												bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
											}
	
											var city:FlxSprite = new FlxSprite(-625, -460).loadGraphic(bgPic);
											city.scrollFactor.set(0.8, 0.8);
											city.setGraphicSize(Std.int(city.width * 0.85));
											city.updateHitbox();
											add(city);
						
											var bgPic:BitmapData;
											if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/spacebg.png")) {
												bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/spacebg.png");
											} else {
												// fall back on base game file to avoid crashes
												bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
											}
	
											var stageCurtains:FlxSprite = new FlxSprite(-660, -467).loadGraphic(bgPic);
											stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
											stageCurtains.updateHitbox();
											stageCurtains.antialiasing = true;
											stageCurtains.scrollFactor.set(1, 1);
											stageCurtains.active = false;
						
											add(stageCurtains);
								}
						
					case 'philly':
						curStage = 'philly';
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sky.png")) {
							bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sky.png");
						} else {
							// fall back on base game file to avoid crashes
							bgPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/sky.png"));
						}
						var bg:FlxSprite = new FlxSprite(-100).loadGraphic(bgPic);
						bg.scrollFactor.set(0.1, 0.1);
						add(bg);
						var cityPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/city.png")) {
							cityPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/city.png");
						} else {
							// fall back on base game file to avoid crashes
							cityPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/city.png"));
						}
						var city:FlxSprite = new FlxSprite(-10).loadGraphic(cityPic);
						city.scrollFactor.set(0.3, 0.3);
						city.setGraphicSize(Std.int(city.width * 0.85));
						city.updateHitbox();
						add(city);
	
						phillyCityLights = new FlxTypedGroup<FlxSprite>();
						add(phillyCityLights);
	
						for (i in 0...5)
						{
							var lightPic:BitmapData;
							if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png")) {
								lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/win"+i+".png");
							} else {
								// fall back on base game file to avoid crashes
								lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
							}
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(lightPic);
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							phillyCityLights.add(light);
						}
						var backstreetPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/behindTrain.png")) {
							backstreetPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/behindTrain.png");
						} else {
							// fall back on base game file to avoid crashes
							backstreetPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/behindTrain.png"));
						}
						var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(backstreetPic);
						add(streetBehind);
						var trainPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/train.png")) {
							trainPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/train.png");
						} else {
							// fall back on base game file to avoid crashes
							trainPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/train.png"));
						}
						phillyTrain = new FlxSprite(2000, 360).loadGraphic(trainPic);
						add(phillyTrain);
	
						trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
						FlxG.sound.list.add(trainSound);
	
	
						var streetPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/street.png")) {
							streetPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/street.png");
						} else {
							// fall back on base game file to avoid crashes
							streetPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/street.png"));
						}
						var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(streetPic);
						add(street);
				case 'limo':
					curStage = 'limo';
					defaultCamZoom = 0.90;
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/limoSunset.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/limoSunset.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/limo/limoSunset.png"));
					}
					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(bgPic);
					skyBG.scrollFactor.set(0.1, 0.1);
					add(skyBG);
					var bgLimoPic:BitmapData;
					var bgLimoXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgLimo.png")) {
						bgLimoPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bgLimo.png");
					} else {
						// fall back on base game file to avoid crashes
						bgLimoPic = BitmapData.fromImage(Assets.getImage("assets/images/limo/bgLimo.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgLimo.xml")) {
					   bgLimoXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bgLimo.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 bgLimoXml = Assets.getText("assets/images/limo/bgLimo.xml");
					}
					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = FlxAtlasFrames.fromSparrow(bgLimoPic, bgLimoXml);
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					add(bgLimo);

					grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					add(grpLimoDancers);

					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400, SONG.stage);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}
					var limoOverlayPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/limoOverlay.png")) {
						limoOverlayPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/limoOverlay.png");
					} else {
						// fall back on base game file to avoid crashes
						limoOverlayPic = BitmapData.fromImage(Assets.getImage("assets/images/limo/limoOverlay.png"));
					}
					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(limoOverlayPic);
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;
					var limoPic:BitmapData;
					var limoXml:String;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/limoDrive.png")) {
						limoPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/limoDrive.png");
					} else {
						// fall back on base game file to avoid crashes
						limoPic = BitmapData.fromImage(Assets.getImage("assets/images/limo/limoDrive.png"));
					}
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/limoDrive.xml")) {
					   limoXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/limoDrive.xml");
					} else {
					   // fall back on base game file to avoid crashes
						 limoXml = Assets.getText("assets/images/limo/limoDrive.xml");
					}
					var limoTex = FlxAtlasFrames.fromSparrow(limoPic, limoXml);

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = true;
					var fastCarPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"_fastcar.png");
					fastCar = new FlxSprite(-300, 160).loadGraphic(fastCarPic);
					// add(limo);
					case 'mall':
						curStage = 'mall';
	
						defaultCamZoom = 0.80;
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgWalls.png")) {
						   bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bgWalls.png");
						} else {
						   // fall back on base game file to avoid crashes
							 bgPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bgWalls.png"));
						}
						var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(bgPic);
						bg.antialiasing = true;
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
						add(bg);
						var standsPic:BitmapData;
						var standsXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/upperBop.png")) {
						   standsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/upperBop.png");
						} else {
						   // fall back on base game file to avoid crashes
							 standsPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/upperBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/upperBop.xml")) {
						   standsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/upperBop.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 standsXml = Assets.getText("assets/images/christmas/upperBop.xml");
						}
						upperBoppers = new FlxSprite(-240, -90);
						upperBoppers.frames = FlxAtlasFrames.fromSparrow(standsPic, standsXml);
						upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
						upperBoppers.antialiasing = true;
						upperBoppers.scrollFactor.set(0.33, 0.33);
						upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
						upperBoppers.updateHitbox();
						add(upperBoppers);
						var escalatorPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgEscalator.png")) {
						   escalatorPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bgEscalator.png");
						} else {
						   // fall back on base game file to avoid crashes
							 escalatorPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bgEscalator.png"));
						}
						var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(escalatorPic);
						bgEscalator.antialiasing = true;
						bgEscalator.scrollFactor.set(0.3, 0.3);
						bgEscalator.active = false;
						bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
						bgEscalator.updateHitbox();
						add(bgEscalator);
						var treePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/christmasTree.png")) {
						   treePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/christmasTree.png");
						} else {
						   // fall back on base game file to avoid crashes
							 treePic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/christmasTree.png"));
						}
						var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(treePic);
						tree.antialiasing = true;
						tree.scrollFactor.set(0.40, 0.40);
						add(tree);
						var crowdPic:BitmapData;
						var crowdXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bottomBop.png")) {
						   crowdPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bottomBop.png");
						} else {
						   // fall back on base game file to avoid crashes
							 crowdPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/bottomBop.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bottomBop.xml")) {
						   crowdXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bottomBop.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 crowdXml = Assets.getText("assets/images/christmas/bottomBop.xml");
						}
						bottomBoppers = new FlxSprite(-300, 140);
						bottomBoppers.frames = FlxAtlasFrames.fromSparrow(crowdPic, crowdXml);
						bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
						bottomBoppers.antialiasing = true;
						bottomBoppers.scrollFactor.set(0.9, 0.9);
						bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
						bottomBoppers.updateHitbox();
						add(bottomBoppers);
						var snowPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/fgSnow.png")) {
						   snowPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/fgSnow.png");
						} else {
						   // fall back on base game file to avoid crashes
							 snowPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/fgSnow.png"));
						}
						var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(snowPic);
						fgSnow.active = false;
						fgSnow.antialiasing = true;
						add(fgSnow);
						var santaPic:BitmapData;
						var santaXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/santa.png")) {
						   santaPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/santa.png");
						} else {
						   // fall back on base game file to avoid crashes
							 santaPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/santa.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/santa.xml")) {
						   santaXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/santa.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 santaXml = Assets.getText("assets/images/christmas/santa.xml");
						}
						santa = new FlxSprite(-840, 150);
						santa.frames = FlxAtlasFrames.fromSparrow(santaPic, santaXml);
						santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
						santa.antialiasing = true;
						add(santa);
					case 'mallEvil':
						curStage = 'mallEvil';
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/evilBG.png")) {
						   bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/evilBG.png");
						} else {
						   // fall back on base game file to avoid crashes
							 bgPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/evilBG.png"));
						}
	
						var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(bgPic);
						bg.antialiasing = true;
						bg.scrollFactor.set(0.2, 0.2);
						bg.active = false;
						bg.setGraphicSize(Std.int(bg.width * 0.8));
						bg.updateHitbox();
						add(bg);
						var evilTreePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/evilTree.png")) {
						   evilTreePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/evilTree.png");
						} else {
						   // fall back on base game file to avoid crashes
							 evilTreePic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/evilTree.png"));
						}
						var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(evilTreePic);
						evilTree.antialiasing = true;
						evilTree.scrollFactor.set(0.2, 0.2);
						add(evilTree);
						var evilSnowPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/evilSnow.png")) {
						   evilSnowPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/evilSnow.png");
						} else {
						   // fall back on base game file to avoid crashes
							 evilSnowPic = BitmapData.fromImage(Assets.getImage("assets/images/christmas/evilSnow.png"));
						}
						var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(evilSnowPic);
						evilSnow.antialiasing = true;
						add(evilSnow);
					case 'school':
						curStage = 'school';
						// school moody is just the girls are upset
						// defaultCamZoom = 0.9;
						var bgPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/weebSky.png")) {
						   bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/weebSky.png");
						} else {
						   // fall back on base game file to avoid crashes
							 bgPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/weebSky.png"));
						}
						var bgSky = new FlxSprite().loadGraphic(bgPic);
						bgSky.scrollFactor.set(0.1, 0.1);
						add(bgSky);
	
						var repositionShit = -200;
						var schoolPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/weebSchool.png")) {
						   schoolPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/weebSchool.png");
						} else {
						   // fall back on base game file to avoid crashes
							 schoolPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/weebSchool.png"));
						}
						var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(schoolPic);
						bgSchool.scrollFactor.set(0.6, 0.90);
						add(bgSchool);
						var streetPic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/weebStreet.png")) {
						   streetPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/weebStreet.png");
						} else {
						   // fall back on base game file to avoid crashes
							 streetPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/weebStreet.png"));
						}
						var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(streetPic);
						bgStreet.scrollFactor.set(0.95, 0.95);
						add(bgStreet);
						var fgTreePic:BitmapData;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/weebTreesBack.png")) {
						   fgTreePic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/weebTreesBack.png");
						} else {
						   // fall back on base game file to avoid crashes
							 fgTreePic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/weebTreesBack.png"));
						}
						var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(fgTreePic);
						fgTrees.scrollFactor.set(0.9, 0.9);
						add(fgTrees);
						var treesPic:BitmapData;
						var treesTxt:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/weebTrees.png")) {
						   treesPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/weebTrees.png");
						} else {
						   // fall back on base game file to avoid crashes
							 treesPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/weebTrees.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/weebTrees.txt")) {
						   treesTxt = File.getContent('assets/images/custom_stages/'+SONG.stage+"/weebTrees.txt");
						} else {
						   // fall back on base game file to avoid crashes
							 treesTxt = Assets.getText("assets/images/weeb/weebTrees.txt");
						}
						var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
						var treetex = FlxAtlasFrames.fromSpriteSheetPacker(treesPic, treesTxt);
						bgTrees.frames = treetex;
						bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
						bgTrees.animation.play('treeLoop');
						bgTrees.scrollFactor.set(0.85, 0.85);
						add(bgTrees);
						var petalsPic:BitmapData;
						var petalsXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/petals.png")) {
						   petalsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/petals.png");
						} else {
						   // fall back on base game file to avoid crashes
							 petalsPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/petals.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/petals.xml")) {
						   petalsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/petals.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 petalsXml = Assets.getText("assets/images/weeb/petals.xml");
						}
						var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
						treeLeaves.frames = FlxAtlasFrames.fromSparrow(petalsPic, petalsXml);
						treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
						treeLeaves.animation.play('leaves');
						treeLeaves.scrollFactor.set(0.85, 0.85);
						add(treeLeaves);
	
						var widShit = Std.int(bgSky.width * 6);
	
						bgSky.setGraphicSize(widShit);
						bgSchool.setGraphicSize(widShit);
						bgStreet.setGraphicSize(widShit);
						bgTrees.setGraphicSize(Std.int(widShit * 1.4));
						fgTrees.setGraphicSize(Std.int(widShit * 0.8));
						treeLeaves.setGraphicSize(widShit);
	
						fgTrees.updateHitbox();
						bgSky.updateHitbox();
						bgSchool.updateHitbox();
						bgStreet.updateHitbox();
						bgTrees.updateHitbox();
						treeLeaves.updateHitbox();
						var gorlsPic:BitmapData;
						var gorlsXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.png")) {
						   gorlsPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.png");
						} else {
						   // fall back on base game file to avoid crashes
							 gorlsPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/bgFreaks.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.xml")) {
						   gorlsXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/bgFreaks.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 gorlsXml = Assets.getText("assets/images/weeb/bgFreaks.xml");
						}
						bgGirls = new BackgroundGirls(-100, 190, gorlsPic, gorlsXml);
						bgGirls.scrollFactor.set(0.9, 0.9);
	
						if (SONG.isMoody)
						{
							bgGirls.getScared();
						}
	
						bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
						bgGirls.updateHitbox();
						add(bgGirls);
					case 'schoolEvil':
						curStage = 'schoolEvil';
	
						var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
						var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
	
						var posX = 400;
						var posY = 200;
	
						var bg:FlxSprite = new FlxSprite(posX, posY);
						var evilSchoolPic:BitmapData;
						var evilSchoolXml:String;
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/animatedEvilSchool.png")) {
						   evilSchoolPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/animatedEvilSchool.png");
						} else {
						   // fall back on base game file to avoid crashes
							 evilSchoolPic = BitmapData.fromImage(Assets.getImage("assets/images/weeb/animatedEvilSchool.png"));
						}
						if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/animatedEvilSchool.xml")) {
						   evilSchoolXml = File.getContent('assets/images/custom_stages/'+SONG.stage+"/animatedEvilSchool.xml");
						} else {
						   // fall back on base game file to avoid crashes
							 evilSchoolXml = Assets.getText("assets/images/weeb/animatedEvilSchool.xml");
						}
						bg.frames = FlxAtlasFrames.fromSparrow(evilSchoolPic, evilSchoolXml);
						bg.animation.addByPrefix('idle', 'background 2', 24);
						bg.animation.play('idle');
						bg.scrollFactor.set(0.8, 0.9);
						bg.scale.set(6, 6);
						add(bg);
				}
			}
			
		var gfVersion:String = 'gf';

		gfVersion = SONG.gf;

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (curStage != 'genocide')
			{
				gf.scrollFactor.set(0.95, 0.95);
			}
	
		dad = new Character(100, 100, SONG.player2);

		switch (SONG.gf)
		{
			case 'gf-bosip':
				gf.y -= 40;
				gf.x -= 30;
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode )
				{
					camPos.x += 600;
					tweenCamIn();
				}
			case 'dj-monkey':
				dad.setPosition(gf.x - 275, gf.y + 15);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 0;
					tweenCamIn();
				}


			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 130;
			case "pompom":
				dad.y += 200;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'rad':
				camPos.x += 400;
			case 'kath':
				dad.x += 84;
				dad.y += 118;
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'bob':
				dad.y += 50;
			case 'bosip':
				dad.y -= 50;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.x += 370;
				camPos.y += 300;
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.x += 370;
				camPos.y += 300;
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.x += 300;
			case 'mackie':
				dad.x -= 300;
			case 'mackiepom':
				dad.x -= 300;
				dad.y -= 25;
			case 'rian':
                dad.y += 270;
                camPos.y = 546.65;
                camPos.x = 574.38;
                dad.scale.set(1.4, 1.4);
			case 'cheese-default':
			    dad.x = 231;
				dad.y = 250.15;
				camPos.x = 300;
			case 'cheese-milkshake':
			    dad.x = 231;
				dad.y = 250.15;
				camPos.x = 300;
			case 'cheese-cultured':
			    dad.x = 231;
				dad.y = 250.15;
				camPos.x = 300;
			case 'momi':
				camPos.x = 300;
			case 'nekomomi':
				camPos.x = 300;
			case 'hellcarol':
				dad.setPosition(32,-173.55);
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'dave-angey':
				dad.scale.set(0.75, 0.75);



			default:	
				dad.x += dad.enemyOffsetX;
				dad.y += dad.enemyOffsetY;
				camPos.x += dad.camOffsetX;
				camPos.y += dad.camOffsetY;
				if (dad.like == "gf") {
					dad.setPosition(gf.x, gf.y);
					gf.visible = false;
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
					}
				}
		}

		switch (gfVersion)
		{
			case 'dj-monkey':
				gf.x -= 40;
				gf.y -= 137;
		}

		
		boyfriend = new Boyfriend(770, 450, SONG.player1);

		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'village':
				gf.x += -270;
				dad.x += -270;
			case 'bambiFarmNight':
		    {
				dad.color = 0xFF878787;
				gf.color = 0xFF878787;
				boyfriend.color = 0xFF878787;
			}
			case 'violastroStage':
				boyfriend.x += 200;
				gf.y -= 60;
			case 'mall':
				boyfriend.x += 200;
			case 'curse':
				boyfriend.x += 300;
				gf.y -= 110;
				gf.x -= 50;
			case 'genocide':
				boyfriend.x += 300;
				gf.x += 100;
				var tabiTrail = new FlxTrail(dad, null, 4, 24, 0.6, 0.9);
				add(tabiTrail);
			case 'swordarena':
				boyfriend.x += 200;
			case 'boxFC':
			
				var evilTrail = new FlxTrail(dad, null, 1, 24, 0.3, 0.069);
				add(evilTrail);
			
				boyfriend.x += 200;
				
				
			case 'boxDM':
			
				var evilTrail = new FlxTrail(dad, null, 1, 24, 0.3, 0.069);
				add(evilTrail);
			
				boyfriend.x += 200;
				
			case 'boxWU':
			
				boyfriend.x += 200;
				
			case 'boxKH':
			
				boyfriend.x += 200;
			case 'boxTKO':
				
				boyfriend.x += 140;
            case 'boxKHF':
			    boyfriend.x += 140;
			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				// trailArea.scrollFactor.set();

				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				// evilTrail.changeValuesEnabled(false, false, false, false);
				// evilTrail.changeGraphic()
				add(evilTrail);
				// evilTrail.scrollFactor.set(1.1, 1.1);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'biscuit':
				boyfriend.x += 300;
			case 'gateau':
				boyfriend.x += 300;
			case 'pom-pomeranian':
				boyfriend.x += 300;
			case 'momiStage':
				boyfriend.setPosition(922.7, 301.4);
				
				gf.setPosition(454.35, 11.55);
				
				dad.setPosition(67, 18.05);
			case 'ego':
				dad.x -= 40;
				dad.y += 130;
				boyfriend.x += 181;
				boyfriend.y += 130;
				gf.x -= 48;
				gf.y += 84;
			case 'ridzak':
				dad.x -= 40;
				dad.y += 130;
				boyfriend.x += 181;
				boyfriend.y += 130;
				gf.x -= 48;
				gf.y += 84;
			case 'cyb':
				boyfriend.x = 946.3;
				boyfriend.y = 31.95;
				gf.x = 371.2;
				gf.y = -331.2;
				dad.x = -201.15;
				dad.y = -381.8;
				gf.scrollFactor.set(1, 1);
				add(gf);
				add(boyfriend);
				add(dad);
			case 'restaurante':
				boyfriend.x += 340;
				boyfriend.y += 270;
				gf.x += 1263;
				gf.y += 270;
			case 'rucksburg':
				boyfriend.x += 50; 
				boyfriend.y -= 10;
				gf.x -= 120;
				gf.y += 82;
			case 'bawnebyl':
				boyfriend.x += 50; 
				boyfriend.y -= 10;
				gf.x -= 109;
				gf.y += 70;
			case 'day' | 'sunset':
				dad.x -= 150;
				dad.y -= 11;
				boyfriend.x += 191;
				boyfriend.y -= 20;
				gf.x -= 70;
				gf.y -= 50;
				camPos.x = 536.63;
				camPos.y = 449.94;
			case 'night':
				dad.x -= 370;
				dad.y + 39	;
				boyfriend.x += 191;
				boyfriend.y -= 20;
				gf.x += 300;
				gf.y -= 50;

			case 'tank':
				boyfriend.x += 40;
				dad.y += 60;
				dad.x -= 80;
				gf.y += 10;
				gf.x -= 30;

				if (gf.like == 'gf-tankmen' && curStage == 'tank')
					{
						gf.x -= 50;
						gf.y -= 200;
					}
				if (gf.like == 'pico-speaker' && curStage == 'tank')
					{
						gf.x -= 170;
						gf.y -= 75;
					}
		}

		if (SONG.isSpooky) {
			trace("WOAH SPOOPY");
			var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
			// evilTrail.changeValuesEnabled(false, false, false, false);
			// evilTrail.changeGraphic()
			add(evilTrail);
		}


		add(gf);
		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dad);

		if (SONG.song.toLowerCase() == 'skylight')
			{
			add(spotlightDJ);
			}
		if (curStage == 'bambiFarmNight')
			{
			add(santa);
			}


		add(boyfriend);
		switch (curStage)
		{
			case 'curse':

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/sumtable.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/sumtable.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sumtable:FlxSprite = new FlxSprite(-600, -300).loadGraphic(bgPic);
				sumtable.antialiasing = true;
				sumtable.scrollFactor.set(0.9, 0.9);
				sumtable.active = false;
				add(sumtable);
			case 'genocide':

				var bgPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/overlayingsticks.png")) {
					bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/overlayingsticks.png");
				} else {
					// fall back on base game file to avoid crashes
					bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var sumsticks:FlxSprite = new FlxSprite(-600, -300).loadGraphic(bgPic);
				sumsticks.antialiasing = true;
				sumsticks.scrollFactor.set(0.9, 0.9);
				sumsticks.active = false;
				add(sumsticks);
		}
		if (curStage == 'day') {

			var trainPic:BitmapData;
			if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/PP_truck.png")) {
				trainPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/PP_truck.png");
			} else {
				// fall back on base game file to avoid crashes
				trainPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/train.png"));
			}

			phillyTrain = new FlxSprite(200, 200).loadGraphic(trainPic);
			phillyTrain.scale.set(1.2, 1.2);
			phillyTrain.visible = false;
			add(phillyTrain);
		}
		if (curStage == 'sunset') {

			var trainPic:BitmapData;
			if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/CJ_car.png")) {
				trainPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/CJ_car.png");
			} else {
				// fall back on base game file to avoid crashes
				trainPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/train.png"));
			}

			phillyTrain = new FlxSprite(200, 200).loadGraphic(trainPic);
			phillyTrain.scale.set(1.2, 1.2);
			phillyTrain.visible = false;
			add(phillyTrain);
		}
		if (curStage == "momiStage"){
			add(dust);
			add(car);
			add(carhit);
		}
		switch (SONG.song.toLowerCase()) {
			case 'vibe-':

				var bg3Pic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/overlay.png")) {
					bg3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/overlay.png");
				} else {
					// fall back on base game file to avoid crashes
					bg3Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
				}

				var bg3:FlxSprite = new FlxSprite(-140, 0).loadGraphic(bg3Pic);
				bg3.antialiasing = true;
				add(bg3);
			case 'orbit' | 'genesis' | 'golden':
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);
				for (i in 1...3)
				{
					var lightPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/light"+i+".png")) {
						lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/light"+i+".png");
					} else {
						// fall back on base game file to avoid crashes
						lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
					}

					var light:FlxSprite = new FlxSprite(-449, -476).loadGraphic(lightPic);
					light.visible = false;
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}
		}

		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);

		switch (SONG.song.toLowerCase())
		{
			case 'skylight':
				add(fgLightbulb);
				add(spotlightPlayer);
				add(vignette);
		}


		var doof:DialogueBox = new DialogueBox(false, dialogue);
		trace("AMONG US SPONG US");
		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);
		trace(SONG.cutsceneType);

		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;


		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (FlxG.save.data.downscroll)
			strumLine.y = FlxG.height - 150;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);


		playerStrums = new FlxTypedGroup<FlxSprite>();
		player2Strums = new FlxTypedGroup<FlxSprite>();


		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (FlxG.save.data.downscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
				if (FlxG.save.data.downscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (FlxG.save.data.downscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		if (SONG.song.toLowerCase() != 'genocide')
			{
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			} else {
				healthBar.createFilledBar(0xFF91271D, 0xFF31B0D1);
			}

		if (SONG.song.toLowerCase() != 'slash')
			{
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
			} else {
				healthBar.createFilledBar(0xFF91271D, 0xFF31B0D1);
			}
			// healthBar
		add(healthBar);

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " " + (storyDifficulty == 5 ? "Unnerfed" :storyDifficulty == 4 ? "Crazy" : storyDifficulty == 3 ? "Alt" : storyDifficulty == 2 ? "Hard" : storyDifficulty == 1 ? "Normal" : "Easy") + (Main.watermarks ? " - Fusion " + MainMenuState.kadeEngineVer : ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (FlxG.save.data.downscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);
		if (!FlxG.save.data.accuracyDisplay)
			scoreTxt.x = healthBarBG.x + healthBarBG.width / 2;
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		if (offsetTesting)
			scoreTxt.x += 300;
		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (FlxG.save.data.downscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.scrollFactor.set();
		if (loadRep)
			{
				add(replayTxt);
			}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		if (curStage == "garage")
			{
				vignette.cameras = [camHUD];
			}
		else if (curStage == "bawnebyl" && SONG.song.toLowerCase() == "resistance")
			{
				flamebeat.cameras = [camHUD];
			}	

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		if (isStoryMode)
		{
			switch (SONG.cutsceneType)
			{
				case "monster":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play('assets/sounds/Lights_Turn_On' + TitleState.soundExt);
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'angry-senpai':
					FlxG.sound.play('assets/sounds/ANGRY' + TitleState.soundExt);
					schoolIntro(doof);
				case 'spirit':
					schoolIntro(doof);
				case 'none':
					startCountdown();
				default:
					
					schoolIntro(doof);
			}
		}
		else
		{

			startCountdown();
			
		}

		if (!loadRep)
			rep = new Replay("na");

		if (curStage == 'night') {
			phillyCityLights = new FlxTypedGroup<FlxSprite>();
			add(phillyCityLights);

			for (i in 0...4)
			{
				var lightPic:BitmapData;
				if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/light"+i+".png")) {
					lightPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/light"+i+".png");
				} else {
					// fall back on base game file to avoid crashes
					lightPic = BitmapData.fromImage(Assets.getImage("assets/images/philly/win"+i+".png"));
				}

				var light:FlxSprite = new FlxSprite().loadGraphic(lightPic);
				light.scrollFactor.set(0, 0);
				light.cameras = [camHUD];
				light.visible = false;
				light.updateHitbox();
				light.antialiasing = true;
				phillyCityLights.add(light);
			}
		}
		super.create();
		areYouReady = new FlxTypedGroup<FlxSprite>();
		add(areYouReady);
		for (i in 0...3) {
			var shit:FlxSprite = new FlxSprite();
			switch (i) {
				case 0:
					var bgPic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/ARE.png")) {
						bgPic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/ARE.png");
					} else {
						// fall back on base game file to avoid crashes
						bgPic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					shit = new FlxSprite().loadGraphic(bgPic);
				case 1:
					var bg2Pic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/YOU.png")) {
						bg2Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/YOU.png");
					} else {
						// fall back on base game file to avoid crashes
						bg2Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					shit = new FlxSprite().loadGraphic(bg2Pic);
				case 2:
					var bg3Pic:BitmapData;
					if (FileSystem.exists('assets/images/custom_stages/'+SONG.stage+"/READY.png")) {
						bg3Pic = BitmapData.fromFile('assets/images/custom_stages/'+SONG.stage+"/READY.png");
					} else {
						// fall back on base game file to avoid crashes
						bg3Pic = BitmapData.fromImage(Assets.getImage("assets/images/stageback.png"));
					}

					shit = new FlxSprite().loadGraphic(bg3Pic);
			}
			shit.cameras = [camHUD];
			shit.visible = false;
			areYouReady.add(shit);
		} 
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();
		var senpaiSound:Sound;
		// try and find a player2 sound first
		if (FileSystem.exists('assets/images/custom_chars/'+SONG.player2+'/Senpai_Dies.ogg')) {
			senpaiSound = Sound.fromFile('assets/images/custom_chars/'+SONG.player2+'/Senpai_Dies.ogg');
		// otherwise, try and find a song one
		} else if (FileSystem.exists('assets/data/'+SONG.song.toLowerCase()+'/Senpai_Dies.ogg')) {
			senpaiSound = Sound.fromFile('assets/data/'+SONG.song.toLowerCase()+'Senpai_Dies.ogg');
		// otherwise, use the default sound
		} else {
			senpaiSound = Sound.fromFile('assets/sounds/Senpai_Dies.ogg');
		}
		var senpaiEvil:FlxSprite = new FlxSprite();
		// dialog box overwrites character
		trace("YO WE HIT THE POGGERS");
		if (FileSystem.exists('assets/images/custom_ui/dialog_boxes/'+SONG.cutsceneType+'/crazy.png')) {
			var evilImage = BitmapData.fromFile('assets/images/custom_ui/dialog_boxes/'+SONG.cutsceneType+'/crazy.png');
			var evilXml = File.getContent('assets/images/custom_ui/dialog_boxes/'+SONG.cutsceneType+'/crazy.xml');
			senpaiEvil.frames = FlxAtlasFrames.fromSparrow(evilImage, evilXml);
			
		// character then takes precendence over default
		// will make things like monika way way easier
		} else if (FileSystem.exists('assets/images/custom_chars/'+SONG.player2+'/crazy.png')) {

			var evilImage = BitmapData.fromFile('assets/images/custom_chars/'+SONG.player2+'/crazy.png');
			var evilXml = File.getContent('assets/images/custom_chars/'+SONG.player2+'/crazy.xml');
			senpaiEvil.frames = FlxAtlasFrames.fromSparrow(evilImage, evilXml);
		} else {
			
			senpaiEvil.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiCrazy.png', 'assets/images/weeb/senpaiCrazy.xml');
		}

		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		if (dad.isPixel) {
			senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		}
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (dialogueBox != null && dialogueBox.like != 'senpai')
		{
			remove(black);

			if (dialogueBox.like == 'spirit')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (dialogueBox.like == 'spirit')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(senpaiSound, 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);


		if (executeModchart) // dude I hate lua (jkjkjkjk)
			{
				trace('opening a lua state (because we are cool :))');
				lua = LuaL.newstate();
				LuaL.openlibs(lua);
				trace("Lua version: " + Lua.version());
				trace("LuaJIT version: " + Lua.versionJIT());
				Lua.init_callbacks(lua);
				
				var result = LuaL.dofile(lua, Paths.lua(PlayState.SONG.song.toLowerCase() + "/modchart")); // execute le file
	
				if (result != 0)
					throw('COMPILE ERROR\n' + getLuaErrorMessage(lua));

				// get some fukin globals up in here bois
	
				setVar("bpm", Conductor.bpm);
				setVar("fpsCap", FlxG.save.data.fpsCap);
				setVar("downscroll", FlxG.save.data.downscroll);
	
				setVar("curStep", 0);
				setVar("curBeat", 0);
	
				setVar("hudZoom", camHUD.zoom);
				setVar("cameraZoom", FlxG.camera.zoom);
	
				setVar("cameraAngle", FlxG.camera.angle);
				setVar("camHudAngle", camHUD.angle);
	
				setVar("followXOffset",0);
				setVar("followYOffset",0);
	
				setVar("showOnlyStrums", false);
				setVar("strumLine1Visible", true);
				setVar("strumLine2Visible", true);
	
				setVar("screenWidth",FlxG.width);
				setVar("screenHeight",FlxG.height);
				setVar("hudWidth", camHUD.width);
				setVar("hudHeight", camHUD.height);
	
				// callbacks
	
				// sprites
	
				trace(Lua_helper.add_callback(lua,"makeSprite", makeLuaSprite));
	
				Lua_helper.add_callback(lua,"destroySprite", function(id:String) {
					var sprite = luaSprites.get(id);
					if (sprite == null)
						return false;
					remove(sprite);
					return true;
				});
	
				// hud/camera
	
				trace(Lua_helper.add_callback(lua,"setHudPosition", function (x:Int, y:Int) {
					camHUD.x = x;
					camHUD.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudX", function () {
					return camHUD.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getHudY", function () {
					return camHUD.y;
				}));
				
				trace(Lua_helper.add_callback(lua,"setCamPosition", function (x:Int, y:Int) {
					FlxG.camera.x = x;
					FlxG.camera.y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraX", function () {
					return FlxG.camera.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getCameraY", function () {
					return FlxG.camera.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setCamZoom", function(zoomAmount:Int) {
					FlxG.camera.zoom = zoomAmount;
				}));
	
				trace(Lua_helper.add_callback(lua,"setHudZoom", function(zoomAmount:Int) {
					camHUD.zoom = zoomAmount;
				}));
	
				// actors
				
				trace(Lua_helper.add_callback(lua,"getRenderedNotes", function() {
					return notes.length;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteX", function(id:Int) {
					return notes.members[id].x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteY", function(id:Int) {
					return notes.members[id].y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleX", function(id:Int) {
					return notes.members[id].scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteScaleY", function(id:Int) {
					return notes.members[id].scale.y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getRenderedNoteAlpha", function(id:Int) {
					return notes.members[id].alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNotePos", function(x:Int,y:Int, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].x = x;
					notes.members[id].y = y;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteAlpha", function(alpha:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScale", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].setGraphicSize(Std.int(notes.members[id].width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleX", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setRenderedNoteScaleY", function(scale:Float, id:Int) {
					notes.members[id].modifiedByLua = true;
					notes.members[id].scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorX", function(x:Int,id:String) {
					getActorByName(id).x = x;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorAlpha", function(alpha:Int,id:String) {
					getActorByName(id).alpha = alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorY", function(y:Int,id:String) {
					getActorByName(id).y = y;
				}));
							
				trace(Lua_helper.add_callback(lua,"setActorAngle", function(angle:Int,id:String) {
					getActorByName(id).angle = angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScale", function(scale:Float,id:String) {
					getActorByName(id).setGraphicSize(Std.int(getActorByName(id).width * scale));
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleX", function(scale:Float,id:String) {
					getActorByName(id).scale.x = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"setActorScaleY", function(scale:Float,id:String) {
					getActorByName(id).scale.y = scale;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorWidth", function (id:String) {
					return getActorByName(id).width;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorHeight", function (id:String) {
					return getActorByName(id).height;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAlpha", function(id:String) {
					return getActorByName(id).alpha;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorAngle", function(id:String) {
					return getActorByName(id).angle;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorX", function (id:String) {
					return getActorByName(id).x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorY", function (id:String) {
					return getActorByName(id).y;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleX", function (id:String) {
					return getActorByName(id).scale.x;
				}));
	
				trace(Lua_helper.add_callback(lua,"getActorScaleY", function (id:String) {
					return getActorByName(id).scale.y;
				}));
	
				// tweens
				
				Lua_helper.add_callback(lua,"tweenPos", function(id:String, toX:Int, toY:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, y: toY}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosXAngle", function(id:String, toX:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {x: toX, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenPosYAngle", function(id:String, toY:Int, toAngle:Float, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {y: toY, angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenAngle", function(id:String, toAngle:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {angle: toAngle}, time, {ease: FlxEase.cubeIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeIn", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circIn, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				Lua_helper.add_callback(lua,"tweenFadeOut", function(id:String, toAlpha:Int, time:Float, onComplete:String) {
					FlxTween.tween(getActorByName(id), {alpha: toAlpha}, time, {ease: FlxEase.circOut, onComplete: function(flxTween:FlxTween) { if (onComplete != '' && onComplete != null) {callLua(onComplete,[id]);}}});
				});
	
				for (i in 0...strumLineNotes.length) {
					var member = strumLineNotes.members[i];
					trace(strumLineNotes.members[i].x + " " + strumLineNotes.members[i].y + " " + strumLineNotes.members[i].angle + " | strum" + i);
					//setVar("strum" + i + "X", Math.floor(member.x));
					setVar("defaultStrum" + i + "X", Math.floor(member.x));
					//setVar("strum" + i + "Y", Math.floor(member.y));
					setVar("defaultStrum" + i + "Y", Math.floor(member.y));
					//setVar("strum" + i + "Angle", Math.floor(member.angle));
					setVar("defaultStrum" + i + "Angle", Math.floor(member.angle));
					trace("Adding strum" + i);
				}
	
				trace('calling start function');
	
				trace('return: ' + Lua.tostring(lua,callLua('start', [PlayState.SONG.song])));
			}

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('normal', ['ready.png', "set.png", "go.png"]);
			introAssets.set('pixel', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);
			for (field in CoolUtil.coolTextFile('assets/data/uitypes.txt')) {
				if (field != 'pixel' && field != 'normal') {
					if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
						introAssets.set(field, ['custom_ui/ui_packs/'+field+'/ready-pixel.png','custom_ui/ui_packs/'+field+'/set-pixel.png','custom_ui/ui_packs/'+field+'/date-pixel.png']);
					else
						introAssets.set(field, ['custom_ui/ui_packs/'+field+'/ready.png','custom_ui/ui_packs/'+field+'/set.png','custom_ui/ui_packs/'+field+'/go.png']);
				}
			}

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";
			var intro3Sound:Sound;
			var intro2Sound:Sound;
			var intro1Sound:Sound;
			var introGoSound:Sound;
			for (value in introAssets.keys())
				{
					if (value == SONG.uiType)
					{
						introAlts = introAssets.get(value);
						// ok so apparently a leading slash means absolute soooooo
						if (SONG.uiType == 'pixel' || FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
							altSuffix = '-pixel';
					}
				}	
				if (SONG.uiType == 'normal') {
					intro3Sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/intro3.ogg')));
					intro2Sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/intro2.ogg')));
					intro1Sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/intro1.ogg')));
					introGoSound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/introGo.ogg')));
				} else if (SONG.uiType == 'pixel') {
					intro3Sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/intro3-pixel.ogg')));
					intro2Sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/intro2-pixel.ogg')));
					intro1Sound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/intro1-pixel.ogg')));
					introGoSound = Sound.fromAudioBuffer(AudioBuffer.fromBytes(Assets.getBytes('assets/sounds/introGo-pixel.ogg')));
				} else {
					// god is dead for we have killed him
					intro3Sound = Sound.fromFile("assets/images/custom_ui/ui_packs/"+SONG.uiType+'/intro3'+altSuffix+'.ogg');
					intro2Sound = Sound.fromFile("assets/images/custom_ui/ui_packs/"+SONG.uiType+'/intro2'+altSuffix+'.ogg');
					intro1Sound = Sound.fromFile("assets/images/custom_ui/ui_packs/"+SONG.uiType+'/intro1'+altSuffix+'.ogg');
					// apparently this crashes if we do it from audio buffer?
					// no it just understands 'hey that file doesn't exist better do an error'
					introGoSound = Sound.fromFile("assets/images/custom_ui/ui_packs/"+SONG.uiType+'/introGo'+altSuffix+'.ogg');
				}
				switch (swagCounter)

				{
					case 0:
						FlxG.sound.play(intro3Sound, 0.6);
					case 1:
						// my life is a lie, it was always this simple
						var readyImage = BitmapData.fromFile('assets/images/'+introAlts[0]);
						var ready:FlxSprite = new FlxSprite().loadGraphic(readyImage);
						ready.scrollFactor.set();
						ready.updateHitbox();
	
						if (SONG.uiType == 'pixel' || FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
							ready.setGraphicSize(Std.int(ready.width * daPixelZoom));
	
						ready.screenCenter();
						add(ready);
						FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								ready.destroy();
							}
						});
						FlxG.sound.play(intro2Sound, 0.6);
					case 2:
						var setImage = BitmapData.fromFile('assets/images/'+introAlts[1]);
						// can't believe you can actually use this as a variable name
						var set:FlxSprite = new FlxSprite().loadGraphic(setImage);
						set.scrollFactor.set();
	
						if (SONG.uiType == 'pixel' || FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
							set.setGraphicSize(Std.int(set.width * daPixelZoom));
	
						set.screenCenter();
						add(set);
						FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								set.destroy();
							}
						});
						FlxG.sound.play(intro1Sound, 0.6);
					case 3:
						var goImage = BitmapData.fromFile('assets/images/'+introAlts[2]);
						var go:FlxSprite = new FlxSprite().loadGraphic(goImage);
						go.scrollFactor.set();
	
						if (SONG.uiType == 'pixel' || FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
							go.setGraphicSize(Std.int(go.width * daPixelZoom));
	
						go.updateHitbox();
	
						go.screenCenter();
						add(go);
						FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								go.destroy();
							}
						});
						FlxG.sound.play(introGoSound, 0.6);
					case 4:
						// what is this here for?
				}
	

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Sound.fromFile(Paths.inst(PlayState.SONG.song)), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (FlxG.save.data.downscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - 20,songPosBG.y,0,SONG.song, 16);
			if (FlxG.save.data.downscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Sound.fromFile(Paths.voices(PlayState.SONG.song)));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			var songPath = 'assets/data/' + PlayState.SONG.song.toLowerCase() + '/';
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		var customImage:Null<BitmapData> = null;
		var customXml:Null<String> = null;
		var arrowEndsImage:Null<BitmapData> = null;
		if (SONG.uiType != 'normal' && SONG.uiType != 'pixel') {
			if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/NOTE_assets.xml") && FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/NOTE_assets.png")) {
				trace("has this been reached");
				customImage = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+SONG.uiType+'/NOTE_assets.png');
				customXml = File.getContent('assets/images/custom_ui/ui_packs/'+SONG.uiType+'/NOTE_assets.xml');
			} else {
				customImage = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+SONG.uiType+'/arrows-pixels.png');
				arrowEndsImage = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+SONG.uiType+'/arrowEnds.png');
			}
		}
		for (section in noteData)
		{
			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;
				var altNote:Bool = false;

				if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
					if (songNotes[3] || section.altAnim)
					{
						altNote = true;
					}
	
				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, customImage, customXml, arrowEndsImage);
				// alt note
				swagNote.altNote = altNote;



				
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, customImage, customXml, arrowEndsImage);

					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;
	// to get around how pecked up the note system is

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{var flippedNotes = false;
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (SONG.uiType)
			{
				case 'pixel':
					babyArrow.loadGraphic('assets/images/weeb/pixelUI/arrows-pixels.png', true, 17, 17);
					babyArrow.animation.add('green', [6]);
					babyArrow.animation.add('red', [7]);
					babyArrow.animation.add('blue', [5]);
					babyArrow.animation.add('purplel', [4]);
					if (flippedNotes) {
						babyArrow.animation.add('blue', [6]);
						babyArrow.animation.add('purplel', [7]);
						babyArrow.animation.add('green', [5]);
						babyArrow.animation.add('red', [4]);
					}
					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.add('static', [2]);
							babyArrow.animation.add('pressed', [6, 10], 12, false);
							babyArrow.animation.add('confirm', [14, 18], 12, false);
							if (flippedNotes) {
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 12, false);
							}
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.add('static', [3]);
							babyArrow.animation.add('pressed', [7, 11], 12, false);
							babyArrow.animation.add('confirm', [15, 19], 24, false);
							if (flippedNotes) {
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
							}
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.add('static', [1]);
							babyArrow.animation.add('pressed', [5, 9], 12, false);
							babyArrow.animation.add('confirm', [13, 17], 24, false);
							if (flippedNotes) {
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
							}
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.add('static', [0]);
							babyArrow.animation.add('pressed', [4, 8], 12, false);
							babyArrow.animation.add('confirm', [12, 16], 24, false);
							if (flippedNotes) {
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
							}
					}

				case 'normal': 
					babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
					if (flippedNotes) {
						babyArrow.animation.addByPrefix('blue', 'arrowUP');
						babyArrow.animation.addByPrefix('green', 'arrowDOWN');
						babyArrow.animation.addByPrefix('red', 'arrowLEFT');
						babyArrow.animation.addByPrefix('purple', 'arrowRIGHT');
					}
					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							if (flippedNotes) {
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							}
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							if (flippedNotes) {
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							}
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
							if (flippedNotes) {
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
							}
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
							if (flippedNotes) {
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
							}
					}
			default:
					
					if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/NOTE_assets.xml") && FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/NOTE_assets.png")) {

					  var noteXml = File.getContent('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/NOTE_assets.xml");
						var notePic = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/NOTE_assets.png");
						babyArrow.frames = FlxAtlasFrames.fromSparrow(notePic, noteXml);
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
								if (flippedNotes) {
							babyArrow.animation.addByPrefix('blue', 'arrowUP');
							babyArrow.animation.addByPrefix('green', 'arrowDOWN');
							babyArrow.animation.addByPrefix('red', 'arrowLEFT');
							babyArrow.animation.addByPrefix('purple', 'arrowRIGHT');
						}
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								}
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								}
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								}
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
						}

					} else if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png")){
						var notePic = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png");
						babyArrow.loadGraphic(notePic, true, 17, 17);
						babyArrow.animation.add('green', [6]);
						babyArrow.animation.add('red', [7]);
						babyArrow.animation.add('blue', [5]);
						babyArrow.animation.add('purplel', [4]);
						if (flippedNotes) {
							babyArrow.animation.add('blue', [6]);
							babyArrow.animation.add('purplel', [7]);
							babyArrow.animation.add('green', [5]);
							babyArrow.animation.add('red', [4]);
						}
						babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom));
						babyArrow.updateHitbox();
						babyArrow.antialiasing = false;

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.add('static', [2]);
								babyArrow.animation.add('pressed', [6, 10], 12, false);
								babyArrow.animation.add('confirm', [14, 18], 12, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [1]);
									babyArrow.animation.add('pressed', [5, 9], 12, false);
									babyArrow.animation.add('confirm', [13, 17], 12, false);
								}
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.add('static', [3]);
								babyArrow.animation.add('pressed', [7, 11], 12, false);
								babyArrow.animation.add('confirm', [15, 19], 24, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [0]);
									babyArrow.animation.add('pressed', [4, 8], 12, false);
									babyArrow.animation.add('confirm', [12, 16], 24, false);
								}
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.add('static', [1]);
								babyArrow.animation.add('pressed', [5, 9], 12, false);
								babyArrow.animation.add('confirm', [13, 17], 24, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [2]);
									babyArrow.animation.add('pressed', [6, 10], 12, false);
									babyArrow.animation.add('confirm', [14, 18], 12, false);
								}
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.add('static', [0]);
								babyArrow.animation.add('pressed', [4, 8], 12, false);
								babyArrow.animation.add('confirm', [12, 16], 24, false);
								if (flippedNotes) {
									babyArrow.animation.add('static', [3]);
									babyArrow.animation.add('pressed', [7, 11], 12, false);
									babyArrow.animation.add('confirm', [15, 19], 24, false);
								}
						}
					} else {
						// no crashing today :)
						babyArrow.frames = FlxAtlasFrames.fromSparrow('assets/images/NOTE_assets.png', 'assets/images/NOTE_assets.xml');
						babyArrow.animation.addByPrefix('green', 'arrowUP');
						babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
						babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
						babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
						if (flippedNotes) {
							babyArrow.animation.addByPrefix('blue', 'arrowUP');
							babyArrow.animation.addByPrefix('green', 'arrowDOWN');
							babyArrow.animation.addByPrefix('red', 'arrowLEFT');
							babyArrow.animation.addByPrefix('purple', 'arrowRIGHT');
						}
						babyArrow.antialiasing = true;
						babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

						switch (Math.abs(i))
						{
							case 2:
								babyArrow.x += Note.swagWidth * 2;
								babyArrow.animation.addByPrefix('static', 'arrowUP');
								babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowDOWN');
									babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								}
							case 3:
								babyArrow.x += Note.swagWidth * 3;
								babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
								babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowLEFT');
									babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								}
							case 1:
								babyArrow.x += Note.swagWidth * 1;
								babyArrow.animation.addByPrefix('static', 'arrowDOWN');
								babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowUP');
									babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
								}
							case 0:
								babyArrow.x += Note.swagWidth * 0;
								babyArrow.animation.addByPrefix('static', 'arrowLEFT');
								babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
								babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
								if (flippedNotes) {
									babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
									babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
									babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
								}
						}
					}
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}else
			{
				player2Strums.add(babyArrow);

			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat( number : Float, precision : Int): Float {
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round( num ) / Math.pow(10, precision);
		return num;
		}


	function generateRanking():String
	{
		var ranking:String = "N/A";

		if (misses == 0 && bads == 0 && shits == 0 && goods == 0) // Marvelous (SICK) Full Combo
			ranking = "(MFC)";
		else if (misses == 0 && bads == 0 && shits == 0 && goods >= 1) // Good Full Combo (Nothing but Goods & Sicks)
			ranking = "(GFC)";
		else if (misses == 0) // Regular FC
			ranking = "(FC)";
		else if (misses < 10) // Single Digit Combo Breaks
			ranking = "(SDCB)";
		else
			ranking = "(Clear)";

		// WIFE TIME :)))) (based on Wife3)

		var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for(i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch(i)
				{
					case 0:
						ranking += " AAAAA";
					case 1:
						ranking += " AAAA:";
					case 2:
						ranking += " AAAA.";
					case 3:
						ranking += " AAAA";
					case 4:
						ranking += " AAA:";
					case 5:
						ranking += " AAA.";
					case 6:
						ranking += " AAA";
					case 7:
						ranking += " AA:";
					case 8:
						ranking += " AA.";
					case 9:
						ranking += " AA";
					case 10:
						ranking += " A:";
					case 11:
						ranking += " A.";
					case 12:
						ranking += " A";
					case 13:
						ranking += " B";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}

		if (accuracy == 0)
			ranking = "N/A";

		return ranking;
	}

	public static var songRate = 1.5;

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;
		if (curbg != null)
		{
			if (curbg.active) //only the furiosity background is active
			{
			var shad = cast(curbg.shader,Shaders.GlitchShader);
			shad.uTime.value[0] += elapsed;
			}
		}
		if(SONG.song.toLowerCase() == 'furiosity')
		{
			dad.y += (Math.sin(elapsedtime) * 0.2);
		}
		if (shakeCam)
		{
			FlxG.camera.shake(0.05, 0.05);
		}
		if (vibrateCam)
		{
			FlxG.camera.shake(0.009, 0.009);
		}
		if (daveCam)
		{
			FlxG.camera.shake(0.015, 0.015);
		}
		if(controls.RESET && FlxG.save.data.resetKey){
			FlxG.resetState();
		}
		floatshit += 0.1;
			
	
		#if !debug
		perfectMode = false;
		#end

		if (executeModchart && lua != null && songStarted)
		{
			setVar('songPos',Conductor.songPosition);
			setVar('hudZoom', camHUD.zoom);
			setVar('cameraZoom',FlxG.camera.zoom);
			callLua('update', [elapsed]);

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = getVar("strum" + i + "X", "float");
				member.y = getVar("strum" + i + "Y", "float");
				member.angle = getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = getVar('cameraAngle', 'float');
			camHUD.angle = getVar('camHudAngle','float');

			if (getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = getVar("strumLine1Visible",'bool');
			var p2 = getVar("strumLine2Visible",'bool');

			for (i in 0...4)
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}
		}

		if (currentFrames == FlxG.save.data.fpsCap)
		{
			for(i in 0...notesHitArray.length)
			{
				var cock:Date = notesHitArray[i];
				if (cock != null)
					if (cock.getTime() + 2000 < Date.now().getTime())
						notesHitArray.remove(cock);
			}
			nps = Math.floor(notesHitArray.length / 2);
			currentFrames = 0;
		}
		else
			currentFrames++;

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}
		if(SONG.song.toLowerCase() == "splitathon")
			{
				switch(curStep)
				{
					case 4736:
						dad.visible = false;
						lookup.visible = true;
					case 4800:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						backup.visible = true;
						lookup.visible = false;
						santa.visible = true;
						if (BAMBICUTSCENEICONHURHURHUR == null)
						{
						BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi-new", false);
						BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
						add(BAMBICUTSCENEICONHURHURHUR);
						BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
						BAMBICUTSCENEICONHURHURHUR.x = -100;
						FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR,-100,BAMBICUTSCENEICONHURHURHUR.y,iconP2.x,BAMBICUTSCENEICONHURHURHUR.y,0.3);
						new FlxTimer().start(0.3,FlingCharacterIconToOblivionAndBeyond);
						}
					case 5824:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						backup.visible = false;
						santa.visible = false;
						dad.visible = true;
						iconP2.animation.play("dave-splitathon",true);
					case 6080:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						end.visible = true;
						santa.visible = true;
						dad.visible = false;
						iconP2.animation.play("bambi-new",true);
					case 8384:
						FlxG.camera.flash(FlxColor.WHITE, 1);
						end.visible = false;
						santa.visible = false;
						dad.visible = true;
						iconP2.animation.play("dave-splitathon",true);
				}
			}
	
		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
			case 'rucksburg':
				zball.animation.play('zball', false);
				// exterminator.animation.play('exterminator', false);
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		if (!offsetTesting)
		{
			if (FlxG.save.data.accuracyDisplay)
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + (Conductor.safeFrames != 10 ? songScore + " (" + songScoreDef + ")" : "" + songScore) + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + "% | " + generateRanking();
			}
			else
			{
				scoreTxt.text = (FlxG.save.data.npsDisplay ? "NPS: " + nps + " | " : "") + "Score:" + songScore;
			}
		}
		else
		{
			scoreTxt.text = "Suggested Offset: " + offsetTest;

		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);
		if (dad.curCharacter == "hellcarol"){
			dad.y += Math.sin(floatshit);
		}

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */


		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.switchState(new AnimationDebug(SONG.player2));
			if (lua != null)
			{
				Lua.close(lua);
				lua = null;
			}
		}
		
	

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			switch (curStage) {
				case 'cyb':
					if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !phillyCityLights.members[1].visible)
					{
						phillyCityLights.members[1].visible = true;
						phillyCityLights.members[0].visible = false;
					} else if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !phillyCityLights.members[0].visible)
					{
						phillyCityLights.members[1].visible = false;
						phillyCityLights.members[0].visible = true;
					}
			}

			
			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
				{
					if (curBeat % 4 == 0)
					{
						// trace(PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection);
					}
		
					if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
						camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
						// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
						if (dad.like == 'mom')
							camFollow.y = dad.getMidpoint().y;
						if (dad.like == 'rad')
							camFollow.y = dad.getMidpoint().y;
						if (dad.like == 'senpai' || dad.like == 'senpai-angry') 
							camFollow.y = dad.getMidpoint().y - 430;
							camFollow.x = dad.getMidpoint().x - 100;
						if (dad.like == 'cybbr' || dad.like == 'cybbr-golden') {
							camFollow.y = dad.getMidpoint().y - 100;
							camFollow.x = dad.getMidpoint().x - 300;
						}
						if (dad.isCustom) {
							camFollow.y = dad.getMidpoint().y + dad.followCamY;
							camFollow.x = dad.getMidpoint().x + dad.followCamX;
						}
						switch (curStage)
						{
							case 'ego':
								camFollow.y = 546.65;
								camFollow.x = 574.38;
							case 'ridzak':
								camFollow.y = 546.65;
								camFollow.x = 574.38;
							case 'day':
								camFollow.x = 536.63;
								camFollow.y = 449.94;
							case 'sunset':
								camFollow.x = 536.63;
								camFollow.y = 300.94;
							case 'night':
								camFollow.x = 295.92;
								camFollow.y = 447.52;
			
							
						}
		
						vocals.volume = 1;
		
						if (SONG.song.toLowerCase() == 'tutorial')
						{
							tweenCamIn();
						}
						switch (curStage)
						{
							case 'rucksburg':
								camFollow.y = camFollow.y - 100;
							case 'bawnebyl':
								camFollow.y = camFollow.y - 200;
						}
		
					}
		
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
					{
						camFollow.setPosition((boyfriend.getMidpoint().x - 100), (boyfriend.getMidpoint().y - 100));
		
						switch (curStage)
						{
							// not sure that's how variable assignment works
							case 'limo':
								((camFollow.x = boyfriend.getMidpoint().x - 300) + boyfriend.followCamX); // why are you hard coded
							case 'mall':
								((camFollow.y = boyfriend.getMidpoint().y - 200) + boyfriend.followCamY);
							case 'school':
								((camFollow.x = boyfriend.getMidpoint().x - 200) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 200) + boyfriend.followCamY);
							case 'schoolEvil':
								((camFollow.x = boyfriend.getMidpoint().x - 200) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 200) + boyfriend.followCamY);
							case 'ego':
								((camFollow.x = boyfriend.getMidpoint().x - 386.56) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 250.85) + boyfriend.followCamY);
							case 'ridzak':
								((camFollow.x = boyfriend.getMidpoint().x - 386.56) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 250.85) + boyfriend.followCamY);
							case 'cyb':
								((camFollow.x = boyfriend.getMidpoint().x - 300.56) + boyfriend.followCamX);
							case 'garage':
								((camFollow.x = boyfriend.getMidpoint().x - 210) + boyfriend.followCamX);
							case 'rucksburg':
								((camFollow.x = boyfriend.getMidpoint().x - 230) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 110) + boyfriend.followCamX);
							case 'bawnebyl':
								((camFollow.x = boyfriend.getMidpoint().x - 230) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 210) + boyfriend.followCamX);
							case 'day' | 'sunset':
								((camFollow.x = boyfriend.getMidpoint().x - 400) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 170) + boyfriend.followCamX);
							case 'night':
								((camFollow.x = boyfriend.getMidpoint().x - 400) + boyfriend.followCamX);
								((camFollow.y = boyfriend.getMidpoint().y - 170) + boyfriend.followCamX);
							case 'violastroStage':
								((camFollow.y = boyfriend.getMidpoint().y - 300) + boyfriend.followCamX);
			
															
			

			
						}
		
						if (boyfriend.isCustom) {
							camFollow.y = boyfriend.getMidpoint().y + boyfriend.followCamY;
							camFollow.x = boyfriend.getMidpoint().x + boyfriend.followCamX;
		
						}
		
						if (SONG.song.toLowerCase() == 'tutorial')
						{
							FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
						}
					}
				}
		}
		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		if (loadRep) // rep debug
			{
				FlxG.watch.addQuick('rep rpesses',repPresses);
				FlxG.watch.addQuick('rep releases',repReleases);
				// FlxG.watch.addQuick('Queued',inputsQueued);
			}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;
			deathCounter++;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(),"\nAcc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{	
					if (daNote.y > FlxG.height)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
	
					if (!daNote.modifiedByLua)
						{
							if (FlxG.save.data.downscroll)
							{
								daNote.y = (strumLine.y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if(daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
	
									if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
									{
										// Clip to strumline
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLine.y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
	
										daNote.clipRect = swagRect;
									}
								}
							}else
							{
								daNote.y = (strumLine.y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
								if(daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
	
									if((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
									{
										// Clip to strumline
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLine.y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
	
										daNote.clipRect = swagRect;
									}
								}
							}
						}
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						dad.altAnim = "";

						if (daNote.altNote)
							{
								dad.altAnim = '-alt';
							}		
						if (SONG.notes[Math.floor(curStep / 16)] != null)
							{
								if ((SONG.notes[Math.floor(curStep / 16)].altAnimNum > 0 && SONG.notes[Math.floor(curStep / 16)].altAnimNum != null) || SONG.notes[Math.floor(curStep / 16)].altAnim)
									// backwards compatibility shit
								if (SONG.notes[Math.floor(curStep / 16)].altAnimNum == 1 || SONG.notes[Math.floor(curStep / 16)].altAnim || daNote.altNote)
									dad.altAnim = '-alt';
									else if (SONG.notes[Math.floor(curStep / 16)].altAnimNum != 0)
										dad.altAnim = '-' + SONG.notes[Math.floor(curStep / 16)].altAnimNum+'alt';
								}
								if (dust != null){
									dust.animation.play("bop", true);
								}
						
								if (SONG.song.toLowerCase() == "momi-roll"){
									if (curBeat == 132) FlxG.sound.play(Paths.sound("carPass1"));
									
									if(curBeat == 136){
										car.visible = true;
										car.animation.play("go", true);
										dust.visible = true;
										dust.alpha = 0;
										FlxTween.tween(dust, {alpha:1}, 0.5);
									}
								}
						
								if (SONG.song.toLowerCase() == "neko"){
									if(curBeat == 8){
										carhit.visible = true;
										carhit.animation.play("hit", true);
									}
								}
						
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP' + dad.altAnim, true);
							case 3:
								dad.playAnim('singRIGHT' + dad.altAnim, true);
							case 1:
								dad.playAnim('singDOWN' + dad.altAnim, true);
							case 0:
								dad.playAnim('singLEFT' + dad.altAnim, true);
						}

						player2Strums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm');
									sustainplayer2(spr.ID, spr, daNote);
								}
							});
	
	
						dad.holdTimer = -0.7;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					
					player2Strums.forEach(function(spr:FlxSprite)
						{
							if (opponentKeyStatus[spr.ID])
							{
								spr.animation.play("confirm");
							}
	
							if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
							{
								spr.centerOffsets();
								spr.offset.x -= 13;
								spr.offset.y -= 13;
							}
							else
								spr.centerOffsets();
						});
	
	
					if (FlxG.save.data.downscroll)
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (-0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));
					else
						daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2)));

					if (daNote.mustPress && !daNote.modifiedByLua)
					{
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
					{
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote)
							daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					
					

					if (daNote.isSustainNote)
						daNote.x += daNote.width / 2 + 17;
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if ((daNote.y < -daNote.height && !FlxG.save.data.downscroll || daNote.y >= strumLine.y + 106 && FlxG.save.data.downscroll) && daNote.mustPress)
					{

							if (daNote.isSustainNote && daNote.wasGoodHit)
							{
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
							else
							{
								health -= 0.075;
								vocals.volume = 0;

								noteMiss(daNote.noteData, daNote);
							}
						
						daNote.active = false;
						daNote.visible = false;
	
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				});
			}


		if (!inCutscene)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end

		#if debug
		if (FlxG.keys.justPressed.TWO)
		{
			BAMBICUTSCENEICONHURHURHUR = new HealthIcon("bambi-new", false);
			BAMBICUTSCENEICONHURHURHUR.y = healthBar.y - (BAMBICUTSCENEICONHURHURHUR.height / 2);
			add(BAMBICUTSCENEICONHURHURHUR);
			BAMBICUTSCENEICONHURHURHUR.cameras = [camHUD];
			BAMBICUTSCENEICONHURHURHUR.x = -100;
			FlxTween.linearMotion(BAMBICUTSCENEICONHURHURHUR,-100,BAMBICUTSCENEICONHURHURHUR.y,iconP2.x,BAMBICUTSCENEICONHURHURHUR.y,0.3);
			new FlxTimer().start(0.3,FlingCharacterIconToOblivionAndBeyond);
		}
		#end
		if (updatevels)
		{
			stupidx *= 0.98;
			stupidy += elapsed * 6;
			if (BAMBICUTSCENEICONHURHURHUR != null)
			{
				BAMBICUTSCENEICONHURHURHUR.x += stupidx;
				BAMBICUTSCENEICONHURHURHUR.y += stupidy;
			}
		}

	}
	
	function FlingCharacterIconToOblivionAndBeyond(e:FlxTimer=null):Void
		{
			iconP2.animation.play("bambi-new",true);
			BAMBICUTSCENEICONHURHURHUR.animation.play(SONG.player2,true,false,1);
			stupidx = -5;
			stupidy = -5;
			updatevels = true;
		}
	
	function sustainplayer2(strum:Int, spr:FlxSprite, note:Note):Void
		{
			var length:Float = note.sustainLength;
			var tempo:Float = Conductor.bpm / 60;
			var temp:Float = 1 / tempo;
	
			if (length > 0)
				opponentKeyStatus[strum] = true;
	
			if (!note.isSustainNote)
			{
				new FlxTimer().start(length == 0 ? 0.2 : (length / Conductor.crochet * temp) + 0.1, function(tmr:FlxTimer)
				{
					if (!opponentKeyStatus[strum])
						spr.animation.play("static", true);
					else if (length > 0)
					{
						opponentKeyStatus[strum] = false;
						spr.animation.play("static", true);
					}
				});
			}
		}
	

	function endSong():Void
	{
		if (!loadRep)
			rep.SaveReplay();

		if (executeModchart)
		{
			Lua.close(lua);
			lua = null;
		}

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		deathCounter = 0;

		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;

					FlxG.switchState(new StoryMenuState());

					if (lua != null)
					{
						Lua.close(lua);
						lua = null;
					}

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = "";

					difficulty = DifficultyIcons.getEndingFP(storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				var parsed:Dynamic = CoolUtil.parseJson(File.getContent('assets/data/freeplaySongJson.jsonc'));
				changedDifficulty = false;
				if(parsed.length==1){
					FreeplayState.id = 0;
					FlxG.switchState(new FreeplayState());
				}else{
					FlxG.switchState(new FreeplayCategory());
				}
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(Conductor.songPosition - daNote.strumTime);
			var wife:Float = EtternaFunctions.wife3(noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1){
				totalNotesHit += wife;
			}else if (FlxG.save.data.accuracyMod == 2){
				totalNotesHit+=1;
			}
			var daRating = daNote.rating;
			
				switch(daRating)
				{
					case 'shit':
						score = -300;
						combo = 0;
						misses++;
						health -= 0.2;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.25;
					case 'bad':
						daRating = 'bad';
						score = 0;
						health -= 0.06;
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					case 'good':
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					case 'sick':
						{
							if (health < 2)
								health += 0.1;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 1;
		
							sicks++;
						}
				}
			
			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			 var pixelShitPart1:String = "";
			 var pixelShitPart2:String = '';
			 if (FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png")) {
				 pixelShitPart2 = '-pixel';
			 }
			 var ratingImage:BitmapData;
			 switch (SONG.uiType) {
				 case 'pixel':
					 ratingImage = BitmapData.fromBytes(ByteArray.fromBytes(Assets.getBytes('assets/images/weeb/pixelUI/'+daRating+'-pixel.png')));
				 case 'normal':
					 ratingImage = BitmapData.fromBytes(ByteArray.fromBytes(Assets.getBytes('assets/images/'+daRating+'.png')));
				 default:
					 ratingImage = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+PlayState.SONG.uiType+'/'+daRating+pixelShitPart2+".png");
					 }
	
			rating.loadGraphic(ratingImage);
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			
			var msTiming = truncateFloat(noteDiff, 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			add(currentTimingShown);
			


			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(ratingImage);
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			add(rating);
	
			// gonna be fun explaining this
			if (SONG.uiType != 'pixel' && !FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = true;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = true;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

	
			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numImage:BitmapData;
				switch (SONG.uiType) {
					case 'pixel':
						numImage = BitmapData.fromBytes(ByteArray.fromBytes(Assets.getBytes('assets/images/weeb/pixelUI/num'+Std.int(i)+'-pixel.png')));
					case 'normal':
						numImage = BitmapData.fromBytes(ByteArray.fromBytes(Assets.getBytes('assets/images/num'+Std.int(i)+'.png')));
					default:
						numImage = BitmapData.fromFile('assets/images/custom_ui/ui_packs/'+SONG.uiType+'/num'+Std.int(i)+pixelShitPart2+".png");
					}
	
				var numScore:FlxSprite = new FlxSprite().loadGraphic(numImage);
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (SONG.uiType != 'pixel' && !FileSystem.exists('assets/images/custom_ui/ui_packs/'+SONG.uiType+"/arrows-pixels.png"))
				{
					numScore.antialiasing = true;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;	

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		if (loadRep) // replay code
		{
			// disable input
			up = false;
			down = false;
			right = false;
			left = false;

			// new input


			//if (rep.replay.keys[repPresses].time == Conductor.songPosition)
			//	trace('DO IT!!!!!');

			//timeCurrently = Math.abs(rep.replay.keyPresses[repPresses].time - Conductor.songPosition);
			//timeCurrentlyR = Math.abs(rep.replay.keyReleases[repReleases].time - Conductor.songPosition);

			
			if (repPresses < rep.replay.keyPresses.length && repReleases < rep.replay.keyReleases.length)
			{
				upP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "up";
				rightP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "right";
				downP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition && rep.replay.keyPresses[repPresses].key == "down";
				leftP = rep.replay.keyPresses[repPresses].time + 1 <= Conductor.songPosition  && rep.replay.keyPresses[repPresses].key == "left";	

				upR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "up";
				rightR = rep.replay.keyPresses[repReleases].time - 1 <= Conductor.songPosition  && rep.replay.keyReleases[repReleases].key == "right";
				downR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "down";
				leftR = rep.replay.keyPresses[repReleases].time - 1<= Conductor.songPosition && rep.replay.keyReleases[repReleases].key == "left";

				upHold = upP ? true : upR ? false : true;
				rightHold = rightP ? true : rightR ? false : true;
				downHold = downP ? true : downR ? false : true;
				leftHold = leftP ? true : leftR ? false : true;
			}
		}
		else if (!loadRep) // record replay code
		{
			if (upP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "up"});
			if (rightP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "right"});
			if (downP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "down"});
			if (leftP)
				rep.replay.keyPresses.push({time: Conductor.songPosition, key: "left"});

			if (upR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "up"});
			if (rightR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "right"});
			if (downR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "down"});
			if (leftR)
				rep.replay.keyReleases.push({time: Conductor.songPosition, key: "left"});
		}
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
			{
				repPresses++;
				boyfriend.holdTimer = 0;
	
				var possibleNotes:Array<Note> = [];
	
				var ignoreList:Array<Int> = [];
	
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
					{
						// the sorting probably doesn't need to be in here? who cares lol
						possibleNotes.push(daNote);
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
						ignoreList.push(daNote.noteData);
					}
				});
	
				
				if (possibleNotes.length > 0)
				{
					var daNote = possibleNotes[0];
	
					// Jump notes
					if (possibleNotes.length >= 2)
					{
						if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
						{
							for (coolNote in possibleNotes)
							{

								if (controlArray[coolNote.noteData])
									goodNoteHit(coolNote);
								else
								{
									var inIgnoreList:Bool = false;
									for (shit in 0...ignoreList.length)
									{
										if (controlArray[ignoreList[shit]])
											inIgnoreList = true;
									}
									if (!inIgnoreList && !isNew){
										badNoteCheck(coolNote);		
									}					
								}
							}
						}
						else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
						{
							if (loadRep)
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
								{
									goodNoteHit(daNote);
									trace('force note hit');
								}
								else
									noteCheck(controlArray, daNote);
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
						{
							for (coolNote in possibleNotes)
							{
								if (loadRep)
									{
										if (NearlyEquals(coolNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
										{
											var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);

											if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
												coolNote.rating = "shit";
											else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
												coolNote.rating = "bad";
											else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
												coolNote.rating = "good";
											else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
												coolNote.rating = "sick";
											goodNoteHit(coolNote);
											trace('force note hit');
										}
										else
											noteCheck(controlArray, daNote);
									}
								else
									noteCheck(controlArray, coolNote);
							}
						}
					}
					else // regular notes?
					{	
						if (loadRep)
						{
							if (NearlyEquals(daNote.strumTime,rep.replay.keyPresses[repPresses].time, 30))
							{
								var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);

								daNote.rating = Ratings.CalculateRating(noteDiff);

								goodNoteHit(daNote);
								trace('force note hit');
							}
							else
								noteCheck(controlArray, daNote);
						}
						else
							noteCheck(controlArray, daNote);
					}
					/* 
						if (controlArray[daNote.noteData])

					 */
					// trace(daNote.noteData);
					/* 
						switch (daNote.noteData)

						}
					 */
					if (daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
				else if(!isNew){
					badNoteCheck(null);
				}
			}
	
			if ((up || right || down || left) && generatedMusic || (upHold || downHold || leftHold || rightHold) && loadRep && generatedMusic)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
					{
						switch (daNote.noteData)
						{
							// NOTES YOU ARE HOLDING
							case 2:
								if (up || upHold)
									goodNoteHit(daNote);
							case 3:
								if (right || rightHold)
									goodNoteHit(daNote);
							case 1:
								if (down || downHold)
									goodNoteHit(daNote);
							case 0:
								if (left || leftHold)
									goodNoteHit(daNote);
						}
					}
				});
			}
	
			if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
			{
				if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.dance();
				}
			}
	
				playerStrums.forEach(function(spr:FlxSprite)
				{
					switch (spr.ID)
					{
						case 2:
							if (loadRep)
							{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
							}
							else
							{
								if (upP && spr.animation.curAnim.name != 'confirm' && !loadRep)
								{
									spr.animation.play('pressed');
									trace('play');
								}
								if (upR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 3:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (rightP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (rightR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}	
						case 1:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (downP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (downR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
						case 0:
							if (loadRep)
								{
								/*if (upP)
								{
									spr.animation.play('pressed');
									new FlxTimer().start(Math.abs(rep.replay.keyPresses[repReleases].time - Conductor.songPosition) + 10, function(tmr:FlxTimer)
										{
											spr.animation.play('static');
											repReleases++;
										});
								}*/
								}
							else
							{
								if (leftP && spr.animation.curAnim.name != 'confirm' && !loadRep)
									spr.animation.play('pressed');
								if (leftR)
								{
									spr.animation.play('static');
									repReleases++;
								}
							}
					}
					
					if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
					{
						spr.centerOffsets();
						spr.offset.x -= 13;
						spr.offset.y -= 13;
					}
					else
						spr.centerOffsets();
				});
	}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{	
		if (!boyfriend.stunned)
		{
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;
			if(daNote != null){
				var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
				var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

				if (FlxG.save.data.accuracyMod == 1)
					totalNotesHit += wife;

			}
			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			switch (direction)
			{
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}

			updateAccuracy();
		}
	}

	function badNoteCheck(daNote:Note)
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0,daNote);
			if (upP)
				noteMiss(2,daNote);
			if (rightP)
				noteMiss(3,daNote);
			if (downP)
				noteMiss(1,daNote);
			if(FlxG.save.data.accuracyMod!=2){
				updateAccuracy();
			}
		}
	
	function updateAccuracy() 
{
				totalPlayed += 1;
				accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
				accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
			
			
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{

			var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

			if (noteDiff > Conductor.safeZoneOffset * 0.70 || noteDiff < Conductor.safeZoneOffset * -0.70)
				note.rating = "shit";
			else if (noteDiff > Conductor.safeZoneOffset * 0.50 || noteDiff < Conductor.safeZoneOffset * -0.50)
				note.rating = "bad";
			else if (noteDiff > Conductor.safeZoneOffset * 0.45 || noteDiff < Conductor.safeZoneOffset * -0.45)
				note.rating = "good";
			else if (noteDiff < Conductor.safeZoneOffset * 0.44 && noteDiff > Conductor.safeZoneOffset * -0.44)
				note.rating = "sick";
			
			if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note);
					}
				}
			}
			else if (controlArray[note.noteData])
				{
					for (b in controlArray) {
						if (b)
							mashing++;
					}

					// ANTI MASH CODE FOR THE BOYS

					if (mashing <= getKeyPresses(note) && mashViolations < 2)
					{
						mashViolations++;
						
						goodNoteHit(note, (mashing <= getKeyPresses(note)));
					}
					else
					{
						// this is bad but fuck you
						playerStrums.members[0].animation.play('static');
						playerStrums.members[1].animation.play('static');
						playerStrums.members[2].animation.play('static');
						playerStrums.members[3].animation.play('static');
						health -= 0.2;
						trace('mash ' + mashing);
					}

					if (mashing != 0)
						mashing = 0;
				}
		}

		var nps:Int = 0;

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition);

				note.rating = Ratings.CalculateRating(noteDiff);

				if (!note.isSustainNote)
					notesHitArray.push(Date.now());

				if (resetMashViolation)
					mashViolations--;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else{
						trace("other?");
						totalNotesHit += 1;
					}

					if (crazyMode)
						{
							camGame.shake(0.008, 0.02, null, true);
						}
						
						
					switch (note.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
					
					if(curStage != "bambiFarmNight")
						{
							boyfriend.color = FlxColor.WHITE;
						}
						else
						{
							boyfriend.color = 0xFF878787;
						}
	
					if (!loadRep)
						playerStrums.forEach(function(spr:FlxSprite)
						{
							if (Math.abs(note.noteData) == spr.ID)
							{
								spr.animation.play('confirm', true);
							}
						});
		
					note.wasGoodHit = true;
					vocals.volume = 1;
		
					note.kill();
					notes.remove(note, true);
					note.destroy();
					
					updateAccuracy();
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}


	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		if (executeModchart && lua != null)
		{
			setVar('curStep',curStep);
			callLua('stepHit',[curStep]);
		}

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
		if (SONG.song.toLowerCase() == 'foolhardy')
			{
				if (curStep == 2426)
				{
					shakeCam = true;
					dad.alpha = 0.6;
				}
				if (curStep == 2432)
				{
					shakeCam = false;
				}
				if (curStep == 2943)
				{
					dad.alpha = 0.5;
				}
				if (curStep == 2944)
				{
					dad.alpha = 0.4;
				}
				if (curStep == 2945)
				{
					dad.alpha = 0.3;
				}
				if (curStep == 2946)
				{
					dad.alpha = 0.2;
				}
				if (curStep == 2947)
				{
					dad.alpha = 0.1;
				}
				if (curStep == 2948)
				{
					dad.alpha = 0;
				}
			}
			if (SONG.song.toLowerCase() == 'release')
			{
				if (curStep == 838)
				{
					dad.playAnim('tight-bars');
				}
			}
			if (SONG.song.toLowerCase() == 'fading')
			{
				if (curStep == 240)
				{
					dad.alpha = 0.9;
					iconP2.alpha=0.9;
				}
				if (curStep == 242)
				{
					dad.alpha = 0.8;
					iconP2.alpha=0.8;
				}
				if (curStep == 244)
				{
					dad.alpha = 0.7;
					iconP2.alpha=0.7;
				}
				if (curStep == 245)
				{
					dad.alpha = 0.6;
					iconP2.alpha=0.6;
				}
				if (curStep == 247)
				{
					dad.alpha = 0.5;
					iconP2.alpha=0.5;
					dad.playAnim('tight-bars');
				}
				if (curStep == 249)
				{
					dad.alpha = 0.4;
					iconP2.alpha=0.4;
				}
				if (curStep == 251)
				{
					dad.alpha = 0.3;
					iconP2.alpha=0.3;
				}
				if (curStep == 253)
				{
					dad.alpha = 0.2;
					iconP2.alpha=0.2;
				}
				if (curStep == 254)
				{
					dad.alpha = 0.1;
					iconP2.alpha=0.1;
				}
				if (curStep == 255)
				{
					dad.alpha = 0;
					iconP2.alpha=0;
				}
			}
			if(dad.curCharacter == 'ruv' || dad.curCharacter == 'ruv-remastered')
			{
				if(dad.animation.curAnim.name == 'singLEFT' || dad.animation.curAnim.name == 'singRIGHT' || dad.animation.curAnim.name == 'singDOWN' || dad.animation.curAnim.name == 'singUP')
				{
					FlxG.camera.shake(0.01, 0.08);
					gf.playAnim('scared');
				}
			}
			if(dad.curCharacter == 'tree3')
			{
				if(dad.animation.curAnim.name == 'singLEFT' || dad.animation.curAnim.name == 'singRIGHT' || dad.animation.curAnim.name == 'singDOWN' || dad.animation.curAnim.name == 'singUP')
				{
					gf.playAnim('scared');
				}
			}

			if (SONG.song.toLowerCase() == 'sauce')
			{
				if (curStep == 975)
				{
					dad.playAnim('pop');
				}
			}
			if (SONG.song.toLowerCase() == 'megalo strike back')
			{
				if (curStep == 928)
				{
					noteSpeed += 0.08; 
				}
				if (curStep == 1168)
				{
					dad.playAnim('save');
				}
				if (curStep == 1172)
				{
					dad.playAnim('save');
				}
				if (curStep == 1176)
				{
					dad.playAnim('save');
				}
				if (curStep == 1180)
				{
					dad.playAnim('save');
				}
				if (curStep == 1184)
				{
					dad.playAnim('save');
				}
				if (curStep == 1188)
				{
					dad.playAnim('save');
				}
				if (curStep == 1192)
				{
					dad.playAnim('save');
				}
				if (curStep == 1196)
				{
					dad.playAnim('save');
				}
				if (curStep == 1200)
				{
					dad.playAnim('save');
				}
				if (curStep == 1204)
				{
					dad.playAnim('save');
				}
				if (curStep == 1208)
				{
					dad.playAnim('save');
				}
				if (curStep == 1212)
				{
					dad.playAnim('save');
				}
				if (curStep == 1216)
				{
					dad.playAnim('save');
				}
				if (curStep == 1220)
				{
					dad.playAnim('save');
				}
				if (curStep == 2021)
				{
					dad.playAnim('trick');
					defaultCamZoom = 2;
				}
				if (curStep == 2077)
				{
					dad.playAnim('idle');
					defaultCamZoom = 0.9;
				}
				if (curStep == 2365)
				{
					camHUD.visible = false;
					camGame.visible = false;
				}
				if (curStep == 2384)
				{
					dad.playAnim('trick');
					defaultCamZoom = 2;
					camHUD.visible = false;
					camGame.visible = true;
				}
				if (curStep == 2400)
				{
					camGame.visible = false;
				}
			}
			if (SONG.song.toLowerCase() == 'turnip')
			{
				if (curStep == 511)
				{
					dad.playAnim('die');
				}
			}
			if (SONG.song.toLowerCase() == 'neko')
			{
				if (curBeat == 8)
				{
					dad.playAnim('hit', false);
					FlxG.camera.shake(0.01,0.3);
					carhit.animation.play('hit', false);
					carhit.y = 27.9;
				}
			}
			if (SONG.song.toLowerCase() == 'nazel')
			{
				if (curStep == 66)
				{
					dad.playAnim('ah', false, false);
				}
				if (curStep == 68)
				{
					dad.playAnim('chu', false, false);
				}
				if (curStep == 138)
				{
					dad.playAnim('ah', false, false);
				}
				if (curStep == 140)
				{
					dad.playAnim('chu', false, false);
				}
				if (curStep == 416)
				{
					dad.playAnim('ah', false, false);
				}
				if (curStep == 420)
				{
					dad.playAnim('chu', false, false);
				}
				if (curStep == 424)
				{
					dad.playAnim('danceLeft-alt', false, false);
				}
				if (curStep == 562)
				{
					dad.playAnim('ah', false, false);
				}
				if (curStep == 564)
				{
					dad.playAnim('chu', false, false);
				}
				if (curStep == 634)
				{
					dad.playAnim('ah', false, false);
				}
				if (curStep == 636)
				{
					dad.playAnim('chu', false, false);
				}
				if (curStep == 914)
				{
					dad.playAnim('ah-charged', false, false);
				}
				if (curStep == 920)
				{
					dad.playAnim('chu-charged', false, false);
					FlxG.camera.shake(0.05,1);
				}
				if (curStep == 1058)
				{
					dad.playAnim('ah-charged', false, false);
				}
				if (curStep == 1060)
				{
					dad.playAnim('chu-charged', false, false);
					FlxG.camera.shake(0.05,1);
				}
				if (curStep == 1130)
				{
					dad.playAnim('ah', false, false);
				}
				if (curStep == 1132)
				{
					dad.playAnim('chu', false, false);
				}
				if (curStep == 1304)
				{
					dad.playAnim('ah-charged', false, false);
				}
				if (curStep == 1308)
				{
					dad.playAnim('chu-charged', false, false);
					FlxG.camera.shake(0.05,1);
					FlxG.camera.fade(FlxColor.WHITE,0.1,false);
				}

			}
			if (dad.curCharacter == 'cheese-default' && SONG.song.toLowerCase() == 'restaurante')
				{
					switch (curBeat)
					{
					case 59:
						dad.playAnim('freestyle', true);
					case 75:
						dad.playAnim('poggers', true);
					}
				}
			if (dad.curCharacter == 'amor' && SONG.song.toLowerCase() == 'split')
				{
					switch (curStep)
					{
					case 696:
						dad.playAnim('drop', true);
					}
				}

			if (dad.curCharacter == 'cheese-milkshake' && SONG.song.toLowerCase() == 'milkshake')
			{
				if (curStep == 620)
				{
					dad.playAnim('keychange', true);
				}
			}
			
			if (dad.curCharacter == 'cheese-cultured' && SONG.song.toLowerCase() == 'cultured')
			{
				if (curStep == 495)
				{
					dad.playAnim('cultured', true);
				}
				if (curStep == 1166)
				{
					dad.playAnim('yo', true);
				}
			}
			
			if (boyfriend.curCharacter == 'bf-ricky' && SONG.song.toLowerCase() == 'cultured')
			{
				if (curStep == 656)
				{
					boyfriend.playAnim('hey', true);
				}
			}
			switch (SONG.song.toLowerCase())
			{
				case 'skylight':
					trace ("current beat: "+curBeat);
					if (FlxG.save.data.camfx)
					{
						switch (curBeat)
						{
							case 47:
							FlxTween.tween(fgLightbulb, {alpha: 0}, 1, {ease: FlxEase.quadInOut, type: PERSIST});
							case 55:
							FlxTween.tween(vignette, {alpha: 1}, 2, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(garageBg, {alpha: 0}, 2, {ease: FlxEase.quadInOut, type: PERSIST});
							case 64:
							FlxTween.tween(spotlightDJ, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightDJFloor, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							case 72:
							FlxTween.tween(spotlightDJ, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightDJFloor, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayer, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayerFloor, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							case 80:
							FlxTween.tween(spotlightDJ, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightDJFloor, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayer, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayerFloor, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							case 88:
							FlxTween.tween(spotlightDJ, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightDJFloor, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayer, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayerFloor, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							case 96:
							FlxTween.tween(spotlightDJ, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightDJFloor, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayer, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayerFloor, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							case 104:
							FlxTween.tween(spotlightDJ, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightDJFloor, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayer, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayerFloor, {alpha: 1}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							case 108:
							FlxTween.tween(FlxG.camera, {zoom: 2}, 2, {ease: FlxEase.quadInOut});
							case 112:
							// HELP ITS LAGGING IDK WHY HELPPPPPP *TYLER1 SCREAMING HELP* im SO BAD
							// WOO I FIXED ITTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
							FlxG.camera.flash(FlxColor.WHITE, 1);
							FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.25, {ease: FlxEase.quadInOut});
							FlxTween.tween(strobeRed, {alpha: 1}, 0.2, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(strobeBlue, {alpha: 1}, 0.2, {ease: FlxEase.quadInOut, type: PERSIST});
							case 124:
							FlxG.camera.flash(FlxColor.WHITE, 1.5);
							FlxTween.tween(strobeRed, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(strobeBlue, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayer, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(spotlightPlayerFloor, {alpha: 0}, 0.01, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(garageBg, {alpha: 1}, 0.1, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(fgLightbulb, {alpha: 1}, 0.1, {ease: FlxEase.quadInOut, type: PERSIST});
							FlxTween.tween(vignette, {alpha: 0}, 0.1, {ease: FlxEase.quadInOut, type: PERSIST});
							
						}
					}		
	
			}
			if (curSong.toLowerCase() == 'split' && curStep == 124 && camZooming || curSong.toLowerCase() == 'split' && curStep == 126 && camZooming || curSong.toLowerCase() == 'split' && curStep == 1144 && camZooming || curSong.toLowerCase() == 'split' && curStep == 1147 && camZooming || curSong.toLowerCase() == 'split' && curStep == 1150 && camZooming)
				{
			
					FlxG.camera.zoom += 0.05;
					camHUD.zoom += 0.01;
				}
				if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 768)
					{
						//crowd go byebye and now new crowd is there!!!
						add(bgcrowdjump);
						bgcrowd.alpha = 0;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curBeat >= 192 && curBeat < 208)
					{
						FlxG.camera.zoom += 0.05;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 1164)
					{
						FlxG.camera.zoom += 0.02;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 1166)
					{
						FlxG.camera.zoom += 0.02;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 1168)
					{
						FlxG.camera.zoom += 0.05;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 1520)
					{
						FlxG.camera.zoom += 0.05;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 1528)
					{
						FlxG.camera.zoom += 0.05;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 756)
					{
						dad.playAnim('three', true);
						FlxG.camera.zoom += 0.25;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 760)
					{
						dad.playAnim('two', true);
						FlxG.camera.zoom += 0.25;
					}
			
					if (curSong.toLowerCase() == 'pom-pomeranian' && curStep == 764)
					{
						dad.playAnim('one', true);
						FlxG.camera.zoom += 0.25;
					}
					if (SONG.song.toLowerCase() == 'transferred')
					{
						if (curStep == 1007)
						{
							FlxG.camera.angle = 180;
						}
						if (curStep == 1271)
						{
							FlxG.camera.angle = 0;
						}
					}
					if(SONG.song.toLowerCase() == 'furiosity')
						{
							if(curStep == 512)
							{
								daveCam = true;
							}
							else if(curStep == 768)
							{
								daveCam = true;
							}				
							else if(curStep == 640)
							{
								daveCam = false;
							}
							else if(curStep == 896)
							{
								daveCam = false;
							}
							if (curStep == 1305)
							{
								boyfriend.playAnim('hey',true);
								gf.playAnim('cheer',true);
							}
						}
						if(SONG.song.toLowerCase() == 'glitch')
						{
							if(curStep == 480 || curStep == 681 || curStep == 1390 || curStep == 1445 || curStep == 1515 || curStep == 1542 || curStep == 1598 || curStep == 1655)
							{
								daveCam = true;
							}
							if(curStep == 512 || curStep == 688 || curStep == 1420 || curStep == 1464 || curStep == 1540 || curStep == 1558 || curStep == 1608 || curStep == 1745)
							{
								daveCam = false;
							}
						}
						if (curStage == 'bambiFarmNight')
						{
							if (dad.animation.curAnim.name == 'idle')
							{
								santa.animation.play('idle');
							}
							if (dad.animation.curAnim.name == 'singUP')
							{
								santa.animation.play('singUP', true);
							}
							if (dad.animation.curAnim.name == 'singDOWN')
							{
								santa.animation.play('singDOWN', true);
							}
							if (dad.animation.curAnim.name == 'singLEFT')
							{
								santa.animation.play('singLEFT', true);
							}
							if (dad.animation.curAnim.name == 'singRIGHT')
							{
								santa.animation.play('singRIGHT', true);
							}
						}
						if (SONG.song.toLowerCase() == 'release-specter-remix')
						{
							if (curStep == 262 || curStep == 902 || curStep == 1862)
							{
								dad.playAnim('tight-bars');
							}
						}
								
			
		
			
	


		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + generateRanking(), "Acc: " + truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}



	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	
	override function beatHit()
	{
		super.beatHit();
	
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (FlxG.save.data.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		if (executeModchart && lua != null)
		{
			setVar('curBeat',curBeat);
			callLua('beatHit',[curBeat]);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				if(curSong == "Sky"){
					switch(curBeat){
						case 30,31,62,63:
							dad.playAnim('oh');
						case 126,127,190,191:
							dad.playAnim('grr');
						case 254,255,270,271:
							dad.playAnim('huh');
						case 286,287:
							dad.playAnim('ugh');
						default:
							if(curBeat <287)dad.dance();
					}
				}else{
					dad.dance();
				}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if(curSong.toLowerCase() == 'furiosity' && curBeat >= 128 && curBeat < 160)
		{
			if(camZooming)
			{
				FlxG.camera.zoom += 0.015;
			    camHUD.zoom += 0.03;
			}
		}
		else if(curSong.toLowerCase() == 'furiosity' && curBeat >= 192 && curBeat < 224)
		{
			if(camZooming)
				{
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.03;
				}
		
		}
		if(daveCam)
		{
			gf.playAnim('scared', true);
		}
		// thanks kapi mod i wouldnt know how this shit would work much love from: silk88
		if (curSong.toLowerCase() == 'king-hit' && curBeat == 31)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, .5, {
								ease: FlxEase.quadInOut,
					});
		}
		
		if (curSong.toLowerCase() == 'wind-up' && curBeat == 222)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, .5, {
								ease: FlxEase.quadInOut,
					});
		}

		if (curSong.toLowerCase() == 'king-hit-fefe' && curBeat == 31)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, .5, {
								ease: FlxEase.quadInOut,
					});
		}
		if (curSong.toLowerCase() == 'split' && curBeat == 188) //|| curSong.toLowerCase() == 'split' && curBeat == 190)
			{
				if (FlxG.save.data.flashing) {
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});
	
					curLight++;
					if (curLight > phillyCityLights.length - 1)
						curLight = 0;
	
					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, 0.2, {
					});
					for (spr in theEntireFuckingStage) {
						spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.9, 1);
					}
				}
			}
			if (curSong.toLowerCase() == 'split' && curBeat >= 192 && curBeat < 256 && camZooming && FlxG.camera.zoom < 1.35)
			{
				if (FlxG.save.data.flashing) {
					for (spr in theEntireFuckingStage) {
						spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 0.7, 1);
					}
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});
	
					curLight++;
					if (curLight > phillyCityLights.length - 1)
						curLight = 0;
	
					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, 0.3, {
					});
			
					FlxG.camera.zoom += 0.030;
					camHUD.zoom += 0.04;
				}
			}
			if (curSong.toLowerCase() == 'split' && curBeat >= 32 && curBeat < 160 && camZooming && FlxG.camera.zoom < 1.35 && curBeat != 95 || curSong.toLowerCase() == 'split' && curBeat >= 288 && curBeat < 316 && camZooming && FlxG.camera.zoom < 1.35 || curSong.toLowerCase() == 'split' && curBeat >= 352 && curBeat < 385 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
			if (curSong.toLowerCase() == 'split' && curBeat == 256)
			{
				for (spr in theEntireFuckingStage) {
					spr.color = FlxColor.fromHSL(spr.color.hue, spr.color.saturation, 1, 1);
				}
			}
			if (curSong.toLowerCase() == 'jump-in' && curBeat == 4 || curSong.toLowerCase() == 'swing' && curBeat == 64 || curSong.toLowerCase() == 'swing' && curBeat == 224)
			{
				FlxG.sound.play(Paths.sound('carPass1', 'shared'), 0.7);
				new FlxTimer().start(1.3, function(tmr:FlxTimer)
				{
					phillyTrain.x = 2000;
					phillyTrain.flipX = false;
					phillyTrain.visible = true;
					FlxTween.tween(phillyTrain, {x: -2000}, 0.18, {
						onComplete: function(twn:FlxTween) {
							phillyTrain.visible = false;
						}
					});
				});
				
			}
	
		if (curSong.toLowerCase() == 'ego' && curBeat == 186 && !dad.animation.curAnim.name.startsWith("sing")) {
			dad.playAnim('singDOWN-alt');
		}
		var triggered = false;
		if (curSong.toLowerCase() == 'ego' && curBeat == 202 && !triggered) {
			triggered = true;
			FlxG.camera.shake(0.02, 2.2, function()
			{
			});
			camHUD.shake(0.02, 2.2, function()
			{
			});
		}
				if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0 && curSong.toLowerCase() != 'nyaw')
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (curSong.toLowerCase() == 'nyaw' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0 && curBeat != 283 && curBeat != 282)
		{
			{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
			}
			FlxG.camera.zoom += 0.02;
			camHUD.zoom += 0.022;
		}
		if (curSong.toLowerCase() == 'nyaw' && curBeat == 282)
		{
			FlxTween.tween(FlxG.camera, {zoom: 1}, .5, {
								ease: FlxEase.quadInOut,
					});
		}
		if (curSong.toLowerCase() == 'hairball' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0)
		{
			FlxG.camera.zoom += 0.017;
			camHUD.zoom += 0.02;
		}
		if (curSong.toLowerCase() == 'hairball' && curBeat % 1 == 0)
					{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
					}
		if (curSong.toLowerCase() == 'kapisun' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 1 == 0)
		{
			FlxG.camera.zoom += 0.017;
			camHUD.zoom += 0.02;
		}
		if (curSong.toLowerCase() == 'kapisun' && curBeat % 1 == 0)
					{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
					}

		if (curSong.toLowerCase() == 'beathoven' && curBeat % 1 == 0)
					{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
					}
		if (curSong.toLowerCase() == 'wocky' && curBeat % 2 == 0)
					{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
					}
		if (curSong.toLowerCase() == 'cat on the mic' && curBeat % 2 == 0)
					{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
					}

		if (curSong.toLowerCase() == 'beathoven' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
		{
			FlxG.camera.zoom += 0.014;
			camHUD.zoom += 0.015;
		}
		if (curSong.toLowerCase() == 'wocky' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
		{
			FlxG.camera.zoom += 0.016;
			camHUD.zoom += 0.015;
		}
		if (curSong.toLowerCase() == 'cat on the mic' && camZooming && FlxG.camera.zoom < 1.35 && curBeat % 2 == 0)
		{
			FlxG.camera.zoom += 0.016;
			camHUD.zoom += 0.015;
		}




		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.dance();
			if(curStage == "bambiFarmNight")
				{
				boyfriend.color = 0xFF878787;
				}
				else
				{
				boyfriend.color = FlxColor.WHITE;
				}
		}
		if (curBeat == 223 && curSong == 'wind-up')
		{
			boyfriend.playAnim('hit', true);
		}

        if (curBeat == 32 && curSong == 'king-hit')
		{
			dad.playAnim('snap', true);
		} 

        if (curBeat == 32 && curSong == 'king-hit-fefe')
		{
			dad.playAnim('troll', true);
		} 
		if (curBeat % 8 == 7 && SONG.isHey)
			{
				boyfriend.playAnim('hey', true);
	
				if (SONG.song == 'Tutorial' && dad.like == 'gf')
				{
					dad.playAnim('cheer', true);
				}
			}
		if (curBeat == 283 && curSong == 'Nyaw')
		{
			boyfriend.playAnim('hey', true);
		}
		if (curBeat == 434 && curSong == 'Nyaw')
		{
			dad.playAnim('stare', true);
				new FlxTimer().start(1.1, function(tmr:FlxTimer)
				{
				var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
				black.scrollFactor.set();
				add(black);
				});
		}
		if (curBeat == 31 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat == 135 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat == 363 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat == 203 && curSong == 'Nyaw')
		{
			dad.playAnim('meow', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Nyaw')
		{
			bottomBoppers.animation.play('bop', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Hairball')
		{
			littleGuys.animation.play('bop', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Kapisun')
		{
			littleGuys.animation.play('bop', true);
		}
		if (curBeat % 2 == 0 && curSong == 'Beathoven')
		{
			littleGuys.animation.play('bop', true);
		}
		if (curBeat % 2 == 1 && curSong == 'Nyaw')
		{
			upperBoppers.animation.play('bop', true);
		}
		if (curBeat % 2 == 1 && curSong == 'Hairball')
		{
			upperBoppers.animation.play('bop', true);
		}
		if (curBeat % 2 == 1 && curSong == 'Kapisun')
		{
			upperBoppers.animation.play('bop', true);
		}


	

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'sweetstage':
				sweetstagecity.animation.play('cityflash', true);
				sweetstagehouse.animation.play('smoke', true);
				sweetstagemackie.animation.play('mackbob', true);
			case 'gateau':
				smallbgcrowd.animation.play('smallbob', true);
			case 'pom-pomeranian':
				bgcrowd.animation.play('bob', true);
				bgcrowdjump.animation.play('jump', true);
				alya.animation.play('alyabob', true);
				anchor.animation.play('anchorbob', true);
				tricky.animation.play('trickybob', true);
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);
			case 'bambiFarmNight':
				santa.animation.play('idle', false);
			case 'swordfight':
				bgBoppers.animation.play('bop', true);
		    case 'rucksburg':
					{
						chief.animation.play('chief', true);
						pantheon.animation.play('pantheon', true);
						sadieDanced = !sadieDanced;
						if (sadieDanced)
							sadie.animation.play('sadieRight', true);
						else
							sadie.animation.play('sadieLeft', true);
					}
			case 'bawnebyl':
				{
					bawnebylbgBumped = !bawnebylbgBumped;
					if (bawnebylbgBumped)
					{
						bawnebylbg.animation.play('sky1', true);
						thing.animation.play('thing1', true);
						flamebeat.animation.play('flamebeat1', true);
					}
					else
					{
						bawnebylbg.animation.play('sky2', true);
						thing.animation.play('thing2', true);
						flamebeat.animation.play('flamebeat2', true);
					}
				}	
				case 'day':
					{
						sadieDanced = !sadieDanced;
						if (sadieDanced)
							mordecai.animation.play('walk1', true);
						else
							mordecai.animation.play('walk2', true);
					}

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
			case 'hallwaynoon':
				bottomBoppers.animation.play('bop', true);
			case 'darkhallway':
				bottomBoppers.animation.play('bop', true);
			case 'rucksburg':
				chief.animation.play('chief', true);
				pantheon.animation.play('pantheon', true);
				sadieDanced = !sadieDanced;
				if (sadieDanced)
				{
					sadie.animation.play('sadieRight', true);
				}
				else
				{
					sadie.animation.play('sadieLeft', true);
				}
				
				if (radBeatsUntilReaction > 0)
				{
					radBeatsUntilReaction -= 1;
				}
				else if (radBeatsUntilReaction == 0)
				{
					dad.animation.play('confused');
					radBeatsUntilReaction = -1;
				}
			case 'bawnebyl':
				bawnebylbgBumped = !bawnebylbgBumped;
				if (bawnebylbgBumped)
				{
					bawnebylbg.animation.play('sky1', true);
					thing.animation.play('thing1', true);
					flamebeat.animation.play('flamebeat1', true);
				}
				else
				{
					bawnebylbg.animation.play('sky2', true);
					thing.animation.play('thing2', true);
					flamebeat.animation.play('flamebeat2', true);
				}
				if (curStage == 'night') {
					mini.animation.play('idle', true);
				}
				if (curStage == 'sunset') {
					mini.animation.play('idle', true);
					mordecai.animation.play('idle', true);
				}
				if (curStage == 'day') {
					mini.animation.play('idle', true);
					if (stopWalkTimer == 0) {
						if (walkingRight)
							mordecai.flipX = false;
						else
							mordecai.flipX = true;
						if (walked)
							mordecai.animation.play('walk1');
						else
							mordecai.animation.play('walk2');
						if (walkingRight)
							mordecai.x += 10;
						else
							mordecai.x -= 10;
						walked = !walked;
						trace(mordecai.x);
						if (mordecai.x == 480 && walkingRight) { 
							stopWalkTimer = 10;
							walkingRight = false;
						} else if (mordecai.x == -80 && !walkingRight) { 
							stopWalkTimer = 8;
							walkingRight = true;
						}
					} else 
						stopWalkTimer--;
				}
		

			case "ego":
				if (curBeat % 4 == 0)
				{

					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;					
				}
			case 'violastroStage':
				if (curBeat % 2 == 0) {
					crowd.animation.play('bop', true);
					lights.animation.play('flash', true);
					speakers.animation.play('bounce', true);
				}
			case "ridzak":
				if (curBeat % 4 == 0)
				{

					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;					
				}
			case "cyb":
				if (curBeat % 4 == 0)
				{

					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;					
				}
				case 'restaurante':
					crowd.animation.play('idle');
					doot.animation.play('idle');
		


		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	var curLight:Int = 0;
}
//developed by kidsfreej on github