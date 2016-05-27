/*

Basic View example in Away3d
 
Demonstrates:
 
How to create a 3D environment for your objects
How to add a new textured object to your world
How to rotate an object in your world

Code by Rob Bateman
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk

This code is distributed under the MIT License

Copyright (c) The Away Foundation http://www.theawayfoundation.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{
	import away3d.cameras.*;
	import away3d.containers.*;
	import away3d.controllers.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	import away3d.textures.BitmapTexture;
	import away3d.utils.*;
	
	import com.codechiev.ribbon.material.*;
	import com.codechiev.ribbon.primitives.RibbonGeometry;
	import away3d.debug.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	[SWF(backgroundColor="#000000", frameRate="60", quality="LOW")]
	
	public class Basic_View extends Sprite
	{
		//plane texture
		[Embed(source="/../embeds/floor_diffuse.jpg")]
		public static var FloorDiffuse:Class;
		
		private var _floorTexture:BitmapTexture = Cast.bitmapTexture(FloorDiffuse);
		
		//engine variables
		private var _view:View3D;
		
		//scene objects
		private var _plane:Mesh;
		private var _ribbon:RibbonGeometry;
		private var _ribbonMaterial:RibbonTextureMaterial;
		private var camera:Camera3D;
		private var cameraController:FirstPersonController;
		
		
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
		public function Basic_View()
		{
			Debug.active=true;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//setup the view
			_view = new View3D();
			addChild(_view);
			
			camera = new Camera3D();
			camera.lens.far = 5000;
			camera.lens.near = 20;
			camera.y = 500;
			camera.z = 0;
			
			_view.camera = camera;

			//setup the scene
			_ribbon = new RibbonGeometry(100, 100);
			_ribbonMaterial = new RibbonTextureMaterial(_floorTexture);
			_ribbonMaterial.addGeom(_ribbon);
			_plane = new Mesh(_ribbon, _ribbonMaterial);
			_plane.bounds.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
			_view.scene.addChild(_plane);			
			
			//setup controller to be used on the camera
			//cameraController = new LookAtController(camera, _plane);
			cameraController = new FirstPersonController(camera, 180, 90);
			
			//setup the render loop
			addEventListener(Event.ENTER_FRAME, _onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
			
		
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		/**
		 * render loop
		 */
		private function _onEnterFrame(e:Event):void
		{
			trace(camera.forwardVector);
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
			//_plane.rotationY += 1;

			_ribbon.drawToPoint(new Vector3D(_x, 0, _x++), _view.camera.forwardVector);
			_ribbonMaterial.setCamera(_view.camera.forwardVector);
			_view.render();
		}
		
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
					walkAcceleration = walkIncrement;
					break;
				case Keyboard.W:
					break;
				case Keyboard.DOWN:
					walkAcceleration = -walkIncrement;
					break;
				case Keyboard.S:
					break;
				case Keyboard.LEFT:
					strafeAcceleration = -strafeIncrement;
					break;
				case Keyboard.A:
					break;
				case Keyboard.RIGHT:
					strafeAcceleration = strafeIncrement;
					break;
				case Keyboard.D:
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			switch (event.keyCode) {
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					walkAcceleration = 0;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					strafeAcceleration = 0;
					break;
			}
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
