package com.codechiev.away3d
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.core.math.*;
	public class AwayCamera extends AwayObject
	{
		private var _lens:AwayLens;
		
		private var _viewProjection:Matrix3D = new Matrix3D();
		//private var _sceneTransform:Matrix3D = new Matrix3D();
		private var _inverseSceneTransform:Matrix3D = new Matrix3D();
		private var _transform:Matrix3D = new Matrix3D();
		private var _scenePosition:Vector3D = new Vector3D();
		

		
		public function AwayCamera()
		{
			//setup default lens
			_lens = new AwayLens();
			_lens.setPerspective();
		}		
		/**
		* The view projection matrix of the camera.
		*/
		public function get viewProjection():Matrix3D
		{
			_viewProjection.copyFrom(inverseSceneTransform);
			_viewProjection.append(_lens.matrix);//镜头变换

			return _viewProjection;
		}
		

		public function get lens():AwayLens
		{
			return _lens;
		}

		public function set lens(value:AwayLens):void
		{
			_lens = value;
		}

	}
}