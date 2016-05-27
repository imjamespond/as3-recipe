package com.codechiev.darkfilter3D
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.filters.tasks.Filter3DTaskBase;
	
	import flash.display3D.Context3DProgramType;
	import flash.geom.ColorTransform;

	import flash.display3D.textures.Texture;
	
	public class BlurTaskEx extends Filter3DTaskBase
	{
		private static var MAX_AUTO_SAMPLES:int = 15;
		private var _amount:uint;
		private var _data:Vector.<Number> = Vector.<Number>([0, 0, 0, 1, 0, 0, 0, 0]);
		private var _stepSize:int = 1;
		private var _realStepSize:Number;
		
		protected var _blurX:uint;
		protected var _blurY:uint;
		protected var _stepX:Number = 1;
		protected var _stepY:Number = 1;
		private var _mult:Number=3;

		public var colorTransform:ColorTransform = new ColorTransform();
		private var _colorTransformData:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function BlurTaskEx(blurX:uint = 3, blurY:uint = 3, mul:Number = 1)
		{
			super();
			_mult = mul;
			this._blurX = blurX;
			this._blurY = blurY;
			if (this._blurX > 7)
			{
				this._stepX = this._blurX / 7;
			}
			if (this._blurY > 7)
			{
				this._stepY = this._blurY / 7;
			}
			
			colorTransform.redMultiplier=1.4; colorTransform.blueMultiplier=1.4; colorTransform.greenMultiplier=1.4; 
			colorTransform.redOffset=-110; colorTransform.blueOffset=-110; colorTransform.greenOffset=-110;
		}
		
		public function get blurX() : uint
		{
			return this._blurX;
		}// end function
		
		public function set blurX(param1:uint) : void
		{
			this.invalidateProgram3D();
			this._blurX = param1;
			if (this._blurX > 7)
			{
				this._stepX = this._blurX / 7;
			}
			else
			{
				this._stepX = 1;
			}
			return;
		}// end function
		
		public function get blurY() : uint
		{
			return this._blurY;
		}// end function
		
		public function set blurY(param1:uint) : void
		{
			this.invalidateProgram3D();
			this._blurY = param1;
			if (this._blurY > 7)
			{
				this._stepY = this._blurY / 7;
			}
			else
			{
				this._stepY = 1;
			}
			return;
		}// end function
		
		override protected function getFragmentCode():String
		{
			var code:String = null;
			var blurXInc:Number = NaN;
			var numSamples:int = 0;
			code = "mov ft0, v0\t\n" + "sub ft0.y, v0.y, fc0.y\n";//UV
			var blurYInc:Number = 0;
			while (blurYInc <= this._blurY)
			{	
				if (blurYInc > 0)
				{
					code = code + "sub ft0.x, v0.x, fc0.x\n";
				}
				blurXInc = 0;
				while (blurXInc <= this._blurX)
				{
					numSamples++;
					if (blurXInc == 0 && blurYInc == 0)
					{
						code = code + "tex ft1, ft0, fs0 <2d,nearest,clamp>\n";
					}
					else
					{
						code = code + ("tex ft2, ft0, fs0 <2d,nearest,clamp>\n" + "add ft1, ft1, ft2 \n");
					}
					if (blurXInc < this._blurX)
					{
						code = code + "add ft0.x, ft0.x, fc1.x\t\n";//位移U
					}
					blurXInc = blurXInc + this._stepX;
				}
				if (blurYInc < this._blurY)
				{
					code = code + "add ft0.y, ft0.y, fc1.y\t\n";//位移V
				}
				blurYInc = blurYInc + this._stepY;
			}
			code += "mul ft1, ft1, fc0.z\n";
			
			//dark filter
			code += "mul ft1, ft1, fc2\n";
			code += "add ft1, ft1, fc3\n";
			
			code += "mov oc, ft1";//消除重叠倍数
			_data[2] = 1 / numSamples;//fc0.z
			return code;
		}
		
		override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void
		{	
			//FIXME
			var _loc_5:* = 1 / _textureWidth;
			var _loc_6:* = 1 / _textureHeight;
			this._data[0] = this._blurX * 0.5 * _loc_5 * this._mult;
			this._data[1] = this._blurY * 0.5 * _loc_6 * this._mult;
			this._data[4] = this._stepX * _loc_5 * this._mult;
			this._data[5] = this._stepY * _loc_6 * this._mult;
			
			_colorTransformData[0] = colorTransform.redMultiplier;
			_colorTransformData[1] = colorTransform.greenMultiplier;
			_colorTransformData[2] = colorTransform.blueMultiplier;
			_colorTransformData[3] = colorTransform.alphaMultiplier;
			_colorTransformData[4] = colorTransform.redOffset / 255;
			_colorTransformData[5] = colorTransform.greenOffset / 255;
			_colorTransformData[6] = colorTransform.blueOffset / 255;
			_colorTransformData[7] = colorTransform.alphaOffset / 255;
			
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 2);	
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, _colorTransformData, 2);	
		}
		
		override protected function updateTextures(stage:Stage3DProxy):void
		{
			super.updateTextures(stage);
			
			updateBlurData();
		}
		
		private function updateBlurData():void
		{
			// todo: must be normalized using view size ratio instead of texture
			var invH:Number = 1/_textureHeight;
			
			_data[0] = _amount*.5*invH;
			_data[1] = _realStepSize*invH;
		}
		
		private function calculateStepSize():void
		{
			_realStepSize = _stepSize > 0? _stepSize :
				_amount > MAX_AUTO_SAMPLES? _amount/MAX_AUTO_SAMPLES :
				1;
		}

		public function setColorTransform(colorTransform:ColorTransform):void
		{
			// TODO Auto Generated method stub
			
		}
	}
}
