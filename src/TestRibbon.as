package
{
	import away3d.animators.*;
	import away3d.animators.data.*;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.animators.transitions.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.core.base.Geometry;
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
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import com.codechiev.SteadyCamera;
	import com.codechiev.away3d.AwayController;
	import com.codechiev.away3d.ResourcesManager;
	import com.codechiev.ribbon.material.RibbonTextureMaterial;
	import com.codechiev.ribbon2.LightPaints;
	import com.codechiev.ribbon2.RibbonGeometry;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Vector3D;
	import flash.text.*;
	import flash.ui.*;
	import com.codechiev.ribbon2.AeroRibbons;

	//import com.codechiev.ribbon2.LightPaints;

	
	public class TestRibbon extends Sprite
	{

		//engine variables
		private var _away3dCtl:AwayController = new AwayController();
		
		//skybox texture
		[Embed(source="/../embeds/skybox/hourglass_cubemap.atf", mimeType="application/octet-stream")]
		public static var SkyMapCubeTexture : Class;
		[Embed(source="/../embeds/fire.atf", mimeType="application/octet-stream")]
		public static var FireTexture : Class;
		
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

		public function TestRibbon()
		{
			away3d.debug.Debug.active = true;
			
			ResourcesManager.resources["hourglass_cubemap.atf"] = new SkyMapCubeTexture();
			ResourcesManager.resources["fire.atf"] = new FireTexture();
			
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
			
			//initAeroRibbon();
			initRibbon2();

			//_away3dCtl.addDarkFilter();
		}
		
		public function initRibbon():void{
			/*var ribbonGeom:RibbonGeometry = new RibbonGeometry(100,100);
			var ribbonTex:RibbonTextureMaterial = new RibbonTextureMaterial(Cast.bitmapTexture(FloorDiffuse));
			ribbonTex.addGeom(ribbonGeom);
			var ribbon:Mesh = new Mesh(ribbonGeom, ribbonTex);
			ribbon.bounds.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
			_away3dCtl.addMeshToViewScene(ribbon);
			
			_away3dCtl.addRenderJob(function():void{
				ribbonGeom.drawToPoint(_away3dCtl.camera.position,null);
				ribbonTex.setCamera(_away3dCtl.camera.forwardVector);
			});*/
		}
		/**/
		private var _lightPaints:LightPaints;
		public function initRibbon2():void{
			var geom:Geometry = new Geometry();
			var ribbonGeom:RibbonGeometry = new RibbonGeometry();
			geom.addSubGeometry(ribbonGeom);
			var ribbon:Mesh = new Mesh(geom, new ColorMaterial());
			ribbon.bounds.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
			//_away3dCtl.addMeshToViewScene(ribbon);		
			
			_lightPaints = new LightPaints();
			_away3dCtl.addMeshToViewScene(_lightPaints.lgtGroup);
			Tweener.addTween( _lightPaints, {dezoom:.1, time:4, delay:0, transition:Equations.easeInOutQuad});
			_lightPaints.play();
			
			_away3dCtl.addRenderJob(function():void{
				//ribbonGeom.drawToPoint(_away3dCtl.camera.position);
				_lightPaints.step(_away3dCtl.camera.position);
			});
		}
		
		private var _aero:AeroRibbons;
		public function initAeroRibbon():void{
			_aero = new AeroRibbons(_away3dCtl.view.scene);
		}
		
		
		public function initSky():void{
			_skyCubeTexture = new BitmapCubeTexture(Cast.bitmapData(Sky_posX), 
				Cast.bitmapData(Sky_negX), Cast.bitmapData(Sky_posY),
				Cast.bitmapData(Sky_negY), Cast.bitmapData(Sky_posZ), Cast.bitmapData(Sky_negZ));
			//create skybox.
			_away3dCtl.view.scene.addChild(new SkyBox(_skyCubeTexture));
		}
		
	}
}