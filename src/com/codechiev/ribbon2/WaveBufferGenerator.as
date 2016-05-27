package com.codechiev.ribbon2
{
	
	import flash.display3D.*;
	import flash.geom.*;
	import flash.utils.*;
	import com.codechiev.ribbon.ChaosVector;
	
	public class WaveBufferGenerator extends Object
	{
		private var _data:Vector.<Number>;
		protected var _buffer:VertexBuffer3D;
		private var _numVertex:uint = 2048;
		public var offset:Vector3D;
		
		public function WaveBufferGenerator(num:int = 2, numVertex:uint = 2048)
		{
			_numVertex = numVertex;
			//_buffer = new Vector.<VertexBuffer3D>(8);
			_data = new Vector.<Number>(numVertex * 4);
			
		}// end function
		
		public function fadeOut(intensity:uint = 10) : void
		{
			var icount:int = 0;
			var one:Number = 1;
			var start:uint = _numVertex - (intensity << 4);
			var tempData:Vector.<Number> = new Vector.<Number>();
			var fraction:Number = -1 / (intensity - 1);
			
			var dataPos:uint = start;
			var tempPos:uint = 0;

			while (icount < intensity)
			{
				one = one + fraction;
				tempData[tempPos++]=_data[dataPos++] * one;
				tempData[tempPos++]=_data[dataPos++] * one;
				tempData[tempPos++]=_data[dataPos++] * one;
				dataPos++;
				icount++;
			}
			dataPos = start;
			tempPos = 0;
			icount = 0;
			while (icount < intensity)
			{
				_data[dataPos++]=tempData[tempPos++];
				_data[dataPos++]=tempData[tempPos++];
				_data[dataPos++]=tempData[tempPos++];
				dataPos++;
				icount++;
			}
			return;
		}// end function
		
		public function getBuffer(param1:Context3D) : VertexBuffer3D
		{
			if (_buffer == null)
			{
				_buffer = param1.createVertexBuffer(_numVertex, 4);
				//_buffer.uploadFromByteArray(_data, 0, 0, _numVertex);
				_buffer.uploadFromVector(_data, 0, _numVertex);
			}
			return _buffer;
		}// end function
		
		/**
		 *对顶点坐标产生混乱度 
		 * 
		 */
		public function generate() : void
		{
			var chaosVec:ChaosVector = null;
			var vec3d:Vector3D = null;
			var vertexCount:int = 0;
			if (offset == null)
			{
				offset = new Vector3D();
			}
			chaosVec = new ChaosVector();
			var dataPos:uint = 0;
			vec3d = chaosVec.vector;
			vertexCount = 0;
			while (vertexCount < _numVertex / 2)
			{
				chaosVec.step();
				chaosVec.step();
				chaosVec.step();
				chaosVec.step();
				_data[dataPos++]=vec3d.x + offset.x;
				_data[dataPos++]=vec3d.y + offset.y;
				_data[dataPos++]=vec3d.z + offset.z;
				_data[dataPos++]=vertexCount / _numVertex;
				_data[dataPos++]=vec3d.x + offset.x;
				_data[dataPos++]=vec3d.y + offset.y;
				_data[dataPos++]=vec3d.z + offset.z;
				_data[dataPos++]=vertexCount / _numVertex;
				vertexCount++;
			}
		}// end function
		
	}
}
