package com.codechiev.darkfilter3D
{	
	import __AS3__.vec.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.filters.*;
	import away3d.materials.utils.*;
	import flash.display3D.*;
	import flash.display3D.textures.*;
	import flash.geom.*;
	import away3d.filters.tasks.Filter3DHBlurTask;
	import away3d.filters.tasks.Filter3DVBlurTask;
	import away3d.core.managers.Stage3DProxy;
	
	final public class DarkFilter3D extends Filter3DBase
	{
		private var _hBlurTask:Filter3DHBlurTaskEx;
		private var _vBlurTask:Filter3DVBlurTaskEx;
		private var _colorTransformData:Vector.<Number>;
		//private var _blurFilter:Filter3DBase;
		//private var _needUpdate:Boolean = true;
		
		public var colorTransform:ColorTransform;
		
		public function DarkFilter3D(blurX:uint = 3, blurY:uint = 3, stepSize:int = -1)
		{
			super();
			addTask(_hBlurTask = new Filter3DHBlurTaskEx(blurX, stepSize, this));
			addTask(_vBlurTask = new Filter3DVBlurTaskEx(blurY, stepSize, this));
			colorTransform = new ColorTransform();
			_colorTransformData = new Vector.<Number>(8, true);
		}// end function
		
		public function activate():void{
			_colorTransformData[0] = colorTransform.redMultiplier;
			_colorTransformData[1] = colorTransform.greenMultiplier;
			_colorTransformData[2] = colorTransform.blueMultiplier;
			_colorTransformData[3] = colorTransform.alphaMultiplier;
			_colorTransformData[4] = colorTransform.redOffset / 255;
			_colorTransformData[5] = colorTransform.greenOffset / 255;
			_colorTransformData[6] = colorTransform.blueOffset / 255;
			_colorTransformData[7] = colorTransform.alphaOffset / 255;
		}

		override public function setRenderTargets(mainTarget:Texture, stage3DProxy:Stage3DProxy):void
		{
			_hBlurTask.target = _vBlurTask.getMainInputTexture(stage3DProxy);
			super.setRenderTargets(mainTarget, stage3DProxy);
		}
		
		public function get blurX():uint
		{
			return _hBlurTask.amount;
		}
		
		public function set blurX(value:uint):void
		{
			_hBlurTask.amount = value;
		}
		
		public function get blurY():uint
		{
			return _vBlurTask.amount;
		}
		
		public function set blurY(value:uint):void
		{
			_vBlurTask.amount = value;
		}

		public function get colorTransformData():Vector.<Number>
		{
			return _colorTransformData;
		}

	}
}