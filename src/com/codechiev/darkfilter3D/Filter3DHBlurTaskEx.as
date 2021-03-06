package com.codechiev.darkfilter3D
{
	import away3d.cameras.Camera3D;
	import away3d.core.managers.Stage3DProxy;
	
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import away3d.filters.tasks.Filter3DTaskBase;
	
	public class Filter3DHBlurTaskEx extends Filter3DTaskBase
	{
		private static var MAX_AUTO_SAMPLES:int = 15;
		private var _amount:uint;
		private var _data:Vector.<Number>;
		private var _stepSize:int = 1;
		private var _realStepSize:Number;
		
		private var _filter:DarkFilter3D;//FIXME
		/**
		 * Creates a new Filter3DHDepthOfFFieldTask
		 * @param amount The maximum amount of blur to apply in pixels at the most out-of-focus areas
		 * @param stepSize The distance between samples. Set to -1 to autodetect with acceptable quality.
		 */
		public function Filter3DHBlurTaskEx(amount:uint, stepSize:int = -1, filter:DarkFilter3D = null)
		{
			super();
			_amount = amount;
			_data = Vector.<Number>([0, 0, 0, 1]);
			this.stepSize = stepSize;
			
			_filter = filter;
		}
		
		public function get amount():uint
		{
			return _amount;
		}
		
		public function set amount(value:uint):void
		{
			if (value == _amount)
				return;
			_amount = value;
			
			invalidateProgram3D();
			updateBlurData();
			calculateStepSize();
		}
		
		public function get stepSize():int
		{
			return _stepSize;
		}
		
		public function set stepSize(value:int):void
		{
			if (value == _stepSize)
				return;
			_stepSize = value;
			calculateStepSize();
			invalidateProgram3D();
			updateBlurData();
		}
		
		override protected function getFragmentCode():String
		{
			var code:String;
			var numSamples:int = 1;
			
			code = "mov ft0, v0	\n" +
				"sub ft0.x, v0.x, fc0.x\n";
			
			code += "tex ft1, ft0, fs0 <2d,linear,clamp>\n";
			
			for (var x:Number = _realStepSize; x <= _amount; x += _realStepSize) {
				code += "add ft0.x, ft0.x, fc0.y	\n" +
					"tex ft2, ft0, fs0 <2d,linear,clamp>\n" +
					"add ft1, ft1, ft2 \n";
				++numSamples;
			}
			
			//FIXME
			code += "mul ft1, ft1, fc1\n";
			code += "add ft1, ft1, fc2\n";
			
			code += "mul oc, ft1, fc0.z";
			
			_data[2] = 1/numSamples;
			
			return code;
		}
		
		override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void
		{
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _data, 1);
			
			//FIXME
			_filter.activate();
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, _filter.colorTransformData, 2);			
			
		}
		
		override protected function updateTextures(stage:Stage3DProxy):void
		{
			super.updateTextures(stage);
			
			updateBlurData();
		}
		
		private function updateBlurData():void
		{
			// todo: must be normalized using view size ratio instead of texture
			var invW:Number = 1/_textureWidth;
			
			_data[0] = _amount*.5*invW;
			_data[1] = _realStepSize*invW;
		}
		
		private function calculateStepSize():void
		{
			_realStepSize = _stepSize > 0? _stepSize :
				_amount > MAX_AUTO_SAMPLES? _amount/MAX_AUTO_SAMPLES :
				1;
		
		}
	}
}
