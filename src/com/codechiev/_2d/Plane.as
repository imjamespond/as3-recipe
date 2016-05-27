package com.codechiev._2d
{
	import com.hexagonstar.display.bitmaps.AnimatedBitmap;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Plane extends Sprite
	{
		public var isActive:Boolean=true;
		
		public function Plane(bitmap:BitmapData, frameW:int, frameH:int):void
		{
			this.isActive = false;
			yAdjust = frameW*.5;
			xAdjust = frameH*.5;
			anim = new AnimatedBitmap(bitmap, frameW, frameH);
			this.addChild(anim);
			//anim.x = -xAdjust;
			//anim.y = -yAdjust;
			
//			touch = new Sprite();
//			touch.x = -xAdjust;
//			touch.y = -yAdjust;			
//			this.addChild(touch);
			this.graphics.beginFill(0x0000ff, 0.3);//fill with pure color
//			//fill with pixel
			//s.graphics.beginBitmapFill(_leaf.bitmapData, new Matrix(), true);
			this.graphics.drawRect(0, 0, frameW, frameH);
//			//s.graphics.drawCircle(0, 0, Math.random() * 8 + 20);
			this.graphics.endFill();
			
			lifeBar = new LifeBar(frameW,3);
			//lifeBar.x = x;
			lifeBar.y = 10+anim.height;
			this.addChild(lifeBar);
			hp = hpMax;
		}

		public var lifeBar:LifeBar;
		public var anim:AnimatedBitmap;
		//public var touch:Sprite;
		public var yAdjust:int;
		public var xAdjust:int;
		
		public var userId:Number;
		public var attackNum:int;
		private var _attackAngle:int;
		public var hp:int;
		public var hpMax:int = 100;
		
		public function onUpdateLiftBar():void {
			lifeBar.x = x;
			lifeBar.y = y+10+anim.height;
		}
		
		public function decreaseHp(hurt:uint):void {
			hp -= hurt;
			lifeBar.updateProgress(hp/hpMax);
		}
		
		public function set attackAngle(angle:int):void{
			_attackAngle = angle;
			anim.angle = angle;
		}
		public function get attackAngle():int{
			return _attackAngle;
		}
	}
}