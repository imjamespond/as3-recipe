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
	import com.codechiev.darkfilter3D.DarkBlurFilter3D;
	import com.greensock.easing.Back;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Vector3D;
	import flash.text.*;
	import flash.ui.*;

	
	public class TestMd5Anim extends Sprite
	{

		//engine variables
		private var _away3dCtl:AwayController = new AwayController();
		
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
		private var _md5Obj:Md5Monster;
		
		// reflection variables
		private var _reflectionTexture:PlanarReflectionTexture;
		private var _reflectiveMaterial : ColorMaterial;
		
		private var _reflectionCubeTexture:CubeReflectionTexture;
		private var _reflectiveCubeMaterial:ColorMaterial;
		
		//private var _refractionCubeTexture:CubeRefractionTexture;
		private var _refractionCubeMaterial:ColorMaterial;
		
		private var _camera:SteadyCamera;

		public function TestMd5Anim()
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
			//_away3dCtl.setupFirstPersonController(-100,40,0,0);//40 is the half height of the mesh
			//_away3dCtl.setupHoverController();
			_away3dCtl.view.camera = _camera = new SteadyCamera(this.stage);
			
			_md5Obj = new Md5Monster(_away3dCtl);
			_away3dCtl.updateMovement = _md5Obj.updateMovement;
			_away3dCtl.stopMovement = _md5Obj.stop;
			_away3dCtl.rotationInc = _md5Obj.rotationInc;/**/
			//floor
			_plane = new Mesh(new PlaneGeometry(700, 700, 1, 1, true, false), new TextureMaterial(Cast.bitmapTexture(FloorDiffuse)));
			_away3dCtl.addMeshToViewScene(_plane);
			
			initSky();
			//initMirror();
			initSphere();
			//initCube();
			_away3dCtl.addRenderJob(function():void{
				// render the view's scene to the reflection texture (view is required to use the correct stage3DProxy)
				//_reflectionTexture.render(_away3dCtl.view);
				_reflectionCubeTexture.render(_away3dCtl.view);
				
			});
			
			//_away3dCtl.addDarkFilter();
			//var f:DarkBlurFilter3D = new DarkBlurFilter3D(6,6);
			//_away3dCtl.view.filters3d = new Array(f);
		}
		
		public function initSky():void{
			_skyCubeTexture = new BitmapCubeTexture(Cast.bitmapData(Sky_posX), 
				Cast.bitmapData(Sky_negX), Cast.bitmapData(Sky_posY),
				Cast.bitmapData(Sky_negY), Cast.bitmapData(Sky_posZ), Cast.bitmapData(Sky_negZ));
			//create skybox.
			_away3dCtl.view.scene.addChild(new SkyBox(_skyCubeTexture));
		}
		
		/**
		 * Creates the sphere that will reflect its environment
		 */
		private function initMirror() : void
		{
			_reflectionTexture = new PlanarReflectionTexture();
			// create a PlanarReflectionMethod
			var reflectionMethod : PlanarReflectionMethod = new PlanarReflectionMethod(_reflectionTexture);
			_reflectiveMaterial = new ColorMaterial(0x000000,.9);
			_reflectiveMaterial.addMethod(reflectionMethod);
			
			var mesh:Mesh = new Mesh(new PlaneGeometry(400, 200, 1, 1), _reflectiveMaterial);
			mesh.z = -200;
			_away3dCtl.addMeshToViewScene(mesh);
			
			// need to apply plane's transform to the reflection, compatible with PlaneGeometry created in this manner
			// other ways is to set reflectionTexture.plane = new Plane3D(...)
			_reflectionTexture.applyTransform(mesh.sceneTransform);
		}
		
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
			
			
			var sphere:Mesh = new Mesh(new SphereGeometry(20,8,8), _reflectiveCubeMaterial);
			sphere.y = 20;
			sphere.x = 100;
			_away3dCtl.addMeshToViewScene(sphere);
		}
		
		private function initCube():void{
			var refractionMethod:EnvMapMethod = new EnvMapMethod(_reflectionCubeTexture,1);
			
			_refractionCubeMaterial = new ColorMaterial(0x00f0f0);
			_refractionCubeMaterial.addMethod(refractionMethod);
			
			var cube:Mesh = new Mesh(new CubeGeometry(200,200,10), _refractionCubeMaterial);
			cube.y = 100;
			cube.z = 200;
			_away3dCtl.addMeshToViewScene(cube);
		}
	}
}	

import away3d.animators.SkeletonAnimationSet;
import away3d.animators.SkeletonAnimator;
import away3d.animators.data.Skeleton;
import away3d.animators.nodes.SkeletonClipNode;
import away3d.animators.transitions.CrossfadeTransition;
import away3d.containers.ObjectContainer3D;
import away3d.containers.Scene3D;
import away3d.entities.Mesh;
import away3d.events.*;
import away3d.library.AssetLibrary;
import away3d.library.assets.AssetType;
import away3d.loaders.parsers.*;
import away3d.materials.ColorMaterial;
import away3d.materials.TextureMaterial;
import away3d.materials.methods.CelDiffuseMethod;
import away3d.materials.methods.DepthDiffuseMethod;
import away3d.materials.methods.GradientDiffuseMethod;
import away3d.materials.methods.RefractionEnvMapMethod;
import away3d.materials.methods.RimLightMethod;
import away3d.materials.methods.WrapDiffuseMethod;

import com.codechiev.SteadyCamera;
import com.codechiev.away3d.AwayController;
import com.codechiev.glass.CarGlassLtMaterial;

import flash.events.*;
import flash.net.URLLoader;
import flash.net.URLRequest;
import away3d.lights.PointLight;
import away3d.lights.LightBase;
import away3d.materials.lightpickers.StaticLightPicker;

class Md5Monster {
	public var MD5MESH:uint = 1;
	public var MD5ANIM:uint = 2;
	
	private const ROTATION_SPEED:Number = 3;
	private const RUN_SPEED:Number = 1;
	private const WALK_SPEED:Number = 1;
	private const IDLE_SPEED:Number = 1;
	private const ACTION_SPEED:Number = 1;
	
	//scene objects
	private var _mesh:Mesh;
	private var _awayCtl:AwayController;
	
	//animation variables
	private var animator:SkeletonAnimator;
	private var animationSet:SkeletonAnimationSet;
	private var stateTransition:CrossfadeTransition = new CrossfadeTransition(0.5);
	private var skeleton:Skeleton;
	private var _isRunning:Boolean;
	private var _isMoving:Boolean;
	private var movementDirection:Number;
	private var onceAnim:String;
	private var currentAnim:String;
	private var currentRotationInc:Number = 0;
	
	//animation constants
	private const DEFAULT_NAME:String = "default";
	private const WALK_NAME:String = "walk";
	private const IDLE_NAME:String = "idle";
	private const RUN_NAME:String = "run";
	private const ANIM_NAMES:Array = [DEFAULT_NAME, WALK_NAME, RUN_NAME];

	[Embed(source="/assets/dancer/x_nv_tou.jpg")]
	private var MaterialHead:Class;
	[Embed(source="/assets/dancer/x_nv001_shenti.jpg")]
	private var MaterialBody:Class;
	[Embed(source="/assets/1.jpg")]
	private var OnkbaBody:Class;
	
	//hellknight mesh
	private var bodyMaterial:TextureMaterial;
	private var headMaterial:TextureMaterial;
	
	public function Md5Monster(awayCtl:AwayController){
		_awayCtl= awayCtl;
		//body material
		bodyMaterial = new TextureMaterial(away3d.utils.Cast.bitmapTexture(MaterialBody), true, true, true);
		headMaterial = new TextureMaterial(away3d.utils.Cast.bitmapTexture(MaterialHead), true, true, true);
		
		var meshURL:String = ".\\assets\\md5\\1.md5mesh";
		var animWalkURL:String = ".\\assets\\md5\\2.md5anim";
		var animRunURL:String = ".\\assets\\md5\\3.md5anim";
		var animIdleURL:String = ".\\assets\\md5\\1.md5anim";
		new MyLoader(meshURL, MD5MESH, "themesh", loadMd5Done);
		
		AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.ANIMATION_NODE) {			
				/**/
				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				var name:String = event.asset.assetNamespace;
				node.name = name;
				animationSet.addAnimation(node);
				
				if (name == IDLE_NAME || name == WALK_NAME || name == RUN_NAME) {
					node.looping = true;
				} else {
					node.looping = false;
					node.addEventListener(AnimationStateEvent.PLAYBACK_COMPLETE, onPlaybackComplete);
				}
				
				if (name == IDLE_NAME)
					stop();
				trace(AssetType.ANIMATION_NODE,name);
			} else if (event.asset.assetType == AssetType.ANIMATION_SET) {
				new MyLoader(animWalkURL, MD5ANIM, WALK_NAME, loadMd5Done);
				new MyLoader(animIdleURL, MD5ANIM, IDLE_NAME, loadMd5Done);
				new MyLoader(animRunURL, MD5ANIM, RUN_NAME, loadMd5Done);
				
				animationSet = event.asset as SkeletonAnimationSet;
				animator = new SkeletonAnimator(animationSet, skeleton);
				_mesh.animator = animator;
				trace(AssetType.ANIMATION_SET);
			} else if (event.asset.assetType == AssetType.SKELETON) {
				skeleton = event.asset as Skeleton;
				trace(AssetType.SKELETON);
			} else if (event.asset.assetType == AssetType.MESH) {
				trace(event.asset.assetType);
				//grab mesh object and assign our material object
				_mesh = event.asset as Mesh;
				_mesh.scale(1);
				
				var light:LightBase = new PointLight(); // DirectionalLight();
				var lightPicker:StaticLightPicker = new StaticLightPicker([ light ]);
				_awayCtl.view.scene.addChild(light);
				
				if(_mesh.subMeshes.length>1){
					_mesh.subMeshes[0].material = bodyMaterial;
					_mesh.subMeshes[1].material = headMaterial;
				}else{
					var tm:TextureMaterial = new TextureMaterial(away3d.utils.Cast.bitmapTexture(OnkbaBody), true, true, true);
					//tm.addMethod(new RimLightMethod(0xff0000));
					tm.diffuseMethod = new CelDiffuseMethod();
					tm.lightPicker = lightPicker;
					tm.specular=0;
					_mesh.material = tm;
				}
				
				_awayCtl.addMeshToViewScene(_mesh);
				_awayCtl.camera.x = _mesh.x+100;
				_awayCtl.camera.z = _mesh.z+100;
				//_awayCtl.camera.z = _mesh.z;
				//_awayCtl.lookAt(_mesh);
				
				var cam:SteadyCamera = _awayCtl.camera as SteadyCamera;
				cam.springTarget=_mesh;
				cam.setManual();
				_awayCtl.addRenderJob(function():void{
					_mesh.rotationY += currentRotationInc;
					light.position = cam.position;
					//trace(_mesh.position);
					cam.stepManual(1.0);
				});
			}
		});
	}
	
	public function loadMd5Done(data:*, type:uint, name:String):void{	

		if(type == MD5MESH){
			AssetLibrary.loadData(data, null, name, new MD5MeshParser());
		} else if(type == MD5ANIM){
			AssetLibrary.loadData(data, null, name, new MD5AnimParser());
		}
		
	}
	
	private function onPlaybackComplete(event:AnimationStateEvent):void
	{
		if (animator.activeState != event.animationState)
			return;
		
		onceAnim = null;
		
		animator.play(currentAnim, stateTransition);
		animator.playbackSpeed = _isMoving? movementDirection*(_isRunning? WALK_SPEED : WALK_SPEED) : IDLE_SPEED;
	}	
	public function stop():void
	{
		_isMoving = false;
		
		if (currentAnim == IDLE_NAME)
			return;
		
		currentAnim = IDLE_NAME;
		
		if (onceAnim)
			return;
		
		//update animator
		animator.playbackSpeed = IDLE_SPEED;
		animator.play(currentAnim, stateTransition);
	}
	
	public function updateMovement(dir:Number, flags:uint=0):void{
		if(flags&2&&!_isMoving)
			return;
		_isMoving = true;
		_isRunning = flags&1?true:false;
		//update animator speed
		animator.playbackSpeed = dir*(_isRunning? WALK_SPEED : WALK_SPEED);
		
		//update animator sequence
		var anim:String = _isRunning? RUN_NAME : WALK_NAME;
		if (currentAnim == anim)
			return;
		
		currentAnim = anim;
		
		animator.play(currentAnim, stateTransition);trace(currentAnim,animator.playbackSpeed);
	}
	
	public function rotationInc(left:int):void{
		currentRotationInc=left*ROTATION_SPEED;
	}
}


class MyLoader extends URLLoader{

	private var _type:uint = 0;
	private var _name:String;
	private var loadDone:Function;
	private var request:URLRequest;
	
	public function MyLoader(assest:String, type:uint, name:String, l:Function){
		_type = type;
		_name = name;
		loadDone = l;
		request = new URLRequest(assest);				
		try {
			load(request);
		}
		catch (error:SecurityError)
		{
			trace("A SecurityError has occurred.");
		}
		addEventListener(Event.COMPLETE, function(e:Event):void{
			loadDone(e.target.data, _type, _name);
		});			
		addEventListener(IOErrorEvent.IO_ERROR, function errorHandler(e:IOErrorEvent):void {
			trace("Had problem loading md5 File.");
		});
	}
}