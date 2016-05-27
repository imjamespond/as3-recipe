

package
{
	import away3d.animators.*;
	import away3d.animators.data.*;
	import away3d.animators.nodes.*;
	import away3d.animators.transitions.*;
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.core.base.*;
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
	import away3d.tools.helpers.*;
	import away3d.tools.helpers.data.*;
	import away3d.utils.*;
	
	import away3d.bounds.*;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	import com.codechiev.doublesticked.material.DoubleStickedTextureMaterial;
	import com.codechiev.ribbon.primitives.RibbonGeometry;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*; 
	import flash.ui.*;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="LOW")]
	
	public class PolarBearWithMyTexture extends Sprite
	{
		//plane texture
		[Embed(source="floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;	
		private var _floorTexture:BitmapTexture = Cast.bitmapTexture(FloorDiffuse);
		//signature swf
		[Embed(source="signature.swf", symbol="Signature")]
		public var SignatureSwf:Class;
		
		//polar bear color map
		[Embed(source="snow_diffuse.png")]
		private var SnowDiffuse:Class;
		
		//polar bear normal map
		[Embed(source="snow_normals.png")]
		private var SnowNormal:Class;
		
		//polar bear specular map
		[Embed(source="snow_specular.png")]
		private var SnowSpecular:Class;

		//snow color map
		[Embed(source="polarbear_diffuse_brown.jpg")]
		private var BearDiffuseBrown:Class;
		
		//snow color map
		[Embed(source="polarbear_diffuse.jpg")]
		private var BearDiffuse:Class;
		
		//snow normal map
		[Embed(source="polarbear_normals.jpg")]
		private var BearNormal:Class;
		
		//snow specular map
		[Embed(source="polarbear_specular.jpg")]
		private var BearSpecular:Class;
		
		//skybox textures
		[Embed(source="skybox/sky_posX.jpg")]
		private var PosX:Class;
		[Embed(source="skybox/sky_negX.jpg")]
		private var NegX:Class;
		[Embed(source="skybox/sky_posY.jpg")]
		private var PosY:Class;
		[Embed(source="skybox/sky_negY.jpg")]
		private var NegY:Class;
		[Embed(source="skybox/sky_posZ.jpg")]
		private var PosZ:Class;
		[Embed(source="skybox/sky_negZ.jpg")]
		private var NegZ:Class;
		
		//engine variables
		private var scene:Scene3D;
		private var camera:Camera3D;
		private var view:View3D;
		private var cameraController:FirstPersonController;
		private var awayStats:AwayStats;
		
		//animation variables
		private var skeletonAnimator:SkeletonAnimator;
		private var skeletonAnimationSet:SkeletonAnimationSet;
		private var stateTransition:CrossfadeTransition = new CrossfadeTransition(0.5);
		private var isRunning:Boolean;
		private var isMoving:Boolean;
		private var movementDirection:Number;
		private var currentAnim:String;
		private var currentRotationInc:Number = 0;
		
		//animation constants
		private const ANIM_BREATHE:String = "Breathe";
		private const ANIM_WALK:String = "Walk";
		private const ANIM_RUN:String = "Run";
		private const ROTATION_SPEED:Number = 3;
		private const RUN_SPEED:Number = 2;
		private const WALK_SPEED:Number = 1;
		private const BREATHE_SPEED:Number = 1;
		
		//signature variables
		private var Signature:Sprite;
		private var SignatureBitmap:Bitmap;
		
		//light objects
		private var sunLight:DirectionalLight;
		private var skyLight:PointLight;
		private var lightPicker:StaticLightPicker;
		private var softShadowMapMethod:NearShadowMapMethod;
		private var fogMethod:FogMethod;
		
		//material objects
		private var bearMaterial:DoubleStickedTextureMaterial;
		private var groundMaterial:TextureMaterial;
		private var cubeTexture:BitmapCubeTexture;
		
		//scene objects
		private var text:TextField;
		private var polarBearMesh:Mesh;
		private var ground:Mesh;
		private var skyBox:SkyBox;
		private var particleMesh:Mesh;
		//scene objects
		private var _plane:Mesh;
		private var _ribbon:RibbonGeometry;
		private var _x:Number=0;
		//rotation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number;
		private var lastTiltAngle:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;		
		//movement variables
		private var drag:Number = 0.5;
		private var walkIncrement:Number = 20;
		private var strafeIncrement:Number = 20;
		private var walkSpeed:Number = 0;
		private var strafeSpeed:Number = 0;
		private var walkAcceleration:Number = 0;
		private var strafeAcceleration:Number = 0;
		/**
		 * Constructor
		 */
		public function PolarBearWithMyTexture()
		{
			init();
			
			var slide:HSlider = new HSlider(this, 10, 50, function(e:Event):void{
				bearMaterial.setR(e.currentTarget.value);
			});
			slide.setSliderParams(40, 60, 1);
			slide.width = 100;
		}
		
		/**
		 * Global initialise function
		 */
		private function init():void
		{
			initEngine();
			initText();
			initLights();
			initObjects();
			initListeners();
		}
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			scene = new Scene3D();
			
			camera = new Camera3D();
			//camera.lens.far = 5000;
			//camera.lens.near = 20;
			camera.y = 500;
			camera.z = 0;
			camera.lookAt(new Vector3D());
				
			view = new View3D();
			view.scene = scene;
			view.camera = camera;
			
			//setup controller to be used on the camera
			cameraController = new FirstPersonController(camera, 180, 0, -80, 80);
			
			view.addSourceURL("srcview/index.html");
			addChild(view);
			
			/*
			//add signature
			Signature = Sprite(new SignatureSwf());
			SignatureBitmap = new Bitmap(new BitmapData(Signature.width, Signature.height, true, 0));
			stage.quality = StageQuality.HIGH;
			SignatureBitmap.bitmapData.draw(Signature);
			stage.quality = StageQuality.LOW;
			addChild(SignatureBitmap);
			
			awayStats = new AwayStats(view);
			addChild(awayStats);
			*/
		}
		
		/**
		 * Create an instructions overlay
		 */
		private function initText():void
		{
			text = new TextField();
			text.defaultTextFormat = new TextFormat("Verdana", 11, 0xFFFFFF);
			text.width = 240;
			text.height = 100;
			text.selectable = false;
			text.mouseEnabled = false;
			text.text = "Cursor keys / WSAD - move\n"; 
			text.appendText("SHIFT - hold down to run\n");
			
			text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0)];
			
			addChild(text);
		}
		
		/**
		 * Initialise the lights
		 */
		private function initLights():void
		{
			//create a light for shadows that mimics the sun's position in the skybox
			sunLight = new DirectionalLight(-1, -0.4, 1);
			sunLight.shadowMapper = new NearDirectionalShadowMapper(0.5);
			sunLight.color = 0xFFFFFF;
			sunLight.castsShadows = true;
			sunLight.ambient = 1;
			sunLight.diffuse = 1;
			sunLight.specular = 1;
			scene.addChild(sunLight);
			
			//create a light for ambient effect that mimics the sky
			skyLight = new PointLight();
			skyLight.y = 500;
			skyLight.color = 0xFFFFFF;
			skyLight.diffuse = 1;
			skyLight.specular = 0.5;
			skyLight.radius = 2000;
			skyLight.fallOff = 2500;
			scene.addChild(skyLight);
			
			lightPicker = new StaticLightPicker([sunLight, skyLight]);
			
			//create a global shadow method
			softShadowMapMethod = new NearShadowMapMethod(new SoftShadowMapMethod(sunLight, 10, 4));
			
			//create a global fog method
			fogMethod = new FogMethod(0, 3000, 0x5f5e6e);
		}
		
		/**
		 * Initialise the scene objects
		 */
		private function initObjects():void
		{
			AssetLibrary.enableParser(AWDParser);
			AssetLibrary.enableParser(OBJParser);
			
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.load(new URLRequest("assets/PolarBear.awd"));
			AssetLibrary.load(new URLRequest("assets/snow.obj"));
			/**/
			//create a snowy ground plane
			groundMaterial = new TextureMaterial(Cast.bitmapTexture(SnowDiffuse), true, true, true);
			groundMaterial.lightPicker = lightPicker;
			groundMaterial.specularMap = Cast.bitmapTexture(SnowSpecular);
			groundMaterial.normalMap = Cast.bitmapTexture(SnowNormal);
			groundMaterial.shadowMethod = softShadowMapMethod;
			groundMaterial.addMethod(fogMethod);
			groundMaterial.ambient = 0.5;
			ground = new Mesh(new PlaneGeometry(50000, 50000), groundMaterial);
			ground.geometry.scaleUV(50, 50);
			ground.castsShadows = true;
			//scene.addChild(ground);
			
			//create a skybox
			cubeTexture = new BitmapCubeTexture(Cast.bitmapData(PosX), Cast.bitmapData(NegX), Cast.bitmapData(PosY), Cast.bitmapData(NegY), Cast.bitmapData(PosZ), Cast.bitmapData(NegZ));
			skyBox = new SkyBox(cubeTexture);
			scene.addChild(skyBox);
			
			//setup the scene
			_ribbon = new RibbonGeometry(500, 500);
			_plane = new Mesh(_ribbon, new TextureMaterial(_floorTexture));
			_plane.bounds.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
			view.scene.addChild(_plane);
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			onResize();
		}
		
		/**
		 * Navigation and render loop
		 */
		private function onEnterFrame(event:Event):void
		{
			//update character animation
			if (polarBearMesh){
				polarBearMesh.rotationY += currentRotationInc;
			}
			
			if (move) {
				cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
				cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;		
			}
			
			if (walkSpeed || walkAcceleration) {
				walkSpeed = (walkSpeed + walkAcceleration)*drag;
				if (Math.abs(walkSpeed) < 0.01)
					walkSpeed = 0;
				cameraController.incrementWalk(walkSpeed);
			}
			
			if (strafeSpeed || strafeAcceleration) {
				strafeSpeed = (strafeSpeed + strafeAcceleration)*drag;
				if (Math.abs(strafeSpeed) < 0.01)
					strafeSpeed = 0;
				cameraController.incrementStrafe(strafeSpeed);
			}
			
			_ribbon.drawToPoint(new Vector3D(_x, 0, _x++), view.camera.forwardVector);
			view.render();
		}
		
		/**
		 * Listener function for asset complete event on loader
		 */
		private function onAssetComplete(event:AssetEvent):void
		{
			if (event.asset.assetType == AssetType.SKELETON) {
				//create a new skeleton animation set
				skeletonAnimationSet = new SkeletonAnimationSet(3);
				
				//wrap our skeleton animation set in an animator object and add our sequence objects
				skeletonAnimator = new SkeletonAnimator(skeletonAnimationSet, event.asset as Skeleton, false);
				
				//apply our animator to our mesh
				polarBearMesh.animator = skeletonAnimator;
				
				//register our mesh as the lookAt target
				//cameraController.lookAtObject = polarBearMesh;
				
				//add key listeners
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			} else if (event.asset.assetType == AssetType.ANIMATION_NODE) {
				//create animation objects for each animation node encountered
				var animationNode:SkeletonClipNode = event.asset as SkeletonClipNode;
				
				skeletonAnimationSet.addAnimation(animationNode);
				if (animationNode.name == ANIM_BREATHE)
					stop();
			} else if (event.asset.assetType == AssetType.MESH) {
				if (event.asset.name == "PolarBear") {
					//create material object and assign it to our mesh
					bearMaterial = new DoubleStickedTextureMaterial(Cast.bitmapTexture(BearDiffuseBrown));//new TextureMaterial(Cast.bitmapTexture(BearDiffuse));
					//bearMaterial.shadowMethod = softShadowMapMethod;//not enough vary for distance variable
					bearMaterial.normalMap = Cast.bitmapTexture(BearNormal);
					bearMaterial.specularMap = Cast.bitmapTexture(BearSpecular);
					bearMaterial.addMethod(fogMethod);
					bearMaterial.lightPicker = lightPicker;
					bearMaterial.gloss = 50;
					bearMaterial.specular = 0.5;
					bearMaterial.ambientColor = 0xAAAAAA;
					bearMaterial.ambient = 0.5;
					bearMaterial.setDualTexture(Cast.bitmapTexture(BearDiffuse));
					bearMaterial.addMethod(new OutlineMethod(0x88ee44, .1, true, false));  
					
					//create mesh object and assign our animation object and material object
					polarBearMesh = event.asset as Mesh;
					polarBearMesh.material = bearMaterial;
					polarBearMesh.castsShadows = true;
					polarBearMesh.scale(1.5);
					polarBearMesh.z = 1000;
					polarBearMesh.rotationY = -45;
					scene.addChild(polarBearMesh);
				} else {
					//create particle system and add it to our scene
					var geometry:Geometry = (event.asset as Mesh).geometry;
					var geometrySet:Vector.<Geometry> = new Vector.<Geometry>;
					var transforms:Vector.<ParticleGeometryTransform> = new Vector.<ParticleGeometryTransform>();
					var scale:Number;
					var vertexTransform:Matrix3D;
					var particleTransform:ParticleGeometryTransform;
					for (var i:int = 0; i < 3000; i++)
					{
						geometrySet.push(geometry);
						particleTransform = new ParticleGeometryTransform();
						scale = Math.random()  + 1;
						vertexTransform = new Matrix3D();
						vertexTransform.appendScale(scale, scale, scale);
						particleTransform.vertexTransform = vertexTransform;
						transforms.push(particleTransform);
					}
					
					var particleGeometry:Geometry = ParticleGeometryHelper.generateGeometry(geometrySet,transforms);			
					
					var particleAnimationSet:ParticleAnimationSet = new ParticleAnimationSet(true, true);
					particleAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.GLOBAL, new Vector3D(0, -100, 0)));
					particleAnimationSet.addAnimation(new ParticlePositionNode(ParticlePropertiesMode.LOCAL_STATIC));
					particleAnimationSet.addAnimation(new ParticleOscillatorNode(ParticlePropertiesMode.LOCAL_STATIC));
					particleAnimationSet.addAnimation(new ParticleRotationalVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
					particleAnimationSet.initParticleFunc = initParticleFunc;
					
					var material:ColorMaterial = new ColorMaterial();
					material.lightPicker = lightPicker;
					particleMesh = new Mesh(particleGeometry, material);
					particleMesh.bounds.fromSphere(new Vector3D(), 2000);
					var particleAnimator:ParticleAnimator = new ParticleAnimator(particleAnimationSet);
					particleMesh.animator = particleAnimator;
					particleAnimator.start();
					particleAnimator.resetTime(-10000);
					scene.addChild(particleMesh);
				}
				
			}
		}
		
		private function initParticleFunc(param:ParticleProperties):void
		{
			param.startTime = Math.random()*20 - 10;
			param.duration = 20;
			param[ParticleOscillatorNode.OSCILLATOR_VECTOR3D] = new Vector3D(Math.random() * 100 - 50, 0, Math.random() * 100 - 50, Math.random() * 2 + 3);
			param[ParticlePositionNode.POSITION_VECTOR3D] = new Vector3D(Math.random() * 10000 - 5000, 1200, Math.random() * 10000 - 5000);
			param[ParticleRotationalVelocityNode.ROTATIONALVELOCITY_VECTOR3D] = new Vector3D(Math.random(), Math.random(), Math.random(), Math.random() * 2 + 2);
		}
		
		/**
		 * Key down listener for animation
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.SHIFT:
					isRunning = true;
					if (isMoving)
						updateMovement(movementDirection);
					break;
				case Keyboard.UP:
					walkAcceleration = walkIncrement;
					break;
				case Keyboard.W:
					updateMovement(movementDirection = 1);
					break;
				case Keyboard.DOWN:
					walkAcceleration = -walkIncrement;
					break;
				case Keyboard.S:
					updateMovement(movementDirection = -1);
					break;
				case Keyboard.LEFT:
					strafeAcceleration = -strafeIncrement;
					break;
				case Keyboard.A:
					currentRotationInc = -ROTATION_SPEED;
					break;
				case Keyboard.RIGHT:
					strafeAcceleration = strafeIncrement;
					break;
				case Keyboard.D:
					currentRotationInc = ROTATION_SPEED;
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.SHIFT:
					isRunning = false;
					if (isMoving)
						updateMovement(movementDirection);
					break;
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					stop();
					walkAcceleration = 0;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					currentRotationInc = 0;
					strafeAcceleration = 0;
					break;
			}
		}
		
		private function updateMovement(dir:Number):void
		{
			isMoving = true;
			
			//update animator speed
			skeletonAnimator.playbackSpeed = dir*(isRunning? RUN_SPEED : WALK_SPEED);
			
			//update animator sequence
			var anim:String = isRunning? ANIM_RUN : ANIM_WALK;
			if (currentAnim == anim)
				return;
			
			currentAnim = anim;
			
			skeletonAnimator.play(currentAnim, stateTransition);
			
			_plane.x += WALK_SPEED*10;
		}
		
		private function stop():void
		{
			isMoving = false;
			
			//update animator speed
			skeletonAnimator.playbackSpeed = BREATHE_SPEED;
			
			//update animator sequence
			if (currentAnim == ANIM_BREATHE)
				return;
			
			currentAnim = ANIM_BREATHE;
			
			skeletonAnimator.play(currentAnim, stateTransition);
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			//SignatureBitmap.y = stage.stageHeight - Signature.height;
			//awayStats.x = stage.stageWidth - awayStats.width;
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			move = true;
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
	}
}
