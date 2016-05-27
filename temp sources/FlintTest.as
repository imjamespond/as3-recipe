package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.events.EmitterEvent;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.Explosion;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.actions.RandomDrift;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.particles.Particle2D;
	import org.flintparticles.twoD.particles.Particle2DUtils;
	import org.flintparticles.twoD.renderers.*;
	import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	[SWF(width='1024', height='768', frameRate='60', backgroundColor='#000000')]
	
	public class FlintTest extends Sprite
	{
		private var leafEmitter:Emitter2D;
		private var starEmitter:Emitter2D;
		private var bubbleEmitter:Emitter2D;
		private var sparkEmitter:Emitter2D;
		private var emitter:Emitter2D;
		private var bitmap:BitmapData;
		private var dpRenderer:DisplayObjectRenderer;
		private var explosion:Explosion;
		[Embed(source="wheel.png")]
		private var ImgClass:Class;
		[Embed(source="leaf.swf")]
		private var LeafClass:Class;
		public function FlintTest()
		{
			/*base emmiter, no counter
			bitmap = Bitmap(new ImgClass()).bitmapData;
			emitter = new Emitter2D();
			
			emitter.addInitializer( new Position( new LineZone( new Point( -5, -5 ), new Point( 1024, -5 ) ) ) );
			emitter.addInitializer( new Velocity( new DiscZone( new Point( 0, 65 ), 50, 0 ) ) );
			emitter.addAction( new Move() );
			emitter.addAction( new DeathZone( new RectangleZone( -10, -10, 1024, 768 ), true ) );
			var particles:Vector.<Particle> = new Vector.<Particle>();//Particle2DUtils.createRectangleParticlesFromBitmapData( bitmap, 80, emitter.particleFactory, 56, 47 );
			
			for(var i:uint=0;i<100;i++){
				var leaf:DisplayObject=new LeafClass();//
				var part:Particle2D = new Particle2D();
				part.image = leaf;
				particles.push(part);
			}
			
			emitter.addParticles( particles, true );
			
			dpRenderer = new DisplayObjectRenderer();
			dpRenderer.addEmitter( emitter );
			addChild( dpRenderer );	
			emitter.start();
			*/
			
			leafEmitter = new Leaffall();
			starEmitter = new StarEmitter();
			bubbleEmitter = new BubbleEmitter();
			sparkEmitter = new SparkEmitter(this);
			//emitter.x = 125;
			//emitter.y = 245;
			
			var renderer:BitmapRenderer = new BitmapRenderer( new Rectangle( 0, 0, 1024, 768 ) );
			renderer.addEmitter( starEmitter );
			renderer.addEmitter( leafEmitter );
			renderer.addEmitter( sparkEmitter );
			renderer.addEmitter( bubbleEmitter );
			addChild( renderer );

			leafEmitter.start();
			starEmitter.start();
			sparkEmitter.start();
			bubbleEmitter.start();
			
			//var pixelRenderer:BitmapRenderer = new BitmapRenderer( new Rectangle( 0, 0, 400, 400 ) );
			//pixelRenderer.addFilter( new BlurFilter( 2, 2, 1 ) );
			//pixelRenderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.99,0 ] ) );
			//pixelRenderer.addEmitter( bubbleEmitter);
			//addChild( pixelRenderer );
			
		}
	
	}
}


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;

import org.flintparticles.common.actions.*;
import org.flintparticles.common.counters.*;
import org.flintparticles.common.displayObjects.RadialDot;
import org.flintparticles.common.events.EmitterEvent;
import org.flintparticles.common.initializers.*;
import org.flintparticles.twoD.actions.*;
import org.flintparticles.twoD.emitters.Emitter2D;
import org.flintparticles.twoD.initializers.*;
import org.flintparticles.twoD.zones.*;

class Leaffall extends Emitter2D
{
	[Embed(source="leaf.swf")]
	private var LeafClass:Class;
	[Embed(source="rose.png")]
	private var RoseClass:Class;
	[Embed(source="leaf.png")]
	private var LEAFClass:Class;
	public function Leaffall()
	{
		counter = new Steady( 2 );
		
		var leaf:Sprite = new Sprite();
		leaf.addChild(new LeafClass());
		var rose:Sprite = new Sprite();
		rose.addChild(new RoseClass());
		var lEAF:Sprite = new Sprite();
		lEAF.addChild(new LEAFClass());
		//addInitializer( new SharedImage(sprite) );
		//addInitializer( new ImageClass(LeafClass) );
		var arr:Array = new Array(leaf,rose,lEAF);
		addInitializer( new SharedImages(arr) );
		addInitializer( new Position( new LineZone( new Point( -5, -5 ), new Point( 1024, -5 ) ) ) );
		addInitializer( new Velocity( new DiscZone( new Point( 0, 65 ), 50, 0 ) ) );
		addInitializer( new ScaleImageInit( 0.75, 2 ) );
		
		addAction( new Move() );
		addAction( new DeathZone( new RectangleZone( -10, -10, 1024, 768 ), true ) );
		addAction( new RandomDrift( 20, 20 ) );
	}
	
}

class StarEmitter extends Emitter2D
{

	[Embed(source="star.png")]
	private var ImgClass:Class;
	public function StarEmitter()
	{
		//counter = new TimePeriod( 30, 2 );
		counter = new Blast(20);
		var bm:Bitmap = Bitmap(new ImgClass());
		var sprite:Sprite = new Sprite();
		bm.x = -bm.width>>1;
		bm.y = -bm.height>>1;
		sprite.addChild(bm);
		var sharedImage:SharedImage = new SharedImage(sprite);
		sharedImage.image.x = sharedImage.image.width;
		sharedImage.image.y = sharedImage.image.height;
		addInitializer( sharedImage );
		//addInitializer( new ImageClass( RadialDot, [2] ) );
		
		//addInitializer( new Position( new LineZone( new Point( -5, -5 ), new Point( 605, -5 ) ) ) );
		//addInitializer( new Velocity( new PointZone( new Point( 0, 100 ) ) ) );
		
		
		addInitializer( new Position( new DiscZone( new Point( 512, 512 ), 50 ) ) );
		addInitializer( new Velocity( new DiscSectorZone( new Point( 0, 0 ), 1000, 800, -5 * Math.PI / 8, -3 * Math.PI / 8 ) ) );//方向,outer发散最大速度,inner发散最小速度
		//addInitializer( new ScaleImageInit( 0.75, 1 ) );
		addInitializer( new RotateVelocity(0,10));
		addInitializer( new Lifetime( 3 ) );
		
		addAction( new Move() );
		//addAction( new Fade() );
		addAction( new Age() );
		addAction( new Accelerate( 0, 1000 ) );
		addAction( new Rotate() );
		addAction( new DeathZone( new RectangleZone( 0, 0, 1024, 600 ), true ) );
		//addAction( new RandomDrift( 20, 20 ) );
		
		addEventListener( EmitterEvent.EMITTER_EMPTY, restart, false, 0, true );
	}
	
	public function restart( ev:EmitterEvent ):void
	{
		start();
	}
}

import org.flintparticles.common.counters.Random;
import org.flintparticles.common.displayObjects.*;
import org.flintparticles.common.initializers.ColorInit;
import org.flintparticles.twoD.actions.GravityWell;
import org.flintparticles.twoD.actions.Move;
import org.flintparticles.twoD.emitters.Emitter2D;
import org.flintparticles.twoD.initializers.Position;
import org.flintparticles.twoD.zones.DiscZone;

import flash.geom.Point;

class BubbleEmitter extends Emitter2D
{
	public function BubbleEmitter()
	{
		counter = new Random( 5, 10 );
		addInitializer( new SharedImage( new RadialDot( 6 ) ) );
		addInitializer( new ColorInit( 0xFFFF00FF, 0xFF00FFFF ) );
		addInitializer( new Position( new DiscZone( new Point( 200, 200 ), 50 ) ) );
		addInitializer( new Velocity( new DiscSectorZone( new Point( 0, 0 ), 50, 5, -Math.PI/2, -Math.PI/2) ) );//无方向,角度90
		addInitializer( new Lifetime( 3 ) );
		addInitializer( new ScaleImageInit( 0.25, 1 ) );
		
		addAction( new Move() );
		addAction( new Age() );
		addAction( new Fade() );
		
	}
}

import org.flintparticles.common.actions.Age;
import org.flintparticles.common.counters.Steady;
import org.flintparticles.common.displayObjects.Line;
import org.flintparticles.common.initializers.ColorInit;
import org.flintparticles.common.initializers.Lifetime;
import org.flintparticles.common.initializers.SharedImage;
import org.flintparticles.twoD.actions.Move;
import org.flintparticles.twoD.actions.RotateToDirection;
import org.flintparticles.twoD.activities.FollowMouse;
import org.flintparticles.twoD.emitters.Emitter2D;
import org.flintparticles.twoD.initializers.Velocity;
import org.flintparticles.twoD.zones.DiscZone;

import flash.display.DisplayObject;
import flash.geom.Point;

class SparkEmitter extends Emitter2D
{
	public function SparkEmitter( renderer:DisplayObject )
	{
		counter = new Steady( 50 );
		
		addInitializer( new SharedImage( new Line( 5 ) ) );
		addInitializer( new ColorInit( 0xFFFFCC00, 0xFFFFCC00 ) );
		addInitializer( new Position( new DiscZone( new Point( 0, 0 ), 5 ) ) );
		addInitializer( new Velocity( new DiscZone( new Point( 0, 0 ), 50, 20 ) ) );
		addInitializer( new Lifetime( .8, 1.2 ) );
		
		addAction( new Age() );
		addAction( new Move() );
		addAction( new RotateToDirection() );
		addAction( new Accelerate( 0, 200 ) );
		addAction( new Fade() );
		
		addActivity( new FollowMouse( renderer ) );
	}
}
