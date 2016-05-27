

package
{
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Sprite3D;
	import away3d.lights.PointLight;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.textures.BitmapTexture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	
	
	/**
	 * Depth of Field Demo
	 * @author yasu
	 */
	[SWF(frameRate=60,width=720,height=480)]
	
	public class ballFilter2 extends View3D
	{
		
		private static const FOCUS_POSITION:int = 2000;
		private static const FOCUS_RANGE:int = 3000;
		private static const MAX_NUM:int = 800;
		private static const BLUR_DEPTH:int = 48;
		private static const CAMERA_RADIUS:Number = 2500;
		private static const RANDOM_LENGTH:Number = 4000;
		
		//light objects
		private var pointLight:PointLight;
		private var lightPicker:StaticLightPicker;		
		
		public function ballFilter2():void
		{
			// init
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addChild(new AwayStats(this));
			camera.lens.far = 10000;
			camera.lens.near = 10;
			
			//create a light for the camera
			pointLight = new PointLight();
			scene.addChild(pointLight);
			// In version 4, you'll need a lightpicker. Materials must then be registered with it (see initObject)
			lightPicker = new StaticLightPicker([pointLight]);			
			
			// bmp
			var orijinal:BitmapData = Bitmap(new ImageCls()).bitmapData;
			
			var mtx:Matrix = new Matrix(1, 0, 0, 1, (128 - orijinal.width) / 2, (128 - orijinal.height) / 2);
			
			// init materials
			materials		= new Vector.<TextureMaterial>(BLUR_DEPTH,true);
			for (var i:int = 0; i < BLUR_DEPTH; i++)
			{
			var blurFilter:BlurFilter = new BlurFilter(i, i, 4);
			// copy bitmapdata
			var bmd:BitmapData = new BitmapData(128, 128, true, 0x00000000);
			bmd.draw(orijinal, mtx);
			bmd.applyFilter(bmd, bmd.rect, new Point(), blurFilter);
			materials[i]	= new TextureMaterial(new BitmapTexture(bmd));
			}
			
			
			
			// init particle 		
			var ball:Sprite3D = new Sprite3D(null, 500, 500);
			
			ball.x =0;// RANDOM_LENGTH * (Math.random() - 0.5);
			ball.y =0;// RANDOM_LENGTH * (Math.random() - 0.5);
			ball.z = RANDOM_LENGTH * (Math.random() - 0.5);
			scene.addChild(ball);
			particles = ball;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		[Embed(source="/../embeds/filter.png")]
		private var ImageCls:Class;
		//private var materials:BitmapMaterial;
		private var materials:Vector.<TextureMaterial>;
		
		private var particles:Sprite3D;
		
		private function enterFrameHandler(e:Event):void
		{
			// camera motion
			//camera.x = Math.sin(getTimer() / 2000) * CAMERA_RADIUS;
			camera.z = Math.cos(getTimer() / 2000) * CAMERA_RADIUS;
			//camera.y = CAMERA_RADIUS * Math.cos(getTimer() / 2000);
			camera.lookAt(new Vector3D());
			
			// update particle
			
			
			// calc distance
			var distance:Number = Math.abs(Vector3D.distance(camera.position, particles.position) - FOCUS_POSITION);
			var blurVal:int = Math.floor((distance / FOCUS_RANGE) * BLUR_DEPTH);
			blurVal = Math.max(0, Math.min(BLUR_DEPTH - 1, blurVal));
			
			// update material
			//var cubeMaterial:ColorMaterial = new ColorMaterial( 0xFF0000 );
			//cubeMaterial.lightPicker = lightPicker;	
			//particles.material =cubeMaterial;
			particles.material = materials[blurVal];
			
			
			render();
		}
	}
}
