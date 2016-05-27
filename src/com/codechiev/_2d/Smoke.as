package com.codechiev._2d
{
	import com.hexagonstar.display.bitmaps.AnimatedBitmap;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class Smoke extends Sprite
	{
		public var isActive:Boolean=true;
		
		public function Smoke(bitmap:BitmapData, frameW:int, frameH:int):void
		{
			this.isActive = false;
			yAdjust = frameW*.5;
			xAdjust = frameH*.5;
			anim = new AnimatedBitmap(bitmap, frameW, frameH);
			this.addChild(anim);
			anim.x = -xAdjust;
			anim.y = -yAdjust;
			anim.visible = false;
		}


		public var anim:AnimatedBitmap;
		public var yAdjust:int;
		public var xAdjust:int;
		

	}
}