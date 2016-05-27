package com.codechiev.ribbon.primitives
{
	import away3d.arcane;
	import away3d.core.base.CompactSubGeometry;
	
	import com.codechiev.ribbon.base.*;
	import com.codechiev.ribbon.primitives.MyPrimitiveBase;
	
	import flash.geom.Vector3D;
	
	use namespace arcane;
	
	/**
	 * A Plane primitive mesh.
	 */
	public class RibbonGeometry extends MyPrimitiveBase
	{
		private var _segmentsW:uint;
		private var _segmentsH:uint;
		private var _yUp:Boolean;
		private var _width:Number;
		private var _height:Number;
		//private var _doubleSided:Boolean;
		
		public static const PIXEL_BUFFER:uint=20;	
		public static const NUM:uint=200;
		private var _halfTunnelWeight:Number;
		private var _halfTunnelheight:Number;
		private var _previous:Vector3D;
		private var _distance:Number=0;
		private var _lastSlice:Vector.<Number>= new <Number>[0,0,0,0,0,0,0];
		private var _sliceIndex:uint = 0;		
		public var _target:RibbonCompactSubGeometry;
		
		/**
		 * Creates a new Plane object.
		 * @param width The width of the plane.
		 * @param height The height of the plane.
		 * @param segmentsW The number of segments that make up the plane along the X-axis.
		 * @param segmentsH The number of segments that make up the plane along the Y or Z-axis.
		 * @param yUp Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false).
		 * @param doubleSided Defines whether the plane will be visible from both sides, with correct vertex normals.
		 */
		public function RibbonGeometry(width:Number = 100, height:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, yUp:Boolean = true, doubleSided:Boolean = false)
		{
			super();
			
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_yUp = yUp;
			_width = width;
			_height = height;
			//_doubleSided = doubleSided;
			
			_halfTunnelheight = height / 2;
			_halfTunnelWeight = width / 2;
		}
		
		/**
		 * The number of segments that make up the plane along the X-axis. Defaults to 1.
		 */
		public function get segmentsW():uint
		{
			return _segmentsW;
		}
		
		public function set segmentsW(value:uint):void
		{
			_segmentsW = value;
			invalidateGeometry();
			invalidateUVs();
		}
		
		/**
		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
		 * false, respectively. Defaults to 1.
		 */
		public function get segmentsH():uint
		{
			return _segmentsH;
		}
		
		public function set segmentsH(value:uint):void
		{
			_segmentsH = value;
			invalidateGeometry();
			invalidateUVs();
		}
		
		/**
		 *  Defines whether the normal vector of the plane should point along the Y-axis (true) or Z-axis (false). Defaults to true.
		 */
		public function get yUp():Boolean
		{
			return _yUp;
		}
		
		public function set yUp(value:Boolean):void
		{
			_yUp = value;
			invalidateGeometry();
		}
		

		
		/**
		 * The width of the plane.
		 */
		public function get width():Number
		{
			return _width;
		}
		
		public function set width(value:Number):void
		{
			_width = value;
			invalidateGeometry();
		}
		
		/**
		 * The height of the plane.
		 */
		public function get height():Number
		{
			return _height;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
			invalidateGeometry();
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function buildGeometry(target:RibbonCompactSubGeometry):void
		{
			_target = target;
			
			var data:Vector.<Number>;
			var indices:Vector.<uint>;
			var x:Number, y:Number;
			var numIndices:uint;
			var base:uint;
			var tw:uint = _segmentsW + 1;
			var numVertices:uint = (_segmentsH + 1)*tw * NUM;
			var stride:uint = target.vertexStride;
			var skip:uint = stride - 9;
			
			numIndices = _segmentsH*_segmentsW*6 * NUM;
			
			if (numVertices == target.numVertices) {
				data = target.vertexData;
				indices = target.indexData || new Vector.<uint>(numIndices, true);
			} else {
				data = new Vector.<Number>(numVertices*stride, true);
				indices = new Vector.<uint>(numIndices, true);
				invalidateUVs();
			}
			
			numIndices = 0;
			var index:uint = target.vertexOffset;
			for (var num:uint = 0; num<NUM; num++){
			for (var yi:uint = 0; yi <= _segmentsH; ++yi) {//高分段
				for (var xi:uint = 0; xi <= _segmentsW; ++xi) {//宽分段
					x = (xi/_segmentsW - .5)*_width;
					y = (yi/_segmentsH - .5)*_height;
					//(2)-width/2, height/2 |(3)width/2, height/2
					//----------------------|---------------------
					//(0)-width/2,-height/2 |(1)width/2,-height/2
					
					data[index++] = 0//x;
					if (_yUp) {
						data[index++] = 0;
						data[index++] = 0;//y;
					} else {
						data[index++] = y;
						data[index++] = 0;
					}
					
					data[index++] = 0;
					if (_yUp) {
						data[index++] = 0;//1;
						data[index++] = 0;
					} else {
						data[index++] = 0;
						data[index++] = -1;
					}
					
					data[index++] = 0;//1;
					data[index++] = 0;
					data[index++] = 0;
					
					index += skip;
					
					if (xi != _segmentsW && yi != _segmentsH) {
						base = xi + yi*tw;
						var mult:int = 1;//_doubleSided? 2 : 1;
						var offset:uint = num*4;
						//0,2,3; 0,3,1
						indices[numIndices++] = base*mult + offset;
						indices[numIndices++] = (base + tw)*mult + offset;
						indices[numIndices++] = (base + tw + 1)*mult + offset;
						indices[numIndices++] = base*mult + offset;
						indices[numIndices++] = (base + tw + 1)*mult + offset;
						indices[numIndices++] = (base + 1)*mult + offset;
						
					}
				}
			}
			}
			
			_lastSlice[0]=data[0];
			_lastSlice[1]=data[2];
			_lastSlice[2]=data[26];
			_lastSlice[3]=data[28];
			
			target.updateData(data);
			target.updateIndexData(indices);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function buildUVs(target:RibbonCompactSubGeometry):void
		{
			var data:Vector.<Number>;
			var stride:uint = target.UVStride;
			var numUvs:uint = (_segmentsH + 1)*(_segmentsW + 1)*stride*NUM;
			var skip:uint = stride - 2;
			
			if (target.UVData && numUvs == target.UVData.length)
				data = target.UVData;
			else {
				data = new Vector.<Number>(numUvs, true);
				invalidateGeometry();
			}
			
			var index:uint = target.UVOffset;
			for (var num:uint = 0; num<NUM; num++){
			for (var yi:uint = 0; yi <= _segmentsH; ++yi) {
				for (var xi:uint = 0; xi <= _segmentsW; ++xi) {
					data[index++] = (xi/_segmentsW)*target.scaleU;
					data[index++] = (1 - yi/_segmentsH)*target.scaleV;
					index += skip;
					
				}
			}
			}
			
			target.updateData(data);
		}
		
		/**
		 * vertex caculated by cpu 
		 * @param p1
		 * @param p2
		 * @param uStep
		 * 
		 */
		private function addSlice(p1:Vector3D, p2:Vector3D, uStep:Number=0 ):void{
			var offset:uint = _sliceIndex*_target.vertexStride*4;
			var u:Number = _lastSlice[4];//trace("vertexData:",_target.vertexData[13],",",_target.vertexData[15],";",_target.vertexData[39],",",_target.vertexData[41]);
			
			_target.vertexData[offset+0]=_lastSlice[0];
			_target.vertexData[offset+1]=_lastSlice[5];
			_target.vertexData[offset+2]=_lastSlice[1];
			
			_target.vertexData[offset+_target.vertexStride*2]=_lastSlice[2];
			_target.vertexData[offset+_target.vertexStride*2+1]=_lastSlice[6];
			_target.vertexData[offset+_target.vertexStride*2+2]=_lastSlice[3];
			
			_target.vertexData[offset+_target.vertexStride]=p1.x;
			_target.vertexData[offset+_target.vertexStride+1]=p1.y;
			_target.vertexData[offset+_target.vertexStride+2]=p1.z;
			u+=uStep;
			_target.vertexData[offset+_target.vertexStride*3]=p2.x;
			_target.vertexData[offset+_target.vertexStride*3+1]=p2.y;
			_target.vertexData[offset+_target.vertexStride*3+2]=p2.z;

			_lastSlice[0]=p1.x;
			_lastSlice[1]=p1.z;
			_lastSlice[2]=p2.x;
			_lastSlice[3]=p2.z;
			_lastSlice[4]=u;
			_lastSlice[5]=p1.y;
			_lastSlice[6]=p2.y;			
			++_sliceIndex;
			_sliceIndex %=NUM;
			
			//this.addChild(slice);
			_target.activeDataInvalid = true;
		}
		
		public function drawToPoint(p:Vector3D, camera:Vector3D):void
		{
			//if we have at least 2 points
			if (_previous)
			{
				//Calculate the difference between the old point and the new one.
				var diff:Vector3D=p.subtract(_previous);
				
				//The tunnel buffer keeps track of the distance.  If the value is under a threshhold, 
				// a new tunnel segment will not be created, but the value will persist until the next move 
				// when it may be pushed past the threshold.
				_distance+=diff.length;
				
				//var atan:Number=Math.atan2(diff.y, diff.x);
				var i:uint=0;
				
				while (_distance > PIXEL_BUFFER)
				{
					//there is enough distance in the buffer to merit at least one new tunnel segment.
					i++;
					
					diff.normalize();//diff.normalize(PIXEL_BUFFER);//以PIXEL_BUFFER标准化
					_previous=_previous.add(diff);//
					_distance-=PIXEL_BUFFER;
					/*
					// calculate the edges of the tunnel from the dig point which is in the center of the tunnel
					camera.negate();
					var normal:Vector3D=diff.crossProduct(camera);//Point.polar(_halfTunnelheight, atan + Math.PI / 2);
					normal.scaleBy(_halfTunnelheight);
					var reverseNormal:Vector3D=new Vector3D(-normal.x, -normal.y, -normal.z);
					var left:Vector3D=reverseNormal.add(p);
					var right:Vector3D=normal.add(p);
					
					addSlice(left, right, (PIXEL_BUFFER / _halfTunnelWeight));//trace(left.x,",",left.y,",",left.z,";",right.x,",",right.y,",",right.z);
				*/
					addSlice2(p, diff);
				}
				
				//redraw();
			}
			_previous=p;
		}
		
		/**
		 * vertex trasformed by gpu 
		 * @param p
		 * @param diff
		 * 
		 */
		private function addSlice2(p:Vector3D, diff:Vector3D ):void{
			var offset:uint = _sliceIndex*_target.vertexStride*4;
			var offset1:uint = _target.vertexStride;
			var offset2:uint = _target.vertexStride*2;
			var offset3:uint = _target.vertexStride*3;
			//trace("vertexData:",_target.vertexData[13],",",_target.vertexData[15],";",_target.vertexData[39],",",_target.vertexData[41]);
			var diffOffset:uint = _target.diffOffset;
			var pointOffset:uint = _target.pointOffset;
			_target.vertexData[offset+0]=_lastSlice[0];
			_target.vertexData[offset+1]=_lastSlice[5];
			_target.vertexData[offset+2]=_lastSlice[1];			
			_target.vertexData[offset+diffOffset]=_lastSlice[2];
			_target.vertexData[offset+1+diffOffset]=_lastSlice[6];
			_target.vertexData[offset+2+diffOffset]=_lastSlice[3];
			_target.vertexData[offset+3+diffOffset]=-1;
			
			_target.vertexData[offset+offset2]=_lastSlice[0];
			_target.vertexData[offset+offset2+1]=_lastSlice[5];
			_target.vertexData[offset+offset2+2]=_lastSlice[1];
			_target.vertexData[offset+offset2+diffOffset]=_lastSlice[2];
			_target.vertexData[offset+offset2+diffOffset+1]=_lastSlice[6];
			_target.vertexData[offset+offset2+diffOffset+2]=_lastSlice[3];
			_target.vertexData[offset+offset2+diffOffset+3]=1;
			
			_target.vertexData[offset+offset1]=p.x;
			_target.vertexData[offset+offset1+1]=p.y;
			_target.vertexData[offset+offset1+2]=p.z;
			_target.vertexData[offset+offset1+diffOffset]=diff.x;
			_target.vertexData[offset+offset1+diffOffset+1]=diff.y;
			_target.vertexData[offset+offset1+diffOffset+2]=diff.z;
			_target.vertexData[offset+offset1+diffOffset+3]=-1;

			_target.vertexData[offset+offset3]=p.x;
			_target.vertexData[offset+offset3+1]=p.y;
			_target.vertexData[offset+offset3+2]=p.z;
			_target.vertexData[offset+offset3+diffOffset]=diff.x;
			_target.vertexData[offset+offset3+diffOffset+1]=diff.y;
			_target.vertexData[offset+offset3+diffOffset+2]=diff.z;
			_target.vertexData[offset+offset3+diffOffset+3]=1;
			
			_lastSlice[0]=p.x;
			_lastSlice[1]=p.z;
			_lastSlice[2]=diff.x;
			_lastSlice[3]=diff.z;
			//_lastSlice[4]=u;
			_lastSlice[5]=p.y;
			_lastSlice[6]=diff.y;			
			++_sliceIndex;
			_sliceIndex %=NUM;
			
			_target.activeDataInvalid = true;
		}
	}
}
