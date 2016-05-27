package com.codechiev
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	
	import flash.geom.Vector3D;	
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.display.Stage;
	import caurina.transitions.*;
	import away3d.core.base.Object3D;

	public class SteadyCamera extends Camera3D
	{
		public static const HEIGHT:Number = 100;
		public static const TGT_HEIGHT:Number = 35;
		
		private var _stage:Stage;
		
		private const _target:ObjectContainer3D = new ObjectContainer3D();;
		public var lookOffset:Vector3D = new Vector3D(0, 2, 10);
		public var positionOffset:Vector3D = new Vector3D(0, 5, -50);;
		private var _lookAtPosition:Vector3D = new Vector3D();
		private var _xLookOffset:Vector3D = new Vector3D();
		private var _xPositionOffset:Vector3D = new Vector3D();
		
		public var _paralaxmul:Number = 0;
		private var _paralax:Point = new Point();
		private var _walkheight:Number = 0;
		private var _walkMov:Vector3D = new Vector3D();
		private var _walkMovCycle:Number = 0;

		private var _breathMov:Vector3D = new Vector3D();
		private var _breathMovCycle:Number = 0;
		
		private var _walk:Boolean = false;
		private var walkspeed:Number = 0;
		private var walkdirx:Number = 0;
		private var walkdirz:Number = 0;
		
		public var dirx:Number = 0;
		public var dirz:Number = 0;

		private var ldir:Vector3D = new Vector3D();
		
		public var springTarget:Object3D;
		
		public function SteadyCamera(stage:Stage)
		{
			_stage = stage;
			
			//position = new Vector3D(80 * 2, 100 * 2, 50 * 2);
			//positionOffset = new Vector3D(8 * 2, 10 * 2, 5 * 2);
			lens.far = 90000;
			lens.near = 5;
			//idle();
			_build();
		}
		
		//1.5
		public function stepIdle(param1:Number) : void
		{
			this._xPositionOffset = this._target.transform.deltaTransformVector(this.positionOffset);
			position = this._target.position.add(this._xPositionOffset);
			this._xLookOffset = this._target.transform.deltaTransformVector(this.lookOffset);
			this._lookAtPosition = this._target.position.add(this._xLookOffset);
			lookAt(this._lookAtPosition);
			return;
		}// end function
		
		public function setManual():void{
			//this._initWalkKeys();
			this._walkheight = y;
			this._walkMovCycle = (-Math.PI) / 2;
			this._breathMovCycle = (-Math.PI) / 2;
			this._paralax.y = 0;
			this._paralax.x = 0;
			this._paralaxmul = 0;
			Tweener.addTween(this, {_paralaxmul:1, time:1.2, transition:"linear"});	
		}
		
		public function stepManual(param1:Number) : void
		{
			this._walk = this.dirx != 0 || this.dirz != 0;
			
			var _loc_3:* = Vector3D.distance(springTarget.position, position);
			this.ldir.x = this.dirx;
			this.ldir.y = 0;
			this.ldir.z = this.dirz;
			if (_loc_3 < 500 && this.ldir.z > 0)
			{
				this.ldir.z = 0;
				if (this.dirx == 0)
				{
					this._walk = false;
				}
			}
			else if (_loc_3 > 2000 && this.ldir.z < 0)
			{
				this.ldir.z = 0;
				if (this.dirx == 0)
				{
					this._walk = false;
				}
			}
			this.ldir = transform.deltaTransformVector(this.ldir);
			this.ldir.normalize();
			if (this._walkMovCycle > Math.PI)
			{
				this._walkMovCycle = this._walkMovCycle - Math.PI * 2;
				//this.playRandomStep();//play sound of step
			}
			this._breathMovCycle = this._breathMovCycle + 0.06 * param1;
			if (this._walk)
			{
				this._walkMovCycle = this._walkMovCycle + 0.18 * param1;
				if (this.walkspeed < 1)
				{
					this.walkspeed = this.walkspeed + 0.065 * param1;
				}
				this.walkdirx = 0.7 * this.walkdirx + 0.3 * this.ldir.x;
				this.walkdirz = 0.7 * this.walkdirz + 0.3 * this.ldir.z;
				_loc_3 = Math.sqrt(this.walkdirx * this.walkdirx + this.walkdirz * this.walkdirz);
				this.walkdirx = this.walkdirx / _loc_3;
				this.walkdirz = this.walkdirz / _loc_3;
			}
			else
			{
				this._walkMovCycle = this._walkMovCycle * 0.95;
				this.walkspeed = this.walkspeed * 0.9;
				this.walkdirx = this.walkdirx * 0.9;
				this.walkdirz = this.walkdirz * 0.9;
			}
			this._walkMov.y = Math.max(6 * Math.sin(this._walkMovCycle + Math.PI / 2), -4);
			this._breathMov.y = 0.7 * Math.sin(this._breathMovCycle + Math.PI / 2);
			this._walkheight = this._walkheight + (HEIGHT - this._walkheight) * 0.07;
			var _loc_4:* = (Math.sin(this._walkMovCycle + Math.PI / 2) + 1) * 0.1 + 0.8;
			x = x + (this.walkdirx * this.walkspeed * 8 * _loc_4 * param1 + this._breathMov.x);
			z = z + (this.walkdirz * this.walkspeed * 8 * _loc_4 * param1 + this._breathMov.z);
			y = this._walkheight + this._walkMov.y + this._breathMov.y;
			this.lookOffset.x = 0;
			this.lookOffset.y = TGT_HEIGHT + this._breathMov.y;
			this.lookOffset.z = 0;
			this._xLookOffset = springTarget.transform.deltaTransformVector(this.lookOffset);
			this._lookAtPosition = springTarget.position.add(this._xLookOffset);
			var _loc_5:* = this._stage.mouseX / this._stage.stageWidth * 2 - 1;
			var _loc_6:* = this._stage.mouseY / this._stage.stageHeight * 2 - 1;
			this._paralax.x = this._paralax.x + (_loc_5 - this._paralax.x) * 0.1;
			this._paralax.y = this._paralax.y + (_loc_6 - this._paralax.y) * 0.1;
			var _loc_7:* = this._lookAtPosition.subtract(position);
			var _loc_8:* = this._lookAtPosition.subtract(position).crossProduct(Vector3D.Y_AXIS);
			var _loc_9:* = _loc_7.crossProduct(_loc_8);
			_loc_8.normalize();
			_loc_9.normalize();
			_loc_8.scaleBy((-this._paralax.x) * 50 * this._paralaxmul);
			_loc_9.scaleBy(this._paralax.y * 30 * this._paralaxmul);
			this._lookAtPosition.incrementBy(_loc_8);
			this._lookAtPosition.incrementBy(_loc_9);
			lookAt(this._lookAtPosition);
			return;
		}// end function
		
		private function _build() : void
		{
			this._grabMeasures();
		}// end function
		
		private var stage:Stage;
		public var azMin:Number = 0.033;
		public var azMax:Number = 1.4;
		private var _down:Boolean;
		private var _lastWheel:int = -1;
		private var downPosition:Point;
		private var m1:Matrix3D;
		private var m2:Matrix3D;
		private var _hAngle:Number;
		private var _vAngle:Number;
		private var _dist:Number;
		private var _nhAngle:Number;
		private var _nvAngle:Number;
		private static const UP:Vector3D = new Vector3D(0, 1, 0);
		private static const Z:Vector3D = new Vector3D(0, 0, 1);
		private function _grabMeasures() : void
		{
			var radius:Number = Math.sqrt(positionOffset.x * positionOffset.x + positionOffset.z * positionOffset.z);
			_nhAngle = Math.atan2(-positionOffset.z, positionOffset.x);
			var _loc_3:* = Math.atan2(positionOffset.y, radius);
			this._nvAngle = Math.atan2(positionOffset.y, radius);
			this._vAngle = _nhAngle;
			this._dist = Math.sqrt(radius * radius + positionOffset.y * positionOffset.y);
		}// end function
	}
}