package com.codechiev.away3d
{
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3D;
	import flash.display.Bitmap;

	public class PrimitiveBace
	{
		public var vertexes:Vector.<Number>;
		public var indexes:Vector.<uint>;
		public var vertexbuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		public var data32PerVertex:int = 5;
		
		public var texture:Texture;
		public function PrimitiveBace()
		{
		}
		
		public function setupTexture(context3D:Context3D,bitmap:Bitmap):void{
			//创建贴图
			texture = context3D.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, flash.display3D.Context3DTextureFormat.BGRA, false);
			//上传贴图
			texture.uploadFromBitmapData(bitmap.bitmapData);
		}
	}
}