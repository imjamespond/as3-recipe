package com.codechiev.away3d
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.core.math.*;
	public class AwayObject
	{
		protected var _rotationX:Number = 0;
		protected var _rotationY:Number = 0;
		protected var _rotationZ:Number = 0;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _z:Number = 0;
		
		private var _viewProjection:Matrix3D = new Matrix3D();
		//private var _sceneTransform:Matrix3D = new Matrix3D();
		private var _inverseSceneTransform:Matrix3D = new Matrix3D();
		private var _transform:Matrix3D = new Matrix3D();
		private var _scenePosition:Vector3D = new Vector3D();
		
		protected var _pos:Vector3D = new Vector3D();
		protected var _rot:Vector3D = new Vector3D();
		protected var _sca:Vector3D = new Vector3D();
		protected var _transformComponents:Vector.<Vector3D>;
		protected var _pivotPoint:Vector3D = new Vector3D();
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
		protected var _scaleZ:Number = 1;
		//private var _positionDirty:Boolean;
		//private var _rotationDirty:Boolean;
		//private var _scaleDirty:Boolean;
		
		public function AwayObject()
		{
			// Cached vector of transformation components used when
			// recomposing the transform matrix in updateTransform()
			_transformComponents = new Vector.<Vector3D>(3, true);
			_transformComponents[0] = _pos;
			_transformComponents[1] = _rot;
			_transformComponents[2] = _sca;
		}		

		/**
		 * The inverse scene transform object that transforms from world to model space.
		 */
		public function get inverseSceneTransform():Matrix3D
		{
			_inverseSceneTransform.copyFrom(transform);
			_inverseSceneTransform.invert();
			
			return _inverseSceneTransform;
		}

		/**
		 * The global position of the ObjectContainer3D in the scene. The value of the return object should not be changed.
		 */
		public function get scenePosition():Vector3D
		{
			transform.copyColumnTo(3, _scenePosition);	
			return _scenePosition;
		}

		/**
		 * The transformation of the 3d object, relative to the local coordinates of the parent <code>ObjectContainer3D</code>.
		 */
		public function get transform():Matrix3D
		{
			updateTransform();
			
			return _transform;
		}
		
		protected function updateTransform():void
		{
			_pos.x = _x;
			_pos.y = _y;
			_pos.z = _z;
			
			_rot.x = _rotationX;
			_rot.y = _rotationY;
			_rot.z = _rotationZ;
			
			_sca.x = 1;
			_sca.y = 1;
			_sca.z = 1;
			
			_transform.recompose(_transformComponents);
			//_transform.appendTranslation(_pivotPoint.x, _pivotPoint.y, _pivotPoint.z);
			//_transform.prependTranslation(-_pivotPoint.x, -_pivotPoint.y, -_pivotPoint.z);
			_transform.prependScale(_scaleX, _scaleY, _scaleZ);
			
			_sca.x = _scaleX;
			_sca.y = _scaleY;
			_sca.z = _scaleZ;
		}
		
		private function invalidateRotation():void
		{
			//invalidateTransform();
		}
		private function invalidatePosition():void
		{
			//invalidateTransform();
		}

		public function get rotationX():Number
		{
			return _rotationX*MathConsts.RADIANS_TO_DEGREES;
		}

		public function set rotationX(val:Number):void
		{
			if (rotationX == val)
				return;
			
			_rotationX = val*MathConsts.DEGREES_TO_RADIANS;
			
			invalidateRotation();
		}

		public function get rotationY():Number
		{
			return _rotationY*MathConsts.RADIANS_TO_DEGREES;
		}

		public function set rotationY(val:Number):void
		{
			if (_rotationY == val)
				return;
			
			 _rotationY = val*MathConsts.DEGREES_TO_RADIANS;
			
			invalidateRotation();
		}

		public function get rotationZ():Number
		{
			return _rotationZ*MathConsts.RADIANS_TO_DEGREES;
		}

		public function set rotationZ(val:Number):void
		{
			if (_rotationZ == val)
				return;
			
			_rotationZ = val*MathConsts.DEGREES_TO_RADIANS;
			
			invalidateRotation();
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(val:Number):void
		{
			if (_x == val)
				return;
			
			_x = val;
			
			invalidatePosition();
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(val:Number):void
		{
			if (_y == val)
				return;
			
			_y = val;
			
			invalidatePosition();
		}

		public function get z():Number
		{
			return _z;
		}

		public function set z(val:Number):void
		{
			if (_z == val)
				return;
			
			_z = val;
			
			invalidatePosition();
		}

	}
}