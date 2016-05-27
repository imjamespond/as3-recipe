package com.codechiev.ribbon2
{
	import away3d.bounds.*;
	import away3d.core.base.*;
	
	import flash.display3D.*;
	import flash.geom.*;
	import flash.utils.*;
	import away3d.core.managers.Stage3DProxy;
	
	public class RibbonGeometry extends CompactSubGeometry
	{
		protected var _currentSize:uint = 0;//how many pair of points
		//private var _ba_vertices:ByteArray;
		private var _vertexPos:int = 0;
		//private var _ba_tangents:ByteArray;
		//private var _ba_wave:ByteArray;
		private var _waveindex:uint = 0;
		private var _boundMin:Vector3D;
		private var _boundMax:Vector3D;
		private var _bounds:BoundingVolumeBase;
		private var _miplevel:uint = 0;
		public var stepProgress:Number;
		public static const MAX_VERTEX:uint = 2048;
		//private static var _st_indices:Vector.<Vector.<uint>>;
		//private static var _st_indices_buff:Vector.<Vector.<IndexBuffer3D>>;
		//private static const _ba_uvs:ByteArray = new ByteArray();
		private static var _waveGenerator:WaveBufferGenerator;
		private static var _cwave:uint = 0;
		private static const MAX_MIP:uint = 4;
		
		public function RibbonGeometry()
		{
			super();
			
			var _loc_1:int = 0;
			_numVertices = MAX_VERTEX;
			_numTriangles = MAX_VERTEX - 2;
			_numIndices = _numTriangles * 3;
			_boundMin = new Vector3D(Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE);
			_boundMax = new Vector3D(Number.MIN_VALUE, Number.MIN_VALUE, Number.MIN_VALUE);
			_vertexData = new Vector.<Number>(MAX_VERTEX * vertexStride);
			//_ba_vertices = new ByteArray();
			//_ba_vertices.endian = Endian.LITTLE_ENDIAN;
			//_ba_tangents = new ByteArray();
			//_ba_tangents.endian = Endian.LITTLE_ENDIAN;
			//_ba_wave = new ByteArray();
			//_ba_wave.endian = Endian.LITTLE_ENDIAN;
			//_ba_vertices.length = MAX_VERTEX * 4 * 4;
			//_ba_tangents.length = MAX_VERTEX * 3 * 4;
			//_ba_wave.length = MAX_VERTEX * 4 * 4;
			//if (_ba_uvs.length == 0)
			//{
				_buildUVS();
			//}
			//if (_st_indices == null)
			//{
				//_st_indices_buff = new Vector.<Vector.<IndexBuffer3D>>(MAX_MIP, true);
				//_st_indices = new Vector.<Vector.<uint>>;
				//_loc_1 = 0;
				//while (_loc_1 < MAX_MIP)
				//{
					
					_buildIndices(_loc_1);
					//_loc_1++;
				//}
			//}
			_waveindex = _cwave;
			var _loc_3:* = _cwave + 1;
			_cwave = _loc_3;
			if (_cwave > 1)
			{
				_cwave = 0;
			}
			if (_waveGenerator == null)
			{
				_waveGenerator = new WaveBufferGenerator(2);
				_waveGenerator.offset = new Vector3D(0, 1, 0);
				_waveGenerator.generate();
				_waveGenerator.fadeOut(16);
			}
			_bounds = new AxisAlignedBoundingBox();
			_bounds.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
			
			updateData(_vertexData);
			updateIndexData(_indices);
		}
		
		/*
		override public function dispose() : void
		{
			super.dispose();
			_ba_tangents.clear();
			_ba_vertices.clear();
			_ba_wave.clear();
			return;
		}// end function
		*/
		public function getLength() : uint
		{
			return _currentSize;
		}// end function
		
		private var getPoint:Vector3D = new Vector3D();
		public function getLastPosition() : Vector3D
		{
			if (_currentSize == 0)
			{
				return null;
			}
			_vertexPos = (_currentSize - 1) * vertexStride * 2 ;
			getPoint.x=_vertexData[_vertexPos]; getPoint.y=_vertexData[_vertexPos+1]; getPoint.z=_vertexData[_vertexPos+2];
			//trace("lastPoint pos:",_vertexPos, " - ", getPoint);
			return getPoint;
		}// end function
		
		public function getPositionAt(pair:int = -1) : Vector3D
		{
			if (pair < 0)
			{
				pair = _currentSize + pair;
			}
			if (pair >= _currentSize || pair < 0)
			{
				return null;
			}
			_vertexPos = pair * vertexStride * 2 ;
			getPoint.x=_vertexData[_vertexPos]; getPoint.y=_vertexData[_vertexPos+1]; getPoint.z=_vertexData[_vertexPos+2];
			return getPoint;
			//return new Vector3D(_vertexData[_vertexPos], _vertexData[_vertexPos+1], _vertexData[_vertexPos+2]);
		}// end function
		
		public function updatePointAt(point:Vector3D, power:Number, pointPos:int = -1) : void
		{
			if (pointPos == -1)
			{
				pointPos = _currentSize - 1;
			}
			_boundMin.x = Math.min(_boundMin.x, point.x);
			_boundMin.y = Math.min(_boundMin.y, point.y);
			_boundMin.z = Math.min(_boundMin.z, point.z);
			_boundMax.x = Math.max(_boundMax.x, point.x);
			_boundMax.y = Math.max(_boundMax.y, point.y);
			_boundMax.z = Math.max(_boundMax.z, point.z);
			//_bounds.fromExtremes(_boundMin.x , _boundMin.y, _boundMin.z, _boundMax.x, _boundMax.y, _boundMax.z);
			_vertexPos = pointPos * vertexStride * 2 + vertexOffset;
			_vertexData[_vertexPos+0]=point.x;
			_vertexData[_vertexPos+1]=point.y;
			_vertexData[_vertexPos+2]=point.z;
			_vertexData[_vertexPos+3]=power;
			_vertexPos = pointPos * vertexStride * 2 + vertexStride + vertexOffset;
			_vertexData[_vertexPos+0]=point.x;
			_vertexData[_vertexPos+1]=point.y;
			_vertexData[_vertexPos+2]=point.z;
			_vertexData[_vertexPos+3]=power;
			var lastPoint:Vector3D = getPositionAt((pointPos - 1));
			if (lastPoint)
			{
				point = point.subtract(lastPoint);
				point.normalize();
				_vertexPos = pointPos * vertexTangentStride * 2 + vertexTangentOffset;
				_vertexData[_vertexPos+0]=point.x;
				_vertexData[_vertexPos+1]=point.y;
				_vertexData[_vertexPos+2]=point.z;
				_vertexPos = pointPos * vertexTangentStride * 2 + vertexTangentStride + vertexTangentOffset;
				_vertexData[_vertexPos+0]=point.x;
				_vertexData[_vertexPos+1]=point.y;
				_vertexData[_vertexPos+2]=point.z;
			}
			updateTangents(_currentSize);
			invalidateBounds();
		}// end function
		
		public function addPoint(point:Vector3D, power:Number=0) : Boolean
		{
			if (power <= 0)
			{
				return false;
			}
			if (_currentSize == MAX_VERTEX >> 1)
			{
				return false;
			}
			
			_boundMin.x = Math.min(_boundMin.x, point.x);
			_boundMin.y = Math.min(_boundMin.y, point.y);
			_boundMin.z = Math.min(_boundMin.z, point.z);
			_boundMax.x = Math.max(_boundMax.x, point.x);
			_boundMax.y = Math.max(_boundMax.y, point.y);
			_boundMax.z = Math.max(_boundMax.z, point.z);
			//_bounds.fromExtremes(_boundMin.x , _boundMin.y, _boundMin.z, _boundMax.x, _boundMax.y, _boundMax.z);
			_vertexPos = _currentSize * vertexStride * 2 + vertexOffset;
			_vertexData[_vertexPos+0]=point.x;
			_vertexData[_vertexPos+1]=point.y;
			_vertexData[_vertexPos+2]=point.z;
			_vertexData[_vertexPos+3]=power;//trace("addPoint pos:",_vertexPos, " - ", point, " - power:",power);
			_vertexPos = _currentSize * vertexStride * 2 + vertexStride + vertexOffset;
			_vertexData[_vertexPos+0]=point.x;
			_vertexData[_vertexPos+1]=point.y;
			_vertexData[_vertexPos+2]=point.z;
			_vertexData[_vertexPos+3]=power;
			var lastPoint:Vector3D = getLastPosition();
			if (lastPoint)
			{
				point = point.subtract(lastPoint);
				point.normalize();
				_vertexPos = _currentSize * vertexTangentStride * 2 + vertexTangentOffset;
				_vertexData[_vertexPos+0]=point.x;
				_vertexData[_vertexPos+1]=point.y;
				_vertexData[_vertexPos+2]=point.z;
				_vertexPos = _currentSize * vertexTangentStride * 2 + vertexTangentStride + vertexTangentOffset;
				_vertexData[_vertexPos+0]=point.x;
				_vertexData[_vertexPos+1]=point.y;
				_vertexData[_vertexPos+2]=point.z;//trace("tangent:",point);
			}
			_currentSize++;//trace(_currentSize);
			updateTangents(_currentSize);
			invalidateBounds();
			_activeDataInvalid = true;
			return true;
		}// end function
		
		private function updateTangents(currentSize:uint) : void
		{
			var first:Vector3D = new Vector3D();
			var second:Vector3D = new Vector3D();
			//至少有三个结点,则更新第二个结点
			if (currentSize > 2)
			{
				var temp:Number = 0;
				//first pair first point x
				_vertexPos = (currentSize - 3) * vertexStride * 2 + vertexOffset;
				first.x = -_vertexData[_vertexPos+0];
				first.y = -_vertexData[_vertexPos+1];
				first.z = -_vertexData[_vertexPos+2];
				//second pair first point x
				_vertexPos = (currentSize - 2) * vertexStride * 2 + vertexOffset;
				temp = -_vertexData[_vertexPos+0];
				second.x = temp;
				first.x = first.x -temp;
				temp = -_vertexData[_vertexPos+1];
				second.y = temp;
				first.y = first.y -temp;
				temp = -_vertexData[_vertexPos+2];
				second.z = temp;
				first.z = first.z -temp;
				//third pair first point x
				_vertexPos = (currentSize - 1) * vertexStride * 2 + vertexOffset;
				second.x = second.x + _vertexData[_vertexPos+0];
				second.y = second.y + _vertexData[_vertexPos+1];
				second.z = second.z + _vertexData[_vertexPos+2];
				first.add(second);
				first.normalize();
				//second pair first point x
				_vertexPos = (currentSize - 2) * vertexStride * 2 + vertexTangentOffset;
				_vertexData[_vertexPos+0]=first.x;
				_vertexData[_vertexPos+1]=first.y;
				_vertexData[_vertexPos+2]=first.z;
				//second pair second point x
				_vertexPos = (currentSize - 2) * vertexStride * 2 + vertexStride + vertexTangentOffset;
				_vertexData[_vertexPos+0]=first.x;
				_vertexData[_vertexPos+1]=first.y;
				_vertexData[_vertexPos+2]=first.z;
			}
			//至少有二个结点
			else if (currentSize > 1)
			{
				//first pair second point
				_vertexPos = vertexStride + vertexOffset;
				second.x = -_vertexData[_vertexPos+0];
				second.y = -_vertexData[_vertexPos+1];
				second.z = -_vertexData[_vertexPos+2];
				//second pair first point
				_vertexPos = vertexStride * 2 + vertexOffset;
				second.x = second.x + _vertexData[_vertexPos+0];
				second.y = second.y + _vertexData[_vertexPos+1];
				second.z = second.z + _vertexData[_vertexPos+2];
				second.normalize();
				_vertexPos = vertexTangentOffset;
				_vertexData[_vertexPos+0]=second.x;
				_vertexData[_vertexPos+1]=second.y;
				_vertexData[_vertexPos+2]=second.z;
				_vertexPos = vertexStride + vertexTangentOffset;
				_vertexData[_vertexPos+0]=second.x;
				_vertexData[_vertexPos+1]=second.y;
				_vertexData[_vertexPos+2]=second.z;
			}
			//
			else
			{
				_vertexPos = 0;
				_vertexData[_vertexPos+0]=1;
				_vertexData[_vertexPos+1]=0;
				_vertexData[_vertexPos+2]=0;
				_vertexPos = vertexStride + vertexTangentOffset;
				_vertexData[_vertexPos+0]=1;
				_vertexData[_vertexPos+1]=0;
				_vertexData[_vertexPos+2]=0;
			}
			
		}// end function
		/*
		override public function getVertexBuffer(context3d:Context3D, index:uint) : VertexBuffer3D
		{
			if (index > _maxIndex)
			{
				_maxIndex = index;
			}
			if (_vertexBufferDirty[index] || !_vertexBuffer[index])
			{
				var _loc_3:* = _vertexBuffer[index] || context3d.createVertexBuffer(_numVertices, 4);
				_vertexBuffer[index] = _vertexBuffer[index] || context3d.createVertexBuffer(_numVertices, 4);
				VertexBuffer3D(_loc_3).uploadFromByteArray(_ba_vertices, 0, 0, _numVertices);
				_vertexBufferDirty[index] = false;
			}
			return _vertexBuffer[index];
		}// end function
		
		override public function getUVBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
		{
			if (param2 > _maxIndex)
			{
				_maxIndex = param2;
			}
			if (_uvBufferDirty[param2] || !_uvBuffer[param2])
			{
				var _loc_3:* = _uvBuffer[param2] || param1.createVertexBuffer(_numVertices, 2);
				_uvBuffer[param2] = _uvBuffer[param2] || param1.createVertexBuffer(_numVertices, 2);
				_loc_3.uploadFromByteArray(_ba_uvs, 0, 0, _numVertices);
				_uvBufferDirty[param2] = false;
			}
			return _uvBuffer[param2];
		}// end function
		
		override public function getIndexBuffer(param1:Context3D, param2:uint) : IndexBuffer3D
		{
			if (param2 > _maxIndex)
			{
				_maxIndex = param2;
			}
			if (_st_indices_buff[_miplevel] == null)
			{
				_st_indices_buff[_miplevel] = new Vector.<IndexBuffer3D>(8, true);
			}
			if (_indexBufferDirty[param2] || !_st_indices_buff[_miplevel][param2])
			{
				var _loc_3:* = _st_indices_buff[_miplevel][param2] || param1.createIndexBuffer(_st_indices[_miplevel].length);
				_st_indices_buff[_miplevel][param2] = _st_indices_buff[_miplevel][param2] || param1.createIndexBuffer(_st_indices[_miplevel].length);
				_loc_3.uploadFromVector(_st_indices[_miplevel], 0, _st_indices[_miplevel].length);
				_indexBufferDirty[param2] = false;
			}
			return _st_indices_buff[_miplevel][param2];
		}// end function
		
		override public function getVertexTangentBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
		{
			if (param2 > _maxIndex)
			{
				_maxIndex = param2;
			}
			if (_vertexTangentBufferDirty[param2] || !_vertexTangentBuffer[param2])
			{
				var _loc_3:* = _vertexTangentBuffer[param2] || param1.createVertexBuffer(_numVertices, 3);
				_vertexTangentBuffer[param2] = _vertexTangentBuffer[param2] || param1.createVertexBuffer(_numVertices, 3);
				_loc_3.uploadFromByteArray(_ba_tangents, 0, 0, _numVertices);
				_vertexTangentBufferDirty[param2] = false;
			}
			return _vertexTangentBuffer[param2];
		}// end function
		*/
		public function getVertexWaveBuffer(param1:Context3D) : VertexBuffer3D
		{
			return _waveGenerator.getBuffer(param1);
		}// end function
		
		/*override public function updateVertexData(param1:Vector.<Number>) : void
		{
			throw new Error("fr.digitas.jexplorer.d3.object.ribbon.RibbonGeometry - updateVertexData : ");
		}// end function
		
		override public function get numTriangles() : uint
		{
			var _loc_1:* = _currentSize;
			_loc_1 = Math.floor(_loc_1 / Math.pow(2, _miplevel));
			var _loc_2:* = (_loc_1 - 1) * 2;
			if (_loc_2 < 0)
			{
				_loc_2 = 0;
			}
			return uint(_loc_2);
		}// end function*/
		public override function activateVertexBuffer(index:int, stage3DProxy:Stage3DProxy):void
		{
			var contextIndex:int = stage3DProxy.stage3DIndex;
			var context:Context3D = stage3DProxy.context3D;
			
			if (contextIndex != _contextIndex)
				updateActiveBuffer(contextIndex);
			
			if (!_activeBuffer || _activeContext != context)
				createBuffer(contextIndex, context);
			if (_activeDataInvalid)
				uploadData(contextIndex);
			
			context.setVertexBufferAt(index, _activeBuffer, 0, Context3DVertexBufferFormat.FLOAT_4);
		}
		
		private function _buildUVS() : void
		{
			var max:int = MAX_VERTEX >> 1;
			var pair:int = 0;
			while (pair < max)
			{
				_vertexPos = pair * vertexStride * 2 + UVOffset;
				_vertexData[_vertexPos+0]=1;
				_vertexData[_vertexPos+0]=-1;
				_vertexPos = pair * vertexStride * 2 + vertexStride + UVOffset;
				_vertexData[_vertexPos+0]=-1;
				_vertexData[_vertexPos+0]=1;
				pair++;
			}
			return;
		}// end function
		
		private function _buildIndices(layer:int = 0) : void
		{
			var pos:uint = 0;
			var index:int = 0;
			var layerOffset:Number = Math.pow(2, layer);
			var total:Number = (MAX_VERTEX >> (layer + 1)) - 1;//trace("_buildIndices", total);
			_indices = new Vector.<uint>(total * 6, true);
			//_st_indices[layer] = new Vector.<uint>(total * 6, true);
			var i:uint = 0;
			while (i < total)
			{
				index = i * 2 * layerOffset;
				pos = i * 6;
				_indices[pos] = index;//0
				_indices[pos + 1] = index + 1;//1
				_indices[pos + 2] = index + layerOffset * 2;//2
				_indices[pos + 3] = index + 1;//1
				_indices[pos + 4] = index + layerOffset * 2 + 1;//3
				_indices[pos + 5] = index + layerOffset * 2;//2
				i = i + 1;
			}
			return;
		}// end function
		
		public function get boundMin() : Vector3D
		{
			return _boundMin;
		}// end function
		
		public function get boundMax() : Vector3D
		{
			return _boundMax;
		}// end function
		
		public function complete() : void
		{
			stepProgress = 3;
			return;
		}// end function
		
		public function get bounds() : BoundingVolumeBase
		{
			return _bounds;
		}// end function
		
		public function get miplevel() : uint
		{
			return _miplevel;
		}// end function
		
		public function set miplevel(param1:uint) : void
		{
			_miplevel = param1;
			return;
		}// end function
		
		private var _distance:Number=0;
		public static const Length:uint=20;	
		public function drawToPoint(p:Vector3D):void
		{
			getLastPosition();
			var diff:Vector3D=p.subtract(getPoint);

			_distance+=diff.length;//trace(_distance);
			
			while (_distance > Length)
			{	
				diff.normalize();//diff.normalize(PIXEL_BUFFER);//以PIXEL_BUFFER标准化
				_distance-=Length;

				addPoint(p,1);
			}
		}
		
	}
}