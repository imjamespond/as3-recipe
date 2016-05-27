package 
{
	/**
	 * 
	 */	
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.debug.Debug;
	import away3d.materials.MaterialBase;
	import away3d.materials.utils.MipmapGenerator;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.CubeTextureBase;
	import away3d.utils.Cast;
	
	import com.adobe.utils.*;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	import com.codechiev.away3d.AwayCamera;
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
	import flash.display3D.textures.TextureBase;
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

	use namespace arcane;
	[SWF(width="800", height="600", frameRate="30", backgroundColor="#000000")]
	public class AgalSkyTest extends Sprite
	{
		
		[Embed( source = "sedan.jpg" )]
		protected const TextureBitmap:Class;
		
		private const WIDTH:Number 		= 512;
		private const HEIGHT:Number 	= 512;	
		
		private var fc1 : Vector.<Number> = new <Number> [0,0,0,10];
		private var fc2 : Vector.<Number> = new <Number> [0,0,-1000,0];	
		
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var cube:PrimitiveBace;
		protected var cubeTexture:CubeTexture;
		
		//protected var view3d:View3D = new View3D();
		protected var camera:AwayCamera = new AwayCamera();
		protected var cameraData:Vector.<Number> = new <Number>[0, 0, 0, 0, 1, 1, 1, 1];//len far
		
		//protected var skyCubeTexture:CubeTextureBase;
		//protected var sky:SkyBox;
		public function AgalSkyTest()
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
			
			away3d.debug.Debug.active = true;
			//view3d.stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy();
			//addChild(view3d);
			
			//initSky();	
			initialSlider();
			
			addEventListener(Event.ENTER_FRAME, onRender2);
		}
		
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
		}

		
		protected function onRender2(e:Event):void {

			context3D.clear(0, 0, 0, 1);
			if(null==program)
				assemble();
			context3D.setProgram(program);
			if(null==cubeTexture)
				cubeTexture=makeCubeTexture(1024, context3D);
			context3D.setTextureAt(0, cubeTexture);

			//trace(camera.viewProjection.rawData);
			cameraData[0] = camera.scenePosition.x;
			cameraData[1] = camera.scenePosition.y;
			cameraData[2] = camera.scenePosition.z;
			cameraData[4] = cameraData[5] = cameraData[6] = camera.lens.far/Math.sqrt(3);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, camera.viewProjection, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, cameraData, 2);

			if(null==cube)
				cube = PrimitivesTool.getCube(context3D);
			context3D.setVertexBufferAt(0, cube.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.drawTriangles(cube.indexBuffer, 0);
			
			context3D.present();
		}

		private function assemble():void{
			//vertex assembler;
			var vertexShaderAsm : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAsm.assemble( Context3DProgramType.VERTEX,
				//顶点
				"mov vt0, va0\n" +
				"mul vt0, va0, vc5\n" +
				"add vt0, vt0, vc4\n" +
				"m44 op, vt0, vc0\n" +
				"mov v0, va0\n"
			);
			//fragment assembler;
			var fragmentShaderAsm : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAsm.assemble( Context3DProgramType.FRAGMENT,
				"tex ft0, v0, fs0 <cube,linear,clamp,miplinear>\n" + //fc is the direction
				"mov oc, ft0"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAsm.agalcode, fragmentShaderAsm.agalcode);	
		}
		
		[Embed(source="../embeds/skybox/sky_negX.jpg")]
		public static var Sky_negX:Class;
		[Embed(source="../embeds/skybox/sky_negY.jpg")]
		public static var Sky_negY:Class;
		[Embed(source="../embeds/skybox/sky_negZ.jpg")]
		public static var Sky_negZ:Class;
		[Embed(source="../embeds/skybox/sky_posX.jpg")]
		public static var Sky_posX:Class;
		[Embed(source="../embeds/skybox/sky_posY.jpg")]
		public static var Sky_posY:Class;
		[Embed(source="../embeds/skybox/sky_posZ.jpg")]
		public static var Sky_posZ:Class;
		private function makeCubeTexture(size:uint, context3D:Context3D):CubeTexture {
			var texture:CubeTexture = context3D.createCubeTexture(size, "bgra", false)
			var bms:Vector.<BitmapData> = new <BitmapData>[
				(new Sky_posX() as Bitmap).bitmapData,(new Sky_negX() as Bitmap).bitmapData,
				(new Sky_posY() as Bitmap).bitmapData,(new Sky_negY() as Bitmap).bitmapData,
				(new Sky_posZ() as Bitmap).bitmapData,(new Sky_negZ() as Bitmap).bitmapData
			];
			for (var i:int = 0; i < 6; ++i)
				MipmapGenerator.generateMipMaps(bms[i], texture, null, bms[i].transparent, i);
			
			return texture
		}
		
		private function initialSlider():void{		
			new HSlider(this, 392, 472, onX).setSliderParams(-1000, 1000, 0);
			new HSlider(this, 392, 482, onY).setSliderParams(-1000, 1000, 0);
			new HSlider(this, 392, 492, onZ).setSliderParams(-1000, 1000, 0);
			new HSlider(this, 392, 502, onW).setSliderParams(1, 100, fc1[3]);
			
			new HSlider(this, 100, 472, onRX).setSliderParams(-180, 180, 0);
			new HSlider(this, 100, 482, onRY).setSliderParams(-180, 180, 0);
			new HSlider(this, 100, 492, onRZ).setSliderParams(-180, 180, 0);
		}
		
		private function onX(e:Event):void{camera.x=e.currentTarget.value;}
		private function onY(e:Event):void{camera.y=e.currentTarget.value;}
		private function onZ(e:Event):void{camera.z=e.currentTarget.value;}
		private function onW(e:Event):void{fc1[3]=e.currentTarget.value;}
		private function onRX(e:Event):void{camera.rotationX=e.currentTarget.value;}
		private function onRY(e:Event):void{camera.rotationY=e.currentTarget.value;}
		private function onRZ(e:Event):void{camera.rotationZ=e.currentTarget.value;}
		
		/*
		private function initSky():void{
			//skyCubeTexture = new BitmapCubeTexture(Cast.bitmapData(Sky_posX), 
			//Cast.bitmapData(Sky_negX), Cast.bitmapData(Sky_posY),
			//Cast.bitmapData(Sky_negY), Cast.bitmapData(Sky_posZ), Cast.bitmapData(Sky_negZ));
			
			//sky = new SkyBox(skyCubeTexture);
			//view3d.scene.addChild(sky);
		}
		
		private function onRender(e:Event):void {
			//view3d.render();
			
			//view3d.entityCollector.clear();
			//view3d.scene.traversePartitions(view3d.entityCollector);
			
			//view3d.renderer._rttViewProjectionMatrix.copyFrom(view3d.entityCollector.camera.viewProjection);
			//view3d.renderer._rttViewProjectionMatrix.appendScale(1, 1, 1);
			//view3d.renderer.executeRender(view3d.entityCollector);	
			view3d.stage3DProxy._context3D.clear(0, 0, 0, 1);
			//view3d.renderer.draw(view3d.entityCollector, null);
			
			//sky._material._skyboxPass.activate(view3d.stage3DProxy, view3d.camera);
			if(null==program)
				assemble();
			view3d.stage3DProxy._context3D.setProgram(program);
			//view3d.stage3DProxy._context3D.setTextureAt(0, sky._material.cubeMap.getTextureForStage3D(view3d.stage3DProxy));
			if(null==cubeTexture)
				cubeTexture=makeCubeTexture(1024, view3d.stage3DProxy._context3D);
			view3d.stage3DProxy._context3D.setTextureAt(0, cubeTexture);
			//sky._material._skyboxPass.render(sky, view3d.stage3DProxy, view3d.camera, view3d.camera.viewProjection);
			var context:Context3D = view3d.stage3DProxy._context3D;
			var pos:Vector3D = view3d.camera.scenePosition;
			cameraData[0] = pos.x;
			cameraData[1] = pos.y;
			cameraData[2] = pos.z;
			cameraData[4] = cameraData[5] = cameraData[6] = view3d.camera.lens.far/Math.sqrt(3);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, view3d.camera.viewProjection, true);
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, cameraData, 2);
			//sky.activateVertexBuffer(0, view3d.stage3DProxy);
			if(null==cube)
				cube = PrimitivesTool.getCube(context);
			context.setVertexBufferAt(0, cube.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);//coord
			context.drawTriangles(cube.indexBuffer, 0);//, sky.numTriangles);
			
			// clear buffers
			for (var i:uint = 0; i < 8; ++i) {
				view3d.renderer._context.setVertexBufferAt(i, null);
				view3d.renderer._context.setTextureAt(i, null);
			}
			
			view3d.stage3DProxy.present();
		}*/
		
	}
}