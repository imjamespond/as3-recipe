package 
{
	/**
	 * 
	 */	
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.materials.utils.MipmapGenerator;
	
	import com.adobe.utils.*;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	import com.codechiev.away3d.AwayCamera;
	import com.codechiev.away3d.AwayObject;
	import com.codechiev.away3d.PrimitiveBace;
	import com.codechiev.away3d.PrimitivesTool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.*;
	import flash.display3D.textures.CubeTexture;
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
	public class AgalDepthTest extends Sprite
	{
		
		[Embed( source = "sedan.jpg" )]
		protected const TextureBitmap:Class;
		
		private const WIDTH:Number 		= 512;
		private const HEIGHT:Number 	= 512;	
		
		private var fc1 : Vector.<Number> = new <Number> [0,0,0,0];
		private var fc2 : Vector.<Number> = new <Number> [0,0,0,0];	
		
		protected var context3D:Context3D;
		protected var cone:PrimitiveBace;
		protected var cube:PrimitiveBace;
		protected var program:Program3D;
		protected var filterProgram:Program3D;
		protected var xrayProgram:Program3D;
		protected var xrayProgramNoDepth:Program3D;
		
		protected var filterTexture:Texture;
		protected var cubeTeture:CubeTexture;
		private var quadIndexes : IndexBuffer3D ;
		private var quadVertexes : VertexBuffer3D ;
		
		public function AgalDepthTest()
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
		
		protected var object:AwayObject = new AwayObject();
		protected var camera:AwayCamera = new AwayCamera();
		private function initializeContext3D(e:Event):void
		{
			//Initialize context3D;		
			context3D = stage.stage3Ds[0].context3D;	
			// Setup the back buffer for the context
			context3D.configureBackBuffer(
				stage.stageWidth,  // for full-stage width
				stage.stageHeight, // for full-stage height
				0, // no antialiasing
				true // enable depth buffer and stencil buffer
			);
			
			//初始物体z在0,摄像机z在0,渲染顶点z坐标只能为-1~1间. 
			object.z=0;
			camera.z=0;
			
			cone = PrimitivesTool.getCone(context3D);
			cube = PrimitivesTool.getCube(context3D);
			initialCone();
			initialXRay();
			
			initialSlider();
			//initialPerspect();
		}
		
		protected var position:Vector3D = new Vector3D();
		protected var transfm:Matrix3D = new Matrix3D();
		protected function onRender(e:Event):void {
			if (!context3D)
				return;
			
			fc2[3]=getTimer()/500;
			
			//camera.lens
			transfm.identity();
			transfm.copyColumnFrom(3, object.scenePosition);
			//transfm.append(camera.viewProjection);
			//trace(transfm.rawData);
			renderCone(transfm);
			
			object.rotationX = fc1[0]*180;
			object.rotationY = fc1[1]*180;
			object.rotationZ = fc1[2]*180;
			transfm.copyFrom(object.transform);//得到世界坐标系
			transfm.append(camera.viewProjection);//转换到摄像机坐标系
			renderXRay(transfm);	
		}
		
		private function initialCone():void{
			cone.setupTexture(context3D,new TextureBitmap());
			filterTexture = context3D.createTexture (512, 512, Context3DTextureFormat.BGRA,true);//
			
			//Create vertex assembler;
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				//顶点
				"mov vt0 va0\n"+
				//参数
				"mov vt6 vc4\n"+
				//矩阵
				"m44 op, vt0, vc0\n"+
				"mov v0, va1\n"+
				"mov v1, va2\n"
			);
			//Create fragment assembler;
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"mov ft1, fc0\n" +
				"tex ft1, v0, fs0 <2d,nearest,repeat>\n" + //<2d,nearest,repeat>
				"mov oc, ft1"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
		}
		
		private function renderCone(finalMatrix:Matrix3D):void{
			/*设置shader 前面物体*/
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setProgram(program);
			//设置流数据
			context3D.setVertexBufferAt(0, cone.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context3D.setVertexBufferAt(1, cone.vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);//uv
			context3D.setVertexBufferAt(2, cone.vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);//rgb
			//设置顶点常量
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, finalMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, fc1, fc1.length / 4);//
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc1, fc1.length / 4);//設置第一個片斷常量寄存器 fc0 (x, y, z, w)
			//设置纹理
			context3D.setTextureAt(0, cone.texture);	
			//清除并绘画	
			context3D.clear(0, 0, 0, 1);
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.setDepthTest(true, Context3DCompareMode.LESS);//Always->outline
			context3D.drawTriangles(cone.indexBuffer);
			context3D.setDepthTest(false, Context3DCompareMode.LESS);
		}
		
		private function initialXRay():void{
			cubeTeture = makeCubeTexture(512);
			//no depth test vertex assembler;
			var xrayVertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			xrayVertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				//顶点
				"mov vt0 va0\n"+
				//参数
				"mov vt1.w vc5.w\n"+
				"mov vt1.xyz vc4.xyz\n"+
				//放大
				//"sub vt0.xyz vt0.xyz vt1.xyz\n"+
				//矩阵
				"mov vt2 vc0\n"+
				"mov vt3 vc1\n"+
				"mov vt4 vc2\n"+
				"mov vt5 vc3\n"+
				//左右移动
				"sin vt1.w vt1.w\n"+
				"add vt2.w vt2.w vt1.w\n"+
				//视角转换
				"m44 vt0 vt0 vt2\n"+
				//顶点传入shader
				"mov op vt0\n"+
				//uv,rgb传入像素shader
				"mov v0, va0\n"
				//+"mov v1, va2\n"
			);
			//Create fragment assembler;
			var xrayFragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			xrayFragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				//rgb
				//"mov ft0, v0\n" +
				//texture
				"tex ft0, v0, fs0 <cube,linear,clamp,miplinear>\n" + //fc is the direction
				//synthesize
				"mov oc, ft0"
			);
			
			xrayProgram = context3D.createProgram();
			xrayProgram.upload( xrayVertexShaderAssembler.agalcode, xrayFragmentShaderAssembler.agalcode);		
			
			var xrayFragmentShaderNoDepth : AGALMiniAssembler= new AGALMiniAssembler();
			xrayFragmentShaderNoDepth.assemble( Context3DProgramType.FRAGMENT,
				//rgb
				"mov ft0, fc0\n" +
				"mov oc, ft0.xyzw"
			);
			xrayProgramNoDepth = context3D.createProgram();
			xrayProgramNoDepth.upload( xrayVertexShaderAssembler.agalcode, xrayFragmentShaderNoDepth.agalcode);	
		}
		
		private function renderXRay(finalMatrix:Matrix3D):void{
			/*设置 shader x-ray图像*/
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.DESTINATION_ALPHA);
			context3D.setProgram(xrayProgramNoDepth);
			//设置流数据
			context3D.setVertexBufferAt(0, cube.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context3D.setVertexBufferAt(1, null, 3, Context3DVertexBufferFormat.FLOAT_2);//uv
			context3D.setVertexBufferAt(2, null, 5, Context3DVertexBufferFormat.FLOAT_3);//outline
			//设置顶点常量
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, finalMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, fc1, fc1.length / 4);//getTimer()/300
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, fc2, fc2.length / 4);
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc1, fc1.length / 4);//設置第一個片斷常量寄存器 fc0 (x, y, z, w)
			//设置纹理
			context3D.setTextureAt(0, null);
			//清除并绘画
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.setDepthTest(false, Context3DCompareMode.GREATER);//display what is greater than this//(false, Context3DCompareMode.ALWAYS);//no depth test
			context3D.drawTriangles(cube.indexBuffer);
			context3D.setDepthTest(false, Context3DCompareMode.LESS);
			
			/*设置 shader 正常物体最后渲染 避免no depth test运算冲突产生破面*/
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setProgram(xrayProgram);
			//设置流数据
			context3D.setVertexBufferAt(0, cube.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context3D.setVertexBufferAt(1, null, 3, Context3DVertexBufferFormat.FLOAT_2);//uv
			context3D.setVertexBufferAt(2, null, 5, Context3DVertexBufferFormat.FLOAT_3);//outline
			//设置顶点常量
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, finalMatrix, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, fc1, fc1.length / 4);//getTimer()/300
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fc1, fc1.length / 4);//
			//设置纹理
			context3D.setTextureAt(0, cubeTeture);
			//清除并绘画
			//context3D.clear(0, 0, 0, 1);
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.setDepthTest(true, Context3DCompareMode.LESS);
			context3D.drawTriangles(cube.indexBuffer);
			context3D.setDepthTest(false, Context3DCompareMode.LESS);
			
			context3D.present();
		}
		
		private function initialSlider():void{		
			new HSlider(this, 392, 472, onCX).setSliderParams(0, 1, 0);
			new HSlider(this, 392, 482, onCY).setSliderParams(0, 1, 0);
			new HSlider(this, 392, 492, onCZ).setSliderParams(0, 1, 0);
			new HSlider(this, 392, 502, onCW).setSliderParams(-1, 1, 0);
			
			new HSlider(this, 100, 472, onRX).setSliderParams(-180, 180, 0);
			new HSlider(this, 100, 482, onRY).setSliderParams(-180, 180, 0);
			new HSlider(this, 100, 492, onRZ).setSliderParams(-180, 180, 0);
			new HSlider(this, 100, 502, onX).setSliderParams(0, 100, 20);//near
			new HSlider(this, 100, 512, onY).setSliderParams(0, 6000, 3000);//far
			new HSlider(this, 100, 522, onZ).setSliderParams(0, 100, 60);//FOV
			new HSlider(this, 100, 532, onW).setSliderParams(-100, 100, 0);
		}
		
		private function onCX(e:Event):void{fc1[0]=e.currentTarget.value;}
		private function onCY(e:Event):void{fc1[1]=e.currentTarget.value;}
		private function onCZ(e:Event):void{fc1[2]=e.currentTarget.value;}
		private function onCW(e:Event):void{object.z=e.currentTarget.value;}
		
		private function onRX(e:Event):void{camera.rotationX=e.currentTarget.value;}
		private function onRY(e:Event):void{camera.rotationY=e.currentTarget.value;}
		private function onRZ(e:Event):void{camera.rotationZ=e.currentTarget.value;}
		
		private function onX(e:Event):void{camera.lens.near=e.currentTarget.value;}
		private function onY(e:Event):void{camera.lens.far=e.currentTarget.value;}
		private function onZ(e:Event):void{camera.lens.fieldOfView=e.currentTarget.value;}
		private function onW(e:Event):void{camera.z=e.currentTarget.value;}

		
		[Embed( source = "../embeds/skybox/snow_negative_x.jpg" )]
		protected const CubeNegX:Class;
		[Embed( source = "../embeds/skybox/snow_negative_y.jpg" )]
		protected const CubeNegY:Class;
		[Embed( source = "../embeds/skybox/snow_negative_z.jpg" )]
		protected const CubeNegZ:Class;
		[Embed( source = "../embeds/skybox/snow_positive_x.jpg" )]
		protected const CubePosX:Class;
		[Embed( source = "../embeds/skybox/snow_positive_y.jpg" )]
		protected const CubePosY:Class;
		[Embed( source = "../embeds/skybox/snow_positive_z.jpg" )]
		protected const CubePosZ:Class;
		private function makeCubeTexture(size:uint):CubeTexture {
			var texture:CubeTexture = context3D.createCubeTexture(size, "bgra", false)
			var bms:Vector.<BitmapData> = new <BitmapData>[
				(new CubePosX() as Bitmap).bitmapData,(new CubeNegX() as Bitmap).bitmapData,
				(new CubePosY() as Bitmap).bitmapData,(new CubeNegY() as Bitmap).bitmapData,
				(new CubePosZ() as Bitmap).bitmapData,(new CubeNegZ() as Bitmap).bitmapData
				];
			for (var i:int = 0; i < 6; ++i)
				MipmapGenerator.generateMipMaps(bms[i], texture, null, bms[i].transparent, i);
			
			return texture
		}
		
		private function bd(size:uint, color:uint):BitmapData {
			return new BitmapData(size, size, false, color)
		}
	}
}