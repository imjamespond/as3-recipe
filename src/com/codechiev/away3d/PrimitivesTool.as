package com.codechiev.away3d
{
	import com.blueflamedev.math.Vector3D;
	
	import flash.display3D.Context3D;
	import flash.geom.Vector3D;

	public class PrimitivesTool
	{
		public function PrimitivesTool()
		{
		}
		
		static public function getCone(context3D:Context3D):PrimitiveBace{
			var p:PrimitiveBace = new PrimitiveBace();
			p.vertexes = getConeVertex();
			p.indexes = getConeIndex();
			p.data32PerVertex = 8;
			//创建顶点缓冲 4 vertices, of 8 Numbers each
			p.vertexbuffer = context3D.createVertexBuffer(p.vertexes .length/p.data32PerVertex, p.data32PerVertex);
			//上传顶点缓冲 offset 0, 4 vertices
			p.vertexbuffer.uploadFromVector(p.vertexes, 0, p.vertexes.length/p.data32PerVertex);
			
			//创建索引缓冲 total of 6 indices. 2 triangles by 3 vertices each
			p.indexBuffer = context3D.createIndexBuffer(p.indexes.length);					
			//上传索引缓冲 offset 0, count 6
			p.indexBuffer.uploadFromVector (p.indexes, 0, p.indexes.length);//3 points define a plane 
			return p;
		}
		
		static public function getCube(context3D:Context3D):PrimitiveBace{
			var p:PrimitiveBace = getSkyGeometry();
			
			p.data32PerVertex = 3;
			p.vertexbuffer = context3D.createVertexBuffer(p.vertexes .length/p.data32PerVertex, p.data32PerVertex);
			p.vertexbuffer.uploadFromVector(p.vertexes, 0, p.vertexes.length/p.data32PerVertex);
			p.indexBuffer = context3D.createIndexBuffer(p.indexes.length);					
			p.indexBuffer.uploadFromVector (p.indexes, 0, p.indexes.length);//3 points define a plane 
			return p;
		}
		
		static public function getConeVertex():Vector.<Number>{
			var vertex:Vector.<Number> = new <Number>[
				// x,y,z, u,v, outline
				-1,-1,0, 0,1, 0,0,0,
				-1,1,0, 0,0, 0,0,0,
				1,1,0, 1,0, 0,0,0,
				1,-1,0, 1,1, 0,0,0,
				
				0,0,1, .5,.5, 0,0,0
			];
			return vertex;
		}
		
		static public function getConeIndex():Vector.<uint>{
			var index:Vector.<uint> = new <uint>[
				//forwar
				/*0,1,2, 2,3,0,*/
				//bottom
				2,1,0, 0,3,2,
				4,3,0, 4,0,1, 4,1,2, 4,2,3];
			return index;
		}
		
		static public function getRectangleFace(v1x:Number,v1y:Number,v1z:Number,
												v2x:Number,v2y:Number,v2z:Number,
												v3x:Number,v3y:Number,v3z:Number,
												v4x:Number,v4y:Number,v4z:Number,
												vertexes:Vector.<Number>,indexes:Vector.<uint>,count:int):void{	
			var offset:uint = count*4;
			indexes.push(0+offset,3+offset,1+offset,
				0+offset,2+offset,3+offset);
			//caculate normal
			//0 3 1
			//
			vertexes.push(v1x,v1y,v1z, 1,1);
			vertexes.push(v2x,v2y,v2z, 1,0);
			vertexes.push(v3x,v3y,v3z, 0,1);
			vertexes.push(v4x,v4y,v4z, 0,0);
		}
		
		static public function getCubeGeometry():PrimitiveBace{
			var p:PrimitiveBace = new PrimitiveBace();
			p.vertexes = new Vector.<Number>();
			p.indexes = new Vector.<uint>();
			
			getRectangleFace(
				-1,-1,-1, -1,1,-1,
				1,-1,-1, 1,1,-1,p.vertexes,p.indexes,0);
			getRectangleFace(
				1,-1,-1, 1,1,-1,
				1,-1,1, 1,1,1,p.vertexes,p.indexes,1);
			getRectangleFace(
				1,-1,1, 1,1,1,
				-1,-1,1, -1,1,1,p.vertexes,p.indexes,2);
			getRectangleFace(
				-1,-1,1, -1,1,1,
				-1,-1,-1, -1,1,-1,p.vertexes,p.indexes,3);
			
			getRectangleFace(
				1,1,1, 1,1,-1,
				-1,1,1, -1,1,-1,p.vertexes,p.indexes,4);
			getRectangleFace(
				-1,-1,1, -1,-1,-1,
				1,-1,1, 1,-1,-1,p.vertexes,p.indexes,5);

			return p;
		}
		
		static private function getSkyGeometry():PrimitiveBace
		{
			var p:PrimitiveBace = new PrimitiveBace();
			p.vertexes = new Vector.<Number>();
			p.indexes = new Vector.<uint>();
			p.vertexes = new <Number>[
				-1, 1, -1, 1, 1, -1,
				1, 1, 1, -1, 1, 1,
				-1, -1, -1, 1, -1, -1,
				1, -1, 1, -1, -1, 1
			];
			p.vertexes.fixed = true;
			
			p.indexes = new <uint>[
				0, 1, 2, 2, 3, 0,
				6, 5, 4, 4, 7, 6,
				2, 6, 7, 7, 3, 2,
				4, 5, 1, 1, 0, 4,
				4, 0, 3, 3, 7, 4,
				2, 1, 5, 5, 6, 2
			];
			return p;
		}
	}
}