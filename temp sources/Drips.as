package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.twoD.handlers.DisplayObjectHandler;
	
	[SWF(width='1024', height='768', frameRate='60', backgroundColor='#000000')]
	public class Drips extends StardustExample {
		
		private var bmpd:BitmapData;
		private var bmp:Bitmap;
		
		public function Drips() {
			
		}
		
		override protected function buildParticleSystem():void {
			bmpd = new BitmapData(320, 240, true, 0);
			bmp = new Bitmap(bmpd);
			bmp.scaleX = bmp.scaleY = 2;
			
			addChildAt(bmp, getChildIndex(container));
			
			emitter = new DripEmitter(new SteadyClock(0.1));
			emitter.particleHandler = new DisplayObjectHandler(container);
		}
		
		private var darken:ColorTransform = new ColorTransform(1, 1, 1, 0.8);
		private var matrix:Matrix = new Matrix(0.5, 0, 0, 0.5);
		override protected function mainLoop(e:Event):void {
			//bmpd.colorTransform(bmpd.rect, darken);
			//bmpd.draw(container, matrix);
			emitter.step();
		}
	}
}

import idv.cjcat.stardust.common.actions.*;
import idv.cjcat.stardust.common.actions.triggers.DeathTrigger;
import idv.cjcat.stardust.common.clocks.Clock;
import idv.cjcat.stardust.common.initializers.*;
import idv.cjcat.stardust.common.math.UniformRandom;
import idv.cjcat.stardust.twoD.actions.*;
import idv.cjcat.stardust.twoD.emitters.Emitter2D;
import idv.cjcat.stardust.twoD.fields.UniformField;
import idv.cjcat.stardust.twoD.initializers.*;
import idv.cjcat.stardust.twoD.zones.LazySectorZone;
import idv.cjcat.stardust.twoD.zones.Line;
import idv.cjcat.stardust.twoD.zones.RectZone;
import idv.cjcat.stardust.twoD.zones.SinglePoint;

class DripEmitter extends Emitter2D {
	[Embed(source="rose.png")]
	private var RoseClass:Class;
	public function DripEmitter(clock:Clock) {
		super(clock);
		
		//spawn
		var spawn:Spawn = new Spawn(new UniformRandom(4, 1));
		var lazySector:LazySectorZone = new LazySectorZone(2.5, 1.5);
		lazySector.direction.set(0, 1);
		lazySector.directionVar = 70;
		spawn.addInitializer(new Velocity(lazySector));
		spawn.addInitializer(new Position(new SinglePoint(0, -10))); //moves new particles up, avoiding death zone
		spawn.addInitializer(new Mask(2));
		spawn.addInitializer(new DisplayObjectClass(RoseClass));
		
		//initializers
		addInitializer(new Mask(1));
		addInitializer(new DisplayObjectClass(RoseClass));
		addInitializer(new Velocity(new SinglePoint(0, 1)));
		addInitializer(new Position(new Line(0, 60, 1024, 60)));
		
		//common actions
		var gravity:Gravity = new Gravity();
		gravity.addField(new UniformField(0, 0.2));
		var commonActions:CompositeAction = new CompositeAction();
		commonActions.mask = 1 | 2;
		commonActions.addAction(gravity);
		commonActions.addAction(new Move());
		commonActions.addAction(new Oriented());
		commonActions.addAction(new DeathZone(new RectZone(0, 0, 1024, 768), true));
		addAction(commonActions);
		
		//drip actions
		var deathTrigger:DeathTrigger = new DeathTrigger();
		deathTrigger.addAction(spawn);
		var dripActions:CompositeAction = new CompositeAction();
		dripActions.mask = 1;
		//dripActions.addAction(deathTrigger);
		//addAction(dripActions);
	}
}