package 
{
	/**
	 * 
	 */	
	import com.adobe.utils.*;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	import com.codechiev.away3d.PrimitiveBace;
	import com.codechiev.away3d.PrimitivesTool;
	
	import away3d.materials.utils.MipmapGenerator;
	
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
	import com.codechiev.away3d.AwayObject;
	import com.codechiev.away3d.AwayCamera;
	import flash.display3D.textures.CubeTexture;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
	public class AgalPointUVTest extends Sprite
	{
		
		[Embed( source = "sedan.jpg" )]
		protected const TextureBitmap:Class;
		
		private const WIDTH:Number 		= 512;
		private const HEIGHT:Number 	= 512;	
		
		private var fc1 : Vector.<Number> = new <Number> [0,0,0,10];
		private var fc2 : Vector.<Number> = new <Number> [18,.2,-5,0];	
		
		protected var context3D:Context3D;
		protected var cone:PrimitiveBace;
		//protected var cube:PrimitiveBace;
		protected var program:Program3D;
		protected var filterProgram:Program3D;
		
		protected var filterTexture:Texture;
		protected var cubeTeture:CubeTexture;
		private var quadIndexes : IndexBuffer3D ;
		private var quadVertexes : VertexBuffer3D ;
		
		public function AgalPointUVTest()
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
			
			//初始物体z,摄像机z,渲染顶点z坐标只能为-1~1间. 
			object.z=0;
			camera.z=-20;
			
			cone = PrimitivesTool.getCone(context3D);
			//cube = PrimitivesTool.getCube(context3D);

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
			
			transfm.copyFrom(object.transform);//得到世界坐标系
			transfm.append(camera.viewProjection);//转换到摄像机坐标系
			renderXRay(transfm);	
		}
		
		private function initialXRay():void{
			cubeTeture = makeCubeTexture(512);
			//no depth test vertex assembler;
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				//顶点
				"mov vt0 va0\n"+
				//视角转换
				"m44 vt0 vt0 vc0\n"+
				//顶点传入shader
				"mov op vt0\n"
				//uv,rgb传入像素shader
				+"mov v0, va1\n"
				//+"mov v1, va2\n"
			);
			//Create fragment assembler;
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,			
				"div ft0, v0.xy, fc0.y                \n" +//u v
				"mul ft0, ft0, fc27.y                \n" +//
				"sub ft0.x, ft0.x, fc0.y                \n" +//x-centerx
				"sub ft0.y, ft0.y, fc0.x                \n" +//y-centery
				//"mov ft2, fc0                \n" +
				"mov ft1, fc0                \n" +//
				
				//sqt((x-centerx)(x-centerx)+(y-centery)(y-centery))
				"add ft3, fc1.x, ft0.x                \n" +//
				"add ft4, fc1.y, ft0.y                \n" +//
				"mul ft3, ft3, ft3                \n" +// 
				"mul ft4, ft4, ft4                \n" +//
				"add ft3, ft3, ft4                \n" +//
				"sqt ft3, ft3                \n" +//
				"div ft1.x, fc0.x, ft3                \n" +
				"div ft1, ft1, fc27.x                \n" +//red only
				"mov ft1.xy, ft1.xx\n"+
				"mov oc, ft1"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		private var mTime:Number = 0.0;
		private function renderXRay(finalMatrix:Matrix3D):void{	
			
			var p1:Object;
			var p2:Object;
			
			// POINTS
			// R
			p1 = makePoint(3.3, 2.9, 0.1, 0.1, mTime);
			p2 = makePoint(1.9, 2.0, 0.4, 0.4, mTime);
			mTime += fc2[1];
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>( [ p1.x, p1.y, p2.x, p2.y ]) );
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 27, Vector.<Number>([ fc2[0], 2, 3, 1 ]) );
			
			/*设置 shader 正常物体最后渲染 避免no depth test运算冲突产生破面*/
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context3D.setProgram(program);
			//设置流数据
			context3D.setVertexBufferAt(0, cone.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context3D.setVertexBufferAt(1, cone.vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);//uv
			context3D.setVertexBufferAt(2, null, 5, Context3DVertexBufferFormat.FLOAT_3);//outline
			//设置顶点常量
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, finalMatrix, true);
			//设置像素常量
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>( [ 1, 1, 1, 1 ]) );
			//设置纹理
			context3D.setTextureAt(0, null);
			//清除并绘画
			context3D.clear(0, 0, 0, 1);
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.setDepthTest(true, Context3DCompareMode.LESS);
			context3D.drawTriangles(cone.indexBuffer);
			context3D.setDepthTest(false, Context3DCompareMode.LESS);
			
			context3D.present();
		}
		
		private function initialSlider():void{		
			new HSlider(this, 392, 472, onCX).setSliderParams(-180, 180, 0);
			new HSlider(this, 392, 482, onCY).setSliderParams(-180, 180, 0);
			new HSlider(this, 392, 492, onCZ).setSliderParams(-180, 180, 0);
			new HSlider(this, 392, 502, onCW).setSliderParams(-1, 1, 0);
			
			new HSlider(this, 100, 512, onY).setSliderParams(0, 128, 18);//far
			new HSlider(this, 100, 522, onZ).setSliderParams(0, 100, 60);//FOV
			new HSlider(this, 100, 532, onW).setSliderParams(-100, 100, 0);
		}
		
		private function onCX(e:Event):void{object.rotationX=e.currentTarget.value;}
		private function onCY(e:Event):void{object.rotationY=e.currentTarget.value;}
		private function onCZ(e:Event):void{object.rotationZ=e.currentTarget.value;}
		private function onCW(e:Event):void{object.z=e.currentTarget.value;}
		
		private function onY(e:Event):void{fc2[0]=e.currentTarget.value;}
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
		
		private function makePoint(fx:Number, fy:Number, sx:Number, sy:Number, t:Number):Object
		{
			var xx:Number = Math.sin(t * fx * 0.1) * sx;
			var yy:Number = Math.cos(t * fy * 0.1) * sy;
			return { x:xx, y:yy };
		}
	}
}