package 
{
	/**
	 * 
	 */	
	import com.adobe.utils.*;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.*;
	import flash.display3D.textures.Texture;
	import flash.events.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
	public class AgalSample_stencil_render_to_texture extends Sprite
	{
		
		[Embed( source = "sedan.jpg" )]
		protected const TextureBitmap:Class;
		
		private const WIDTH:Number 		= 512;
		private const HEIGHT:Number 	= 512;	
		
		private var intensity:Number 	= 5;
		private var offsetU:Number 		= 0;
		private var offsetV:Number 		= 1;
		private var radius:Number 		= 0;
		private var fconstants : Vector.<Number>;	
		
		protected var context3D:Context3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D; 
		protected var program:Program3D;
		protected var filterProgram:Program3D;
		protected var outlineProgram:Program3D;
		protected var texture:Texture;
		protected var filterTexture:Texture;
		protected var texture2:Texture;
		private var quadIndexes : IndexBuffer3D ;
		private var quadVertexes : VertexBuffer3D ;
		
		public function AgalSample_stencil_render_to_texture()
		{
			//First, you need initialize your stage as you program any 2D projects.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			// Get the Stage3D to use
			var stage3D:Stage3D = stage.stage3Ds[0]; // or 1 or 2 or 3
			// Listen for when the Context3D is created for it
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, initializeContext3D);
			// Request the Context3D with either software or auto (hardware with software fallback)
			stage3D.requestContext3D();
			
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function initializeContext3D(e:Event):void
		{
			fconstants		= new <Number> [
				offsetU /* center x (u) */,
				offsetV /* center y (v) */,
				radius /* radius of the circle fully inside 1x1 uv quad */,
				intensity//strength.value /* p > 1, to compress image radially */
			];
			
			//Initialize context3D;		
			context3D = stage.stage3Ds[0].context3D;	
			// Setup the back buffer for the context
			context3D.configureBackBuffer(
				stage.stageWidth,  // for full-stage width
				stage.stageHeight, // for full-stage height
				0, // no antialiasing
				true // enable depth buffer and stencil buffer
			);
			
			//顶点,UV
			var data32PerVertex:int = 8;
			var vertexes:Vector.<Number> = Vector.<Number>([
				// x,y,z, u,v, outline
				-.9,-.9,0, 0,0, -.1,-.1,0,
				-.9,.9,0, 0,1, -.1,.1,0,
				.9,.9,0, 1,1, .1,.1,0,
				.9,-.9,0, 1,0, .1,-.1,0,
				
				0,0,.9, 0,0, 0,0,.1,
				//prepare for index0 as UV coordinate of index0 is in conflict with The index4
				0,0,.9, 1,1, 0,0,.1
			]);
			var indexes:Vector.<uint> = Vector.<uint>([
				//bottom
				2,1,0,
				0,3,2,
				
				5,0,1,
				4,1,2,
				4,2,3,
				5,3,0]);
			//updateVertexNormal(vertexes, indexes, data32PerVertex);
			//创建顶点缓冲 4 vertices, of 8 Numbers each
			vertexbuffer = context3D.createVertexBuffer(vertexes.length/data32PerVertex, data32PerVertex);
			//上传顶点缓冲 offset 0, 4 vertices
			vertexbuffer.uploadFromVector(vertexes, 0, vertexes.length/data32PerVertex);
			
			//创建索引缓冲 total of 6 indices. 2 triangles by 3 vertices each
			indexBuffer = context3D.createIndexBuffer(indexes.length);					
			//上传索引缓冲 offset 0, count 6
			indexBuffer.uploadFromVector (indexes, 0, indexes.length);//3 points define a plane 
			
			var bitmap:Bitmap = new TextureBitmap();
			//创建贴图
			texture = context3D.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false);
			//上传贴图
			texture.uploadFromBitmapData(bitmap.bitmapData);
					
			filterTexture = context3D.createTexture (512, 512, Context3DTextureFormat.BGRA,true);//
			
			//Create vertex assembler;
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				//顶点
				"mov vt0 va0\n" +
				//参数
				"mov vt6 vc0\n"+
				//转换矩阵
				"mov vt2 vc1\n"+
				"mov vt3 vc2\n"+
				"mov vt4 vc3\n"+
				"mov vt5 vc4\n"+
				//左右移动
				"sin vt6.w vt6.w\n"+
				"add vt2.w vt2.w vt6.w\n"+
				//顶点传入shader
				"m44 op, vt0, vt2\n"+
				//uv,rgb传入像素shader
				"mov v0, va2\n"+
				"mov v1, va1\n"
			);
			//Create fragment assembler;
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				//rgb
				"mov ft0, v0\n" +
				"mov ft1, fc0\n" +
				"mul ft0, ft0, ft1.w\n"+
				//texture
				"tex ft1, v1, fs0 <2d,linear,nomip>\n" + //<2d,nearest,repeat>
				//synthesize
				"add oc, ft1, ft0"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			//outline vertex assembler;
			var outlineVertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			outlineVertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				//顶点
				"mov vt0 va0\n"+
				//参数
				"mov vt1 vc0\n"+
				//放大
				"sub vt0.w vt0.w vt1.z\n"+
				//矩阵
				"mov vt2 vc1\n"+
				"mov vt3 vc2\n"+
				"mov vt4 vc3\n"+
				"mov vt5 vc4\n"+
				//左右移动
				"sin vt1.w vt1.w\n"+
				"add vt2.w vt2.w vt1.w\n"+
				//视角转换
				"m44 vt0 vt0 vt2\n"+
				//顶点传入shader
				"mov op vt0\n"+
				//uv,rgb传入像素shader
				"mov v0, va2\n"+
				"mov v1, va1\n"
			);
			//Create fragment assembler;
			var outlineFragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			outlineFragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				//rgb
				"mov ft0.xyzw, fc0.xxxx\n" +
				//synthesize
				"mov oc, ft0"
			);
			
			outlineProgram = context3D.createProgram();
			outlineProgram.upload( outlineVertexShaderAssembler.agalcode, outlineFragmentShaderAssembler.agalcode);
			
			//滤镜索引
			quadIndexes = context3D.createIndexBuffer(6);
			quadIndexes.uploadFromVector(Vector.<uint>([0, 2, 1, 1, 2, 3]), 0, 6);
			//滤镜顶点
			quadVertexes = context3D.createVertexBuffer(4, 7);
			quadVertexes.uploadFromVector(Vector.<Number>([
				// x,y,z, u,v, r,g,b
				-1,-1, 0,1, 0,0,0,
				-1,1, 0,0, 0,0,0,
				1,-1, 1,1, 0,0,0,
				1,1, 1,0, 0,0,0]), 0, 4);	
			
			//滤镜shader
			var filterVertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			var filterVertexAssembleStr:String =
				"mov vt0 va0\n" +
				"mov op, vt0\n" +
				"mov v1, va2\n"+
				"mov v0, va1\n"
			filterVertexShaderAssembler.assemble( Context3DProgramType.VERTEX,filterVertexAssembleStr);		
			var filterFragmentShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			var filterFragmentAssembleStr:String =
				//"tex ft0, v0, fs0<2d,clamp,linear>\n"+
				"mov ft0.xyzw, fc0.yxxx\n" +
				"mov oc, ft0"
			filterFragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,filterFragmentAssembleStr);
			
			filterProgram = context3D.createProgram();
			filterProgram.upload( filterVertexShaderAssembler.agalcode, filterFragmentShaderAssembler.agalcode);
			
			start();
		}
		
		protected function onRender(e:Event):void
		{
			if (!context3D) 
				return;
			//matrix transforms
			//view
			var view:Matrix3D	= new Matrix3D();
			view.appendTranslation( 0, 0, -4 );//視角平移
			
			//modle
			var model:Matrix3D 	= new Matrix3D();
			model.appendRotation( getTimer()/50, Vector3D.X_AXIS);
			
			//projection
			var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			projection.perspectiveFieldOfViewRH( 45, 1, 1, 100 ); //fov aspectRadio畫面比例 Z軸視距近戰與遠點
			
			//final
			var finalMatrix:Matrix3D	= new Matrix3D();
			finalMatrix.append( model );
			finalMatrix.append( view );//trace(view.rawData);
			finalMatrix.append( projection );
			
			/*设置outline shader
			context3D.setProgram(outlineProgram);
			//设置流数据
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);//uv
			context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);//outline
			//设置顶点常量
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, finalMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 1, fconstants[3], getTimer()/300]);//
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fconstants, fconstants.length / 4);//設置第一個片斷常量寄存器 fc0 (x, y, z, w)
			//设置纹理
			//清除并绘画
			//context3D.setRenderToTexture (filterTexture,true,0,0);//将oc输出到贴图中去!!注意要开启 depthstencil
			context3D.clear(0, 0, 0, 1);
			//Draw stencil, incrementing the stencil buffer value
			context3D.setStencilReferenceValue( 0 );
			context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE );            
			context3D.drawTriangles(indexBuffer);//draw mask*/
			
			/*设置fill mask shader
			context3D.setProgram(filterProgram);
			//设置流数据,数量和pass1相同
			context3D.setVertexBufferAt(0, quadVertexes, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(1, quadVertexes, 2, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);//rgb
			//设置纹理
			//context3D.setTextureAt(0, filterTexture);
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fconstants, fconstants.length / 4);
			//清除并绘画
			//context3D.clear(0, 0, 0, 1);
			//context3D.setRenderToBackBuffer();
			context3D.setStencilReferenceValue(1);
			context3D.drawTriangles(quadIndexes,0,-1);//在tmp上画画 四个顶点,从第几个点绘制,绘制数量*/
			
			/*设置shader*/
			context3D.setProgram(program);
			//设置流数据
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);//uv
			context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);//rgb
			//设置顶点常量
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, finalMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 1, 1, getTimer()/300]);//
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fconstants, fconstants.length / 4);//設置第一個片斷常量寄存器 fc0 (x, y, z, w)
			//设置纹理
			context3D.setTextureAt(0, texture);	
			//清除并绘画
			context3D.clear(0, 0, 0, 1);	
			//context3D.setRenderToBackBuffer();
			//Change stencil action when stencil passes so stencil buffer is not changed
			context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP );
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.drawTriangles(indexBuffer);
			
			context3D.setTextureAt(0, null);	
			context3D.present();
		}
		
		private function start():void
		{
			var tf1:TextField	= new TextField();
			tf1.appendText('radius:');
			tf1.x		= 352;
			tf1.y		= 432;
			addChild(tf1);
			
			new HSlider(this, 392, 492, onBar).setSliderParams(1, 100, 50);
		}
		
		private function onBar(e:Event):void
		{
			intensity 	= e.currentTarget.value * .1;
			fconstants	= new <Number> [offsetU,offsetV,radius,intensity];
		}
		
		private function updateVertexNormal(vetexes:Vector.<Number>, indexes:Vector.<uint>, data32PerVertex:int):void{
			var offset:uint = 0;
			for(var i:uint; i<indexes.length;){
				offset = indexes[i++]*data32PerVertex;
				var offset1:uint = offset;
				var p1:Vector3D = new Vector3D(vetexes[offset],vetexes[offset+1],vetexes[offset+2]);
				offset = indexes[i++]*data32PerVertex;
				var offset2:uint = offset;
				var p2:Vector3D = new Vector3D(vetexes[offset],vetexes[offset+1],vetexes[offset+2]);
				offset = indexes[i++]*data32PerVertex;
				var offset3:uint = offset;
				var p3:Vector3D = new Vector3D(vetexes[offset],vetexes[offset+1],vetexes[offset+2]);
				var normal:Vector3D = getVertexNormal(p1,p2,p3);
				var normalX:Number = normal.x;
				var normalY:Number = normal.y;
				var normalZ:Number = normal.z;
				vetexes[offset1+5] += normalX;
				vetexes[offset1+6] += normalY;
				vetexes[offset1+7] += normalZ;
				vetexes[offset2+5] += normalX;
				vetexes[offset2+6] += normalY;
				vetexes[offset2+7] += normalZ;
				vetexes[offset3+5] += normalX;
				vetexes[offset3+6] += normalY;
				vetexes[offset3+7] += normalZ;
			}
		}
		private function getVertexNormal(p1:Vector3D,p2:Vector3D,p3:Vector3D):Vector3D{
			//计算出2个矢量
			trace(p1,p2,p3);
			var vec1:Vector3D = p1.subtract(p2);
			var vec2:Vector3D = p2.subtract(p3);
			var normal:Vector3D = vec1.crossProduct(vec2);
			normal.normalize();
			trace(normal);
			return normal;
		}
	}
}