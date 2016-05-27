package com.codechiev.away3d
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;

	public class AwayLens
	{		
		/**
		* Default option, projects to a left-handed coordinate system
		*/
		public static const LEFT_HANDED:uint = 0;
		
		/**
		 * Projects to a right-handed coordinate system
		 */
		public static const RIGHT_HANDED:uint = 1;
		/**
		 * A reference to a Vector to be used as a temporary raw data container, to prevent object creation.
		 */
		public static const RAW_DATA_CONTAINER:Vector.<Number> = new Vector.<Number>(16);
		
		protected var _matrix:Matrix3D = new Matrix3D();
		protected var _scissorRect:Rectangle = new Rectangle();
		protected var _viewPort:Rectangle = new Rectangle();
		protected var _near:Number = 20;
		protected var _far:Number = 3000;
		protected var _aspectRatio:Number = 1;
		
		protected var _matrixInvalid:Boolean = true;
		protected var _frustumCorners:Vector.<Number> = new Vector.<Number>(8*3, true);
		
		private var _unprojection:Matrix3D;
		private var _unprojectionInvalid:Boolean = true;
		
		//PerspectiveLens
		private var _fieldOfView:Number;
		private var _focalLength:Number;
		private var _focalLengthInv:Number;
		private var _yMax:Number;
		private var _xMax:Number;
		private var _coordinateSystem:uint;
		
		public function AwayLens()
		{
		}
		
		public function setPerspective(fieldOfView:Number = 60, coordinateSystem:uint = 0):void{	
			this.fieldOfView = fieldOfView;
			this.coordinateSystem = coordinateSystem;
		}
		
		/**
		 * The projection matrix that transforms 3D geometry to normalized homogeneous coordinates.
		 */
		public function get matrix():Matrix3D
		{
			updateMatrix();
			return _matrix;
		}
		
		/**
		 * The distance to the near plane of the frustum. Anything behind near plane will not be rendered.
		 */
		public function get near():Number
		{
			return _near;
		}
		
		public function set near(value:Number):void
		{
			if (value == _near)
				return;
			_near = value;
		}
		
		/**
		 * The distance to the far plane of the frustum. Anything beyond the far plane will not be rendered.
		 */
		public function get far():Number
		{
			return _far;
		}
		
		public function set far(value:Number):void
		{
			if (value == _far)
				return;
			_far = value;
		}
		
		/**
		 * The vertical field of view of the projection in degrees.
		 */
		public function get fieldOfView():Number
		{
			return _fieldOfView;
		}
		
		public function set fieldOfView(value:Number):void
		{
			if (value == _fieldOfView)
				return;
			
			_fieldOfView = value;
			
			//计算焦距f, 该值仅影响x,y的scale从而决定物体在画面的大小,并不影响z轴的值
			_focalLengthInv = Math.tan(_fieldOfView*Math.PI/360);
			_focalLength = 1/_focalLengthInv;
			
			//invalidateMatrix();
		}
		/**
		 * The handedness of the coordinate system projection. The default is LEFT_HANDED.
		 */
		public function get coordinateSystem():uint
		{
			return _coordinateSystem;
		}
		
		public function set coordinateSystem(value:uint):void
		{
			if (value == _coordinateSystem)
				return;
			
			_coordinateSystem = value;
			
			//invalidateMatrix();
		}
		
		protected function updateMatrix():void
		{
			var raw:Vector.<Number> = RAW_DATA_CONTAINER;
			
			_yMax = _near*_focalLengthInv;//最高
			_xMax = _yMax*_aspectRatio;//最宽
			
			var left:Number, right:Number, top:Number, bottom:Number;
			
			if (_scissorRect.x == 0 && _scissorRect.y == 0 && _scissorRect.width == _viewPort.width && _scissorRect.height == _viewPort.height) {
				// assume unscissored frustum
				left = -_xMax;
				right = _xMax;
				top = -_yMax;
				bottom = _yMax;
				// assume unscissored frustum
				raw[uint(0)] = _near/_xMax;//scaleX
				raw[uint(5)] = _near/_yMax;//scaleY
				raw[uint(10)] = _far/(_far - _near);//scaleZ
				raw[uint(11)] = 1;
				raw[uint(1)] = raw[uint(2)] = raw[uint(3)] = raw[uint(4)] =
					raw[uint(6)] = raw[uint(7)] = raw[uint(8)] = raw[uint(9)] =
					raw[uint(12)] = raw[uint(13)] = raw[uint(15)] = 0;//rotation and traslation
				raw[uint(14)] = -_near*raw[uint(10)];//near*scaleZ?
			} else {
				// assume scissored frustum
				var xWidth:Number = _xMax*(_viewPort.width/_scissorRect.width);
				var yHgt:Number = _yMax*(_viewPort.height/_scissorRect.height);
				var center:Number = _xMax*(_scissorRect.x*2 - _viewPort.width)/_scissorRect.width + _xMax;
				var middle:Number = -_yMax*(_scissorRect.y*2 - _viewPort.height)/_scissorRect.height - _yMax;
				
				left = center - xWidth;
				right = center + xWidth;
				top = middle - yHgt;
				bottom = middle + yHgt;
				
				raw[uint(0)] = 2*_near/(right - left);
				raw[uint(5)] = 2*_near/(bottom - top);
				raw[uint(8)] = (right + left)/(right - left);
				raw[uint(9)] = (bottom + top)/(bottom - top);
				raw[uint(10)] = (_far + _near)/(_far - _near);
				raw[uint(11)] = 1;
				raw[uint(1)] = raw[uint(2)] = raw[uint(3)] = raw[uint(4)] =
					raw[uint(6)] = raw[uint(7)] = raw[uint(12)] = raw[uint(13)] = raw[uint(15)] = 0;
				raw[uint(14)] = -2*_far*_near/(_far - _near);
			}
			
			// Switch projection transform from left to right handed.
			if (_coordinateSystem == RIGHT_HANDED)
				raw[uint(5)] = -raw[uint(5)];
			
			_matrix.copyRawDataFrom(raw);
			/*
			var yMaxFar:Number = _far*_focalLengthInv;
			var xMaxFar:Number = yMaxFar*_aspectRatio;
			
			_frustumCorners[0] = _frustumCorners[9] = left;
			_frustumCorners[3] = _frustumCorners[6] = right;
			_frustumCorners[1] = _frustumCorners[4] = top;
			_frustumCorners[7] = _frustumCorners[10] = bottom;
			
			_frustumCorners[12] = _frustumCorners[21] = -xMaxFar;
			_frustumCorners[15] = _frustumCorners[18] = xMaxFar;
			_frustumCorners[13] = _frustumCorners[16] = -yMaxFar;
			_frustumCorners[19] = _frustumCorners[22] = yMaxFar;
			
			_frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = _near;
			_frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = _far;
			
			_matrixInvalid = false;*/
		}
		
		public function updateScissorRect(x:Number, y:Number, width:Number, height:Number):void
		{
			_scissorRect.x = x;
			_scissorRect.y = y;
			_scissorRect.width = width;
			_scissorRect.height = height;
			//invalidateMatrix();
		}
		
		public function updateViewport(x:Number, y:Number, width:Number, height:Number):void
		{
			_viewPort.x = x;
			_viewPort.y = y;
			_viewPort.width = width;
			_viewPort.height = height;
			//invalidateMatrix();
		}
	}
}