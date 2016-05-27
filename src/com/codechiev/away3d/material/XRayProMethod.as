
package com.codechiev.away3d.material
{
	import flash.display3D.*;
	import away3d.arcane;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.MethodVO;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.compilation.ShaderRegisterCache;
	import away3d.materials.compilation.ShaderRegisterElement;
	use namespace arcane;
	public class XRayProMethod extends EffectMethodBase
	{
		
		private var _color:uint;
		private var _r:Number = 0;
		private var _g:Number = 0;
		private var _b:Number = 0;
		private var _a:Number = 0;
		
		public function XRayProMethod()
		{
			super();
		}
		
		public function get xrayColor():uint
		{
			return _color;
		}
		
		public function set xrayColor(value:uint):void
		{
			_color = value;
			_r = ((_color >> 16) & 0xff) / 0xff;
			_g = ((_color >> 8) & 0xff) / 0xff;
			_b = (_color & 0xff) / 0xff;
		}
		public function get xrayAlpha():Number
		{
			return _a;
		}
		
		public function set xrayAlpha(value:Number):void
		{
			_a = value;
		}
		arcane override function initVO(vo:MethodVO):void
		{
			vo.needsNormals = true;
			vo.needsProjection = true;
		}
		
		arcane override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void
		{
			//			if(!_isActive)return;
			var vData:Vector.<Number> = vo.vertexData
			var index:int = vo.fragmentConstantsIndex;
			var data:Vector.<Number> = vo.fragmentData;
			if(_isActive)
			{
				data[index] = _r;
				data[index + 1] = _g;
				data[index + 2] = _b;
				data[index + 3] = _a;
				stage3DProxy.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE);
				stage3DProxy.context3D.setDepthTest(false, Context3DCompareMode.GREATER);
			}else
			{
				data[index] = 1;
				data[index + 1] = 1;
				data[index + 2] = 1;
				data[index + 3] = 0;
				stage3DProxy.context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				stage3DProxy.context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			}
		}
		
		private var _isActive:Boolean = false;
		public function activateEffect():void
		{
			_isActive = true;
		}
		
		public function deactiveEffect():void
		{
			_isActive = false;
		}
		
		arcane override function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
		{
			var dataRegister:ShaderRegisterElement = regCache.getFreeFragmentConstant();
			vo.fragmentConstantsIndex = dataRegister.index * 4;
			
			//var temp1:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			var temp2:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
			var code:String = "";
			
			//			code += "nrm " + temp1 + ".xyz, " + _sharedRegisters.normalVarying + ".xyz \n" +
			//				"dp3 " + temp2 + ".a, " + targetReg + ".xyz, " + _sharedRegisters.projectionFragment + ".xyz \n" +
			//				"sat " + temp2 + ".a, " + temp2 + ".a \n" +
			//				"mov " + temp2 +  ".r, " + dataRegister + ".r \n" +
			//				"mov " + temp2 + ".g, " + dataRegister + ".g \n" +
			//				"mov " + temp2 + ".b, " + dataRegister + ".b \n" +
			//				"mul " + temp2 + ".rgb, " + temp2 + ".rgb, " + temp2 + ".aaa \n" +
			//				"mov " + targetReg + "," + temp2 + "\n";
			//			return code;
			
			code += "mov " + temp2 + ".r, " + dataRegister + ".r \n" +
				"mov " + temp2 + ".g, " + dataRegister + ".g \n" +
				"mov " + temp2 + ".b, " + dataRegister + ".b \n" +
				"mov " + temp2 + ".a, " + dataRegister + ".a \n" +
				//"mul " + temp2 + ".rgb, " + targetReg + ".rgb, " + temp2 + ".rgb \n" +
				"mov " + targetReg + ", " + temp2 + "\n";
			return code;
		}
	}
}