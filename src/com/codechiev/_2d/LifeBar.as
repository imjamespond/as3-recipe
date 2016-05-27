package com.codechiev._2d
{
	import flash.display.*;
	import flash.geom.*;
	
	public class LifeBar extends Bitmap
	{

		private var greenData:BitmapData;
		private var redData:BitmapData;
		private var rect:Rectangle;
		private static var POINT:Point = new Point(0,0);
		public function LifeBar(w:uint, h:uint)
		{
			rect = new Rectangle(0,0,w,h);
			
			greenData = new BitmapData(w, h, false, 0x00ff00);
			redData = new BitmapData(w, h, false, 0xff0000);
			super(greenData.clone(),"auto", false);
			return;
		}
		
		public function updateMaxHealth(arg1:int, arg2:int):void
		{
			return;
		}
		
		public function updateProgress(portion:Number):void
		{
			rect.width = width;
			bitmapData.copyPixels(redData,rect,LifeBar.POINT);
			rect.width = width*portion;
			bitmapData.copyPixels(greenData,rect,LifeBar.POINT);
			return;
		}
		
		public function flip(arg1:int):void
		{
			this.scaleX = arg1;
			return;
		}
		
		public function show():void
		{
			this.visible = true;
			return;
		}
		
		public function hide():void
		{
			this.visible = false;
			return;
		}
	}
}