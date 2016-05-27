package com.james._2d
{
	import com.hexagonstar.display.bitmaps.AnimatedBitmap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class Missle extends Sprite{
		public var anim:AnimatedBitmap;
		public var yAdjust:int;
		public var xAdjust:int;
		//mage bolt
		public var aceleration:Number=1;	
		public var maxAceleration:Number = 20;	
		public var targetX:Number;//_-IU
		public var targetY:Number;//_-6u
		public var acelerationPitch:Number;//_-SL
		public var acelerationYaw:Number;//_-OY
		public var isActive:Boolean=true;
		public var target:Plane;
		
		//missle
		protected var stepAngle:Number=0.2;//_-0t
		protected var _with:Number;//with
		protected var follow:Boolean=false;
		protected var leftOrRight:Boolean;//_-NL		
		protected var _launching:Boolean=true;//_-4s
		protected var lastTargetDestination:Point;
		protected var _lr:uint;
		//bomb
		//public var _-Qg:Number;targetX
		//public var _-Cy:Number;targetY
		public var t0:Number;//时间
		public var t1:Number;
		public var g:Number=1;//重力
		public var originY:Number;//_-24
		public var originX:Number;//_-Jo
		public var speedX:Number;//_-SL
		public var speedY:Number;//_-OY
		
		public function Missle(bitmap:BitmapData, frameW:int, frameH:int):void
		{
			this.isActive = false;
			yAdjust = frameW*.5;
			xAdjust = frameH*.5;
			anim = new AnimatedBitmap(bitmap, frameW, frameH);
			this.addChild(anim);
			anim.x = -xAdjust;
			anim.y = -yAdjust;
		}
		public function hit():void
		{
			this.isActive = false;
			this.x = this.targetX;
			this.y = this.targetY;
			this.aceleration = 0;
			//this.parent.removeChild(this);
			
			target.decreaseHp(1);//威力
			return;
		}
		public function onUpdate():void {
			
		}
		
		public function moveMe():void
		{
			var target:Plane = this.target;
			
			var yDistance:*=0;//loc1
			var xDistance:*=0;//loc2
			var angle:*=0;//loc3
			//				if (target != null) 
			//				{
			//					if (target.parent == null || !target.isActive) 
			//					{
			//						target = null;
			//					}
			//				}
			if (target == null) 
			{
				yDistance = this.targetY - this.y;//距离
				xDistance = this.targetX - this.x;//
			}
			else 
			{
				yDistance = target.y + target.yAdjust - this.y;
				xDistance = target.x + target.xAdjust - this.x;
				this.targetY = target.y + target.yAdjust;
				this.targetX = target.x + target.xAdjust;
			}
			angle = Math.atan2(yDistance, xDistance);
			if (this.aceleration < this.maxAceleration) 
			{
				this.aceleration = this.aceleration + Math.ceil(this.aceleration * 0.05);
				if (this.aceleration >= this.maxAceleration) 
				{
					this.aceleration = this.maxAceleration;
				}
			}
			this.acelerationYaw = Math.sin(angle) * this.aceleration;
			this.acelerationPitch = Math.cos(angle) * this.aceleration;
			this.rotation = 360 - Math.atan2(-this.acelerationYaw, this.acelerationPitch) * 180 / Math.PI;
			if (false && this.targetY <= this.y) 
			{
				this.y = this.y - 11;
			}
			this.x = this.x + this.acelerationPitch;
			this.y = this.y + this.acelerationYaw;
			if (Math.sqrt(Math.pow(this.targetY - this.y, 2) + Math.pow(this.targetX - this.x, 2)) < this.aceleration) 
			{
				if (target == null) 
				{
					//this.hit();//打空
				}
				else 
				{
					//this.hitOnTarget();
					this.hit();
				}
			}
			return;
		}
		
		
		public function initMissle():void
		{
			this.follow = false;
			this._launching = true;
			this.aceleration = 5;
			this.maxAceleration = 15;
			//this.moveMe(true);
			this.acelerationPitch = Math.cos(90 * Math.PI / 180) * this.aceleration;
			this.acelerationYaw = Math.sin(90 * Math.PI / 180) * this.aceleration;
			//初始弹射出的目标
			this.targetX = x + 10;
			this.targetY = y - 80;
			return;
		}
		
		public function initMissle2(launcher:Plane):void
		{
			this.follow = false;
			this._launching = true;
			this.aceleration = 5;
			this.maxAceleration = 15;
			//this.moveMe(true);
			_lr = ++launcher.attackNum%2;
			var leftOrRight:Number
			if(_lr >0){
				leftOrRight = launcher.attackAngle-120;
			}else{
				leftOrRight = launcher.attackAngle-30;
			}
			//初始弹射出的目标
			this.targetX = x + 50*Math.cos(leftOrRight * Math.PI/180);
			this.targetY = y + 50*Math.sin(leftOrRight * Math.PI/180);
		}		
		
		
		public function moveMissle():void
		{
			var yDistance:Number=0;
			var xDistance:Number=0;
			var angle:Number=0;
			var loc4:Number=0;
			var loc5:Number=0;
			var loc6:Number=0;
			
			//如果不在追踪
			if (!this._launching) 
			{
				if (this.target != null) 
				{
					this.targetX = this.target.x + this.target.xAdjust;
					this.targetY = this.target.y + this.target.yAdjust;
//					this.lastTargetDestination.x = this.target.x + this.target.xAdjust;
//					this.lastTargetDestination.y = this.target.y + this.target.yAdjust;
				}
			}
			xDistance = this.targetX - this.x;
			yDistance = this.targetY - this.y;
			loc4 = Math.atan2(yDistance, xDistance);
			angle = loc4;//trace("angle:",loc4," x ",xDistance," y ",yDistance);
			if (!this._launching) 
			{
				//追踪
				if (this.follow) 
				{
					angle = (angle * 180 / Math.PI + this.stepAngle) * Math.PI / 180;
					if (this.aceleration < this.maxAceleration) 
					{
						this.aceleration = this.aceleration + this.aceleration * 0.1;
						if (this.aceleration >= this.maxAceleration) 
						{
							this.aceleration = this.maxAceleration;
						}
					}
				}
				else 
				{
					if (!this.leftOrRight) 
					{
						if (this.x > this.targetX) 
						{
							this._with = 10;
						}
						else 
						{
							this._with = -10;
						}
						this.leftOrRight = true;
					}
					loc6 = (180 / Math.PI * Math.atan2(this.acelerationYaw, this.acelerationPitch));
					angle = (loc6 + this._with) * Math.PI / 180;
					if (getAngle((loc4 * 180 / Math.PI), loc6) < 11) 
					{
						this.follow = true;
					}
				}
			}
			this.acelerationPitch = Math.cos(angle) * this.aceleration;
			this.acelerationYaw = Math.sin(angle) * this.aceleration;
			this.rotation = 360 - Math.atan2(-this.acelerationYaw, this.acelerationPitch) * 180 / Math.PI;
			this.x = this.x + this.acelerationPitch;
			this.y = this.y + this.acelerationYaw;
			//this.freeParticles();
			var ace:Number = Math.sqrt(Math.pow(this.targetY - this.y, 2) + Math.pow(this.targetX - this.x, 2));
			//trace("aceleration:",ace," ",this.aceleration);
			if (ace < this.aceleration) 
			{
				if (this._launching) 
				{
					this._launching = false;
					if (this.target == null)// || !this.target.isActive) 
					{
//						this.targetX = this.lastTargetDestination.x;
//						this.targetY = this.lastTargetDestination.y;
					}
					else 
					{
						targetX = this.target.x + this.target.xAdjust;
						targetY = this.target.y + this.target.yAdjust;
					}
				}
				else 
				{
					this.hit();
				}
			}
			return;
		}
		public function moveMissle2():void
		{
			var yDistance:Number=0;
			var xDistance:Number=0;
			var angle:Number=0;
			var tempAngle:Number=0;
			var headAngle:Number=0;
			
			//修正目标(因为开始先是朝天弹射)
			if (!this._launching) 
			{
				if (this.target != null) 
				{
					this.targetX = this.target.x + this.target.xAdjust;
					this.targetY = this.target.y + this.target.yAdjust;
				}
			}
			xDistance = this.targetX - this.x;
			yDistance = this.targetY - this.y;
			tempAngle = angle = Math.atan2(yDistance, xDistance);
			//修正目标(因为开始先是朝天弹射)
			if (!this._launching) 
			{
				//追踪
				if (this.follow) 
				{
					angle = (angle * 180 / Math.PI + this.stepAngle) * Math.PI / 180;
					if (this.aceleration < this.maxAceleration) 
					{
						this.aceleration = this.aceleration + this.aceleration * 0.1;
						if (this.aceleration >= this.maxAceleration) 
						{
							this.aceleration = this.maxAceleration;
						}
					}
				}
				else 
				{
					if (_lr>0) 
					{
						this._with = -10;
					}
					else 
					{
						this._with = 10;
					}
					//朝向目标角度
					headAngle = (180 / Math.PI * Math.atan2(this.acelerationYaw, this.acelerationPitch));
					//角度步进
					angle = (headAngle + this._with) * Math.PI / 180;
					if (getAngle((tempAngle * 180 / Math.PI), headAngle) < 11) 
					{
						this.follow = true;
					}
				}
			}
			this.acelerationPitch = Math.cos(angle) * this.aceleration;
			this.acelerationYaw = Math.sin(angle) * this.aceleration;
			this.rotation = 360 - Math.atan2(-this.acelerationYaw, this.acelerationPitch) * 180 / Math.PI;
			this.x = this.x + this.acelerationPitch;
			this.y = this.y + this.acelerationYaw;
			//弹射距离 或 目标距离
 			var distance:Number = Math.sqrt(Math.pow(this.targetY - this.y, 2) + Math.pow(this.targetX - this.x, 2));
			//加速阶段完成
			if (distance < this.aceleration) 
			{
				if (this._launching) 
				{
					this._launching = false;
					if (this.target == null)// || !this.target.isActive) 
					{
						//						this.targetX = this.lastTargetDestination.x;
						//						this.targetY = this.lastTargetDestination.y;
					}
					else 
					{
						targetX = this.target.x + this.target.xAdjust;
						targetY = this.target.y + this.target.yAdjust;
					}
				}
				else 
				{
					this.hit();
				}
			}
			return;
		}		
		/**
		 * _-O2
		 * @param arg1
		 * @param arg2
		 * @return 
		 * 
		 */
		protected function getAngle(arg1:Number, arg2:Number):Number
		{
			return Math.abs((arg1 + 180 - arg2) % 360 - 180);
		}
		
		public function initBomb():void{
			this.t0 = 0;
			this.t1 = 50;//飞行时间原为19
			this.originX = this.x;
			this.originY = this.y;	
			this.targetX = target.x;	
			this.targetY = target.y;	
			this.speedX = (this.targetX - this.originX) / this.t1;
			this.speedY = (this.targetY - this.originY - this.g * this.t1 * this.t1 / 2) / this.t1;
		}
		
		public function moveBomb():void
		{

			this.x = this.originX + this.t0 * this.speedX;
			this.y = this.originY + this.t0 * this.speedY + this.g * this.t0 * this.t0 / 2;//s=vt+at^2/2
			//this.rotation = this.rotation + 20;
			if (this.t0 == this.t1) 
			{
				this.hit();
				return;
			}
			this.t0++;
		}
	}
}