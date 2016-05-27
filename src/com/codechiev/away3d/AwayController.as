package com.codechiev.away3d
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.controllers.LookAtController;
	import away3d.entities.Mesh;
	import away3d.filters.BlurFilter3D;
	
	import caurina.transitions.Tweener;
	
	import com.codechiev.darkfilter3D.DarkFilter3D;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	public class AwayController
	{
		//everything begin with a sprite
		private var _sprite:Sprite;
		//engine variables
		private var _view:View3D;
		private var _camera:Camera3D;
		private var _fpCameraCtl:FirstPersonController;
		private var _lookAtCameraCtl:LookAtController;
		private var _hoverCameraCtl:HoverController;
		//before render jobs queue
		private var _renderJobVec:Vector.<Function> = new Vector.<Function>();
		private var _activate:Boolean = true;
		
		//rotation variables
		public var move:Boolean = false;
		public var lastPanAngle:Number;
		public var lastTiltAngle:Number;
		public var lastMouseX:Number;
		public var lastMouseY:Number;	
		public var enableDrag:Boolean=false;
		//movement variables
		private var drag:Number = 0.5;
		private var moveIncrement:Number = 20;//for first person controll
		private var strafeIncrement:Number = 20;//for first person controll
		private var walkSpeed:Number = 0;//for first person controll
		private var strafeSpeed:Number = 0;//for first person controll
		private var walkAcceleration:Number = 0;//for first person controll
		private var strafeAcceleration:Number = 0;
		//role controll
		private var onceAnim:String;
		private var currentAnim:String;
		private var currentRotationInc:Number = 0;
		public var movementDirection:Number;
		public var updateMovement:Function;
		public var stopMovement:Function;
		public var rotationInc:Function;
		public var onMouseWheelCallback:Function;
		public function AwayController()
		{
		}
		
		public function init(sprite:Sprite):void{
			_sprite = sprite;
			
			//setup the view
			_view = new View3D();
			sprite.addChild(_view);
			
			sprite.stage.scaleMode = StageScaleMode.NO_SCALE;
			sprite.stage.align = StageAlign.TOP_LEFT;
			//setup the render loop
			sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			sprite.stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			
			sprite.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			sprite.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			sprite.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			sprite.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			sprite.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			sprite.stage.addEventListener(Event.ACTIVATE,onActivate);
			sprite.stage.addEventListener(Event.DEACTIVATE,onDeactivate);
			
		}
		
		private static const gOrigin:Vector3D = new Vector3D();
		public function setupBaseCamera(cameraBack:Number=-100,cameraHeight:Number=100,lookAt:Vector3D=null):void{
			//setup the camera
			_view.camera.z = cameraBack;
			_view.camera.y = cameraHeight;
			_view.camera.lookAt(lookAt==null?gOrigin:lookAt);
		}
		
		/**
		 * 
		 * @param cameraBack
		 * @param cameraHeight
		 * @param panAngle水平角度
		 * @param tiltAngle倾斜角度
		 * 
		 */
		public function setupFirstPersonController(cameraBack:Number=-100,cameraHeight:Number=100,panAngle:Number=0, tiltAngle:Number=90):void{
			_view.camera.z = cameraBack;
			_view.camera.y = cameraHeight;
			_fpCameraCtl = new FirstPersonController(_view.camera, panAngle, tiltAngle);
		}
		
		public function setupLookAtController(cameraBack:Number=-100,cameraHeight:Number=100,lookAt:Vector3D=null):void{
			_view.camera.z = cameraBack;
			_view.camera.y = cameraHeight;
			_view.camera.lookAt(lookAt==null?gOrigin:lookAt);
			//setup controller to be used on the camera
			var placeHolder:ObjectContainer3D = new ObjectContainer3D();
			placeHolder.z = 1000;
			_lookAtCameraCtl = new LookAtController(_view.camera, placeHolder);
		}
		public function setupHoverController(cameraBack:Number=-100,cameraHeight:Number=100,lookAt:Vector3D=null):void{
			_view.camera.z = cameraBack;
			_view.camera.y = cameraHeight;
			_view.camera.lookAt(lookAt==null?gOrigin:lookAt);
			_hoverCameraCtl = new HoverController(_view.camera, null, 45, 20, 100, -30, 
				/*maxTiltAngle*/90, /*minPanAngle*/NaN, /*maxPanAngle*/NaN, /*steps*/8, /*yFactor:*/1);
		}
		public function lookAt(target:ObjectContainer3D):void{
			if(_lookAtCameraCtl!=null)
				_lookAtCameraCtl.lookAtObject = target;
			if(_hoverCameraCtl!=null)
				_hoverCameraCtl.lookAtObject = target;
		}		
		
		public function addMeshToViewScene(mesh:Mesh):void{
			_view.scene.addChild(mesh);
		}
		
		public function addRenderJob(job:Function):void{
			_renderJobVec.push(job);
		}
		
		private var _darkFilter:DarkFilter3D;
		private var _isDark:Boolean=false;
		public function addDarkFilter():void{
			if(null==_darkFilter){
				_darkFilter = new DarkFilter3D(0,0);
				_view.filters3d=(new Array(_darkFilter));
			}
		}

		public function useDarkFilter(using:Boolean) : void{
			if(_darkFilter){
				if(using&&!_isDark){//
					Tweener.addTween(_darkFilter, {blurY:7, blurY:7, time:1.2});//, delay:2
					Tweener.addTween(_darkFilter.colorTransform, {redMultiplier:1.4, blueMultiplier:1.4, greenMultiplier:1.4, redOffset:-110, blueOffset:-110, greenOffset:-110, time:1.2});
				}else if(!using&&_isDark){
					Tweener.addTween(_darkFilter, {blurY:0, blurY:0, time:1.2});
					Tweener.addTween(_darkFilter.colorTransform, {redMultiplier:1, blueMultiplier:1, greenMultiplier:1, redOffset:0, blueOffset:0, greenOffset:0, time:1.2});
				}
				_isDark = using;
			}
		}
		
		/**
		 * render loop
		 */
		private function onEnterFrame(e:Event):void
		{
			//handle FirstPersonController
			if(_fpCameraCtl){
				if (move) {
					_fpCameraCtl.panAngle = 0.3*(_sprite.stage.mouseX - lastMouseX) + lastPanAngle;
					_fpCameraCtl.tiltAngle = 0.3*(_sprite.stage.mouseY - lastMouseY) + lastTiltAngle;		
				}
				
				if (walkSpeed || walkAcceleration) {
					walkSpeed = (walkSpeed + walkAcceleration)*drag;
					if (Math.abs(walkSpeed) < 0.01)
						walkSpeed = 0;
					_fpCameraCtl.incrementWalk(walkSpeed);
				}
				
				if (strafeSpeed || strafeAcceleration) {
					strafeSpeed = (strafeSpeed + strafeAcceleration)*drag;
					if (Math.abs(strafeSpeed) < 0.01)
						strafeSpeed = 0;
					_fpCameraCtl.incrementStrafe(strafeSpeed);
				}
			}
			//handle HoverController
			if(_hoverCameraCtl){
				if (move) {
					_hoverCameraCtl.panAngle = 0.3*(_sprite.stage.mouseX - lastMouseX) + lastPanAngle;
					_hoverCameraCtl.tiltAngle = 0.3*(_sprite.stage.mouseY - lastMouseY) + lastTiltAngle;
				}
				
				_hoverCameraCtl.update();
			}
			
			//all jobs before render
			for each(var job:Function in _renderJobVec)
				job();
			
			//render at the last
			_view.render();
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = _sprite.stage.stageWidth;
			_view.height = _sprite.stage.stageHeight;
		}
		
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.SHIFT:
					if(updateMovement!=null)
						updateMovement(movementDirection, 1|2);//isRunning = true, if (isMoving)
					break;
				case Keyboard.UP:
					walkAcceleration = moveIncrement;
					break;
				case Keyboard.W:
					if(updateMovement!=null)
						updateMovement(movementDirection = 1);
					break;
				case Keyboard.DOWN:
					walkAcceleration = -moveIncrement;
					break;
				case Keyboard.S:
					if(updateMovement!=null)
						updateMovement(movementDirection = -1);
					break;
				case Keyboard.LEFT:
					strafeAcceleration = -strafeIncrement;
					if(rotationInc!=null)
						rotationInc(-1);
					break;
				case Keyboard.A:
					break;
				case Keyboard.RIGHT:
					strafeAcceleration = strafeIncrement;
					if(rotationInc!=null)
						rotationInc(1);
					break;
				case Keyboard.D:
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.SHIFT:
					if(updateMovement!=null)
						updateMovement(movementDirection, 2);//if (isMoving)
					break;
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = 0;
					if(stopMovement!=null)
						stopMovement();
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = 0;
					if(rotationInc!=null)
						rotationInc(0);
					break;
			}
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			move = true;
			if(_fpCameraCtl){
				lastPanAngle = _fpCameraCtl.panAngle;
				lastTiltAngle = _fpCameraCtl.tiltAngle;
				lastMouseX = _sprite.stage.mouseX;
				lastMouseY = _sprite.stage.mouseY;
			}else if(_hoverCameraCtl){
				lastPanAngle = _hoverCameraCtl.panAngle;
				lastTiltAngle = _hoverCameraCtl.tiltAngle;
				lastMouseX = _sprite.stage.mouseX;
				lastMouseY = _sprite.stage.mouseY;
			}else if(enableDrag){
				lastMouseX = _sprite.stage.mouseX;
				lastMouseY = _sprite.stage.mouseY;
			}

			_sprite.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			_sprite.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseWheel(e:MouseEvent):void
		{
			if(_hoverCameraCtl){
				_hoverCameraCtl.distance -= e.delta; 
			}

			if(onMouseWheelCallback!=null){
				onMouseWheelCallback(e.delta);
			}
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			_sprite.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			trace("onStageMouseLeave");
		}
		private function onActivate(e:Event):void {
			_sprite.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			useDarkFilter(false);
			_activate = true;
			//trace('onActivate');
		}
		private function onDeactivate(e:Event):void {
			_sprite.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			useDarkFilter(true);
			_activate = false;
			//trace('onDeactivate');
		}

		public function get camera():Camera3D
		{
			return _view.camera;
		}
		public function get view():View3D
		{
			return _view;
		}

		public function get activate():Boolean
		{
			return _activate;
		}

		
	}
}