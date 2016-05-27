package
{
	import away3d.containers.*;
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.materials.methods.*;
	import away3d.primitives.*;
	import away3d.debug.Debug;
	
	import com.codechiev.away3d.material.XRayMethod;
	import com.codechiev.away3d.material.XRayProMethod;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	
	public class XRayTest extends Sprite
	{
		private var view3D:View3D;
		private var xrayCube:Mesh;
		
		public function XRayTest()
		{
			Debug.active = true;
			// stage properties 
			this.stage.scaleMode = StageScaleMode.NO_SCALE; 
			this.stage.align = StageAlign.TOP_LEFT; 
			this.stage.frameRate = 60; 
			
			// init stage3d 
			view3D = new View3D();
			view3D.antiAlias = 8;
			this.addChild(view3D);
			
			// init light
			var light:DirectionalLight = new DirectionalLight();
			light.diffuse = 1.4;
			light.ambient = 0.1;
			light.direction = new Vector3D(8, -19, -6);
			//light.castsShadows = true;
			view3D.scene.addChild(light);
			
			var lightPicker:StaticLightPicker = new StaticLightPicker([light]);
			
			// init camera
			view3D.camera.position = new Vector3D(700, 600, 800);
			view3D.camera.lookAt(new Vector3D(), Vector3D.Y_AXIS);
			view3D.camera.lens.near = 550;
			view3D.camera.lens.far = 2500;
			
			// init materials			
			var whiteMaterial:ColorMaterial = new ColorMaterial(0xe1e0e2);
			whiteMaterial.shadowMethod = new HardShadowMapMethod(light);
			whiteMaterial.lightPicker = lightPicker;
			
			var redMaterial:ColorMaterial
			= new ColorMaterial(0xd16643);
			//redMaterial.shadowMethod = new HardShadowMapMethod(light);
			//redMaterial.lightPicker = lightPicker;
			
			var xrayMethod:XRayMethod = new XRayMethod();
			xrayMethod.xrayColor = 0x3399FF;
			xrayMethod.xrayAlpha = 0.5;
			//xrayMethod.activateEffect();
			var yellowMaterial:ColorMultiPassMaterial
			= new ColorMultiPassMaterial(0xe1e022);
			//yellowMaterial.shadowMethod = new HardShadowMapMethod(light);
			//yellowMaterial.lightPicker = lightPicker;
			yellowMaterial.addMethod(xrayMethod);
			
			// init 3D objects
			var plane:Mesh
			= new Mesh(new PlaneGeometry(2000, 2000), whiteMaterial);
			//plane.castsShadows = true;
			//view3D.scene.addChild(plane);
			
			xrayCube
			= new Mesh(new CubeGeometry(300, 300, 300), yellowMaterial);
			//xrayCube.y = 100;
			xrayCube.y = 150;
			xrayCube.x = 450;
			xrayCube.z = 120;
			//xrayCube.castsShadows = true;
			xrayCube.rotationY = 112;
			view3D.scene.addChild(xrayCube);
			
			var cubeGeometry:CubeGeometry = new CubeGeometry(300, 300, 300);
			
			var cube:Mesh = new Mesh(cubeGeometry, redMaterial);
			cube.y = 150;
			cube.x = -10;
			cube.z = 350;
			cube.castsShadows = true;
			cube.rotationY = -12;
			//view3D.scene.addChild(cube);
			
			cube = new Mesh(cubeGeometry, redMaterial);
			cube.y = 150;
			cube.x = 50;
			cube.z = -350;
			cube.castsShadows = true;
			cube.rotationY = 37;
			//view3D.scene.addChild(cube);
			
			cube = new Mesh(cubeGeometry, redMaterial);
			cube.y = 150;
			cube.x = 450;
			cube.z = 120;
			//cube.castsShadows = true;
			cube.rotationY = -37;
			view3D.scene.addChild(cube);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(xrayCube&&xrayCube.rotationY>-37){
				xrayCube.rotationY-=1;
				//xrayCube.x+=1;
			}
			view3D.render();
		}
	}
}