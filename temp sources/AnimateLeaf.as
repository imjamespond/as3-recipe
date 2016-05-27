package
{
	import com.blueflamedev.effects.particles2.*;
	import com.blueflamedev.effects.ParticleSeed;
	
	import flash.display.Sprite;
	
	[SWF(width='1024', height='768', frameRate='60', backgroundColor='#000000')]
	public class AnimateLeaf extends Sprite
	{

		
		//the particle generator
		private var bubbleSeed:ParticleSeed;
		//the background
		private var bg:Sprite;
		//holds the particles and particle generator
		private var holder:Sprite;
		
		public function AnimateLeaf()
		{
			
			holder = new Sprite();

			addChild(holder);
			holder.x = 512;
			holder.y = 512;
			
			var c:Class = AnimatedLeaf;
			
			var seed:Seed = new Seed(holder, c, 3, 7000);
			seed.start(33);
			
			seed.deployParticle = deployLeaf;
			seed.updateParticle = updateLeaf;
		}

		
		public function deployLeaf(leaf:AbstractParticle, delta:Number):void
		{
			leaf.x = Math.random() * 200 - 100;
			leaf.y = Math.random() * 50 - 25;
		}
		
		public function updateLeaf(leaf:AbstractParticle, delta:Number):void
		{
			leaf.velocityY += .01;
		}
	}
}

import flash.display.Bitmap;
import com.blueflamedev.effects.particles2.AbstractParticle;
class AnimatedLeaf extends AbstractParticle
{
	[Embed(source="rose.png")]
	private var RoseClass:Class;
	public function AnimatedLeaf()
	{
		var leaf:Bitmap = Bitmap(new RoseClass());
		addChild(leaf);
		super();
	}
	
	override public function get lifespan():Number
	{
		return 15000;
	}
}