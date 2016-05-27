package
{
	import away3d.animators.*;
	import away3d.animators.data.*;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.transitions.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.events.*;
	import away3d.library.*;
	import away3d.library.assets.*;
	import away3d.lights.*;
	import away3d.lights.shadowmaps.*;
	import away3d.loaders.parsers.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.textures.*;
	import away3d.utils.*;
	
	import com.codechiev.SteadyCamera;
	import com.codechiev.away3d.AwayController;
	import com.codechiev.ribbon.material.RibbonTextureMaterial;
	import com.codechiev.ribbon.primitives.RibbonGeometry;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.*;
	import flash.ui.*;

	
	public class TestFlare extends Sprite
	{

		//engine variables
		private var _away3dCtl:AwayController = new AwayController();
		
		// Lens flare.
		[Embed(source="../embeds/flare0.jpg")]
		private var Flare0:Class;
		[Embed(source="../embeds/flare1.jpg")]
		private var Flare1:Class;
		[Embed(source="../embeds/flare2.jpg")]
		private var Flare2:Class;
		[Embed(source="../embeds/flare3.jpg")]
		private var Flare3:Class;
		[Embed(source="../embeds/flare4.jpg")]
		private var Flare4:Class;
		[Embed(source="../embeds/flare5.jpg")]
		private var Flare5:Class;
		[Embed(source="../embeds/flare6.jpg")]
		private var Flare6:Class;
		[Embed(source="../embeds/flare7.jpg")]
		private var Flare7:Class;
		[Embed(source="../embeds/flare8.jpg")]
		private var Flare8:Class;
		[Embed(source="../embeds/flare9.jpg")]
		private var Flare9:Class;
		[Embed(source="../embeds/flare10.jpg")]
		private var Flare10:Class;
		[Embed(source="../embeds/flare11.jpg")]
		private var Flare11:Class;
		[Embed(source="../embeds/flare12.jpg")]
		private var Flare12:Class;
		private var _flares:Vector.<FlareObject> = new Vector.<FlareObject>();
		private var _flareVisible:Boolean;
		
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
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		private var _skyCubeTexture:CubeTextureBase;
		
		private var _plane:Mesh;
		
		private var placeHolder:ObjectContainer3D;
		
		// reflection variables
		private var _reflectionTexture:PlanarReflectionTexture;
		private var _reflectiveMaterial : ColorMaterial;
		
		private var _reflectionCubeTexture:CubeReflectionTexture;
		private var _reflectiveCubeMaterial:ColorMaterial;
		
		private var _refractionCubeMaterial:ColorMaterial;
		
		private var _camera:SteadyCamera;

		public function TestFlare()
		{
			away3d.debug.Debug.active = true;
			init();
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			_away3dCtl.init(this);
			_away3dCtl.setupFirstPersonController();
			
			//floor
			_plane = new Mesh(new PlaneGeometry(700, 700, 1, 1, true, false), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
			_away3dCtl.addMeshToViewScene(_plane);
			
			initSky();
			
			initSphere();
			
			initFlare();

			//_away3dCtl.addDarkFilter();
		}
		
		public function initFlare():void{
			// Initialize flares.
			_flares.push( new FlareObject( new Flare10(), 3.2, -0.01, 147.9 ) );
			_flares.push( new FlareObject( new Flare11(), 6, 0, 30.6 ) );
			_flares.push( new FlareObject( new Flare7(), 2, 0, 25.5 ) );
			_flares.push( new FlareObject( new Flare7(), 4, 0, 17.85 ) );
			_flares.push( new FlareObject( new Flare12(), 0.4, 0.32, 22.95 ) );
			_flares.push( new FlareObject( new Flare6(), 1, 0.68, 20.4 ) );
			_flares.push( new FlareObject( new Flare2(), 1.25, 1.1, 48.45 ) );
			_flares.push( new FlareObject( new Flare3(), 1.75, 1.37, 7.65 ) );
			_flares.push( new FlareObject( new Flare4(), 2.75, 1.85, 12.75 ) );
			_flares.push( new FlareObject( new Flare8(), 0.5, 2.21, 33.15 ) );
			_flares.push( new FlareObject( new Flare6(), 4, 2.5, 10.4 ) );
			_flares.push( new FlareObject( new Flare7(), 10, 2.66, 50 ) );
		}
		
		
		public function initSky():void{
			_skyCubeTexture = new BitmapCubeTexture(Cast.bitmapData(Sky_posX), 
				Cast.bitmapData(Sky_negX), Cast.bitmapData(Sky_posY),
				Cast.bitmapData(Sky_negY), Cast.bitmapData(Sky_posZ), Cast.bitmapData(Sky_negZ));
			//create skybox.
			_away3dCtl.view.scene.addChild(new SkyBox(_skyCubeTexture));
		}
		
		private var sphere:Mesh;
		private var earth:Mesh;
		private function initSphere():void{
			// create reflection texture with a dimension of 256x256x256
			_reflectionCubeTexture = new CubeReflectionTexture(256);
			//_reflectionCubeTexture.farPlaneDistance = 3000;//有效距
			_reflectionCubeTexture.nearPlaneDistance = 10;//
			
			// center the reflection at (0, 100, 0) where our reflective object will be
			_reflectionCubeTexture.position = new Vector3D(100, 20, 0);
			
			// setup fresnel method using our reflective texture in the place of a static environment map
			var fresnelMethod : FresnelEnvMapMethod = new FresnelEnvMapMethod(_reflectionCubeTexture);
			fresnelMethod.normalReflectance = .6;
			fresnelMethod.fresnelPower = 5;
			
			//setup the reflective material
			_reflectiveCubeMaterial = new ColorMaterial(0xf0f000);
			_reflectiveCubeMaterial.addMethod(fresnelMethod);
			
			
			sphere = new Mesh(new SphereGeometry(30), _reflectiveCubeMaterial);
			sphere.y = 30;
			sphere.x = -100;
			_away3dCtl.addMeshToViewScene(sphere);
			
			earth = new Mesh(new SphereGeometry(50), new ColorMaterial(0x0000aa));
			earth.y = 50;
			earth.x = 100;
			_away3dCtl.addMeshToViewScene(earth);
			
			_away3dCtl.addRenderJob(function():void{
				_reflectionCubeTexture.render(_away3dCtl.view);
				updateFlares();
			});

		}
		
		
		private function updateFlares():void {
			// Evaluate flare visibility.
			var sunScreenPosition:Vector3D = _away3dCtl.view.project( sphere.scenePosition );
			var xOffset:Number = sunScreenPosition.x - _away3dCtl.view.width / 2;
			var yOffset:Number = sunScreenPosition.y - _away3dCtl.view.height / 2;
			var earthScreenPosition:Vector3D = _away3dCtl.view.project( earth.scenePosition );
			var earthRadius:Number = 80 * _away3dCtl.view.height / earthScreenPosition.z;
			var flareVisibleOld:Boolean = _flareVisible;
			var sunInView:Boolean = sunScreenPosition.x > 0 && sunScreenPosition.x < _away3dCtl.view.width && sunScreenPosition.y > 0 && sunScreenPosition.y < _away3dCtl.view.height && sunScreenPosition.z > 0;
			var sunOccludedByEarth:Boolean = Math.sqrt( xOffset * xOffset + yOffset * yOffset ) < earthRadius;
			_flareVisible = sunInView;// && !sunOccludedByEarth;
			// Update flare visibility.
			var flareObject:FlareObject;
			if( _flareVisible != flareVisibleOld ) {
				for each ( flareObject in _flares ) {
					if( _flareVisible )
						addChild( flareObject.sprite );
					else
						removeChild( flareObject.sprite );
				}
			}
			// Update flare position.
			if( _flareVisible ) {
				var flareDirection:Point = new Point( xOffset, yOffset );
				for each ( flareObject in _flares ) {
					flareObject.sprite.x = sunScreenPosition.x - flareDirection.x * flareObject.position - flareObject.sprite.width / 2;
					flareObject.sprite.y = sunScreenPosition.y - flareDirection.y * flareObject.position - flareObject.sprite.height / 2;
				}
			}
		}
	}
}


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.geom.Point;

class FlareObject
{
	public var sprite:Bitmap;
	public var size:Number;
	public var position:Number;
	public var opacity:Number;
	
	private const FLARE_SIZE:Number = 144;
	
	public function FlareObject( sprite:Bitmap, size:Number, position:Number, opacity:Number ) {
		this.sprite = new Bitmap( new BitmapData( sprite.bitmapData.width, sprite.bitmapData.height, true, 0xFFFFFFFF ) );
		this.sprite.bitmapData.copyChannel( sprite.bitmapData, sprite.bitmapData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA );
		this.sprite.alpha = opacity / 100;
		this.sprite.smoothing = true;
		this.sprite.scaleX = this.sprite.scaleY = size * FLARE_SIZE / sprite.width;
		this.size = size;
		this.position = position;
		this.opacity = opacity;
	}
}