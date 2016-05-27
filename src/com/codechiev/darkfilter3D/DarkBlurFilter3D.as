package com.codechiev.darkfilter3D
{
    import __AS3__.vec.*;
    import away3d.cameras.*;
    import away3d.debug.*;
    import com.adobe.utils.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import away3d.filters.Filter3DBase;
    import away3d.core.managers.Stage3DProxy;
    import flash.geom.ColorTransform;

    public class DarkBlurFilter3D extends Filter3DBase
    {
		private var _BlurTask:BlurTaskEx;
		
        public function DarkBlurFilter3D(blurX:uint = 3, blurY:uint = 3, mul:Number = 1)
        {
			addTask(_BlurTask = new BlurTaskEx(blurX,blurY, mul));
        }// end function


		override public function setRenderTargets(mainTarget:Texture, stage3DProxy:Stage3DProxy):void
		{
			_BlurTask.target = _BlurTask.getMainInputTexture(stage3DProxy);
			super.setRenderTargets(mainTarget, stage3DProxy);
		}
    }
}
