package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.debug.WireframeAxesGrid;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.entities.Sprite3D;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.SubsurfaceScatteringDiffuseMethod;
	import away3d.primitives.LineSegment;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.data.Segment;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;
	
	import com.codechiev.away3d.AwayController;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.text.TextField;

	public class HrSystem extends Sprite
	{
		[Embed(source="/assets/worldmap.jpg")]
		public static var WorldMap:Class;
		public var away:AwayController= new AwayController();
		public function HrSystem()
		{
			away.init(this);
			away.view.backgroundColor = 0xffffff;
			away.setupHoverController();
			//away.view.scene.addChild(new WireframeAxesGrid(10,100,1,0x666666,0x666666,0x666666));
			//away.enableDrag = true;
			/*away.onMouseWheelCallback = function(delta:Number):void{
				away.view.camera.moveForward(delta*10);
			}*/
			
			var light:LightBase = new PointLight(); // DirectionalLight();
			var lightPicker:StaticLightPicker = new StaticLightPicker([ light ]);		
			light.specular = 1;
			light.x = 100;
			light.y = 50;
			light.z = 100;
			light.color = 0xffeedd;
			away.view.scene.addChild(light);
			
			var sm:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(WorldMap));
			var method : SubsurfaceScatteringDiffuseMethod = new SubsurfaceScatteringDiffuseMethod();
			var sphere:Mesh = new Mesh(new SphereGeometry(50,32,24), sm);
			var container3d:ObjectContainer3D = new ObjectContainer3D();
			var segmentSet:SegmentSet = new SegmentSet();
			away.view.scene.addChild(segmentSet);
			away.view.scene.addChild(container3d);
			
			method.scattering = .1;
			method.scatterColor = 0xffaa00;
			method.translucency = 5;
			sm.ambientColor = 0x202025; //0xdd5525;
			sm.ambient = 1;
			sm.gloss = 100;
			//sm.alpha = .8;
			sm.lightPicker = lightPicker;
			light.addChild(sphere);
			away.addMeshToViewScene(sphere);
			away.lookAt(sphere);

/*			for(var i:int=-50;i<50;i++){
				var s:Sprite3D = new Sprite3D(new ColorMaterial(Math.floor(Math.random()*0xff0000)),1,1);
				s.x = i;
				s.y = Math.sqrt(51*51-i*i);
				sphere.addChild(s);
			}*/
			var infoVec:Vector.<Sprite3dText> = new Vector.<Sprite3dText>();
			var mtx:Matrix3D = new Matrix3D();
			var pos:Vector3D = new Vector3D();
			var last:Vector3D;
			for(var i:int=110;i<260;i+=5){
			for(var j:int=0;j<360;j+=10){
				mtx.identity();
				mtx.appendTranslation(51,0,0);
				mtx.appendRotation(i,Vector3D.Z_AXIS);
				mtx.appendRotation(j,Vector3D.Y_AXIS);
				mtx.copyColumnTo(3,pos);//trace(pos);
				var st:Sprite3dText = new Sprite3dText();
				infoVec.push(st);
				st.s = new Mesh(new SphereGeometry(1,4,2), new ColorMaterial(Math.floor(Math.random()*0xff0000)));//new Sprite3D(new ColorMaterial(Math.floor(Math.random()*0xff0000)),1,1);
				st.s.x = pos.x;
				st.s.y = pos.y;
				st.s.z = pos.z;
				st.textField.text = ""+i+"-"+j;
				st.textField.visible = false;
				if(last!=null){
					st.line = new LineSegment(last, pos);
					segmentSet.addSegment(st.line);
				}else{
					last = new Vector3D();
				}
				last.copyFrom(pos);
				addChild(st.textField);
			}
			}
			
			var text:TextField = new TextField();
			text.text = "foobar<br><b>hehe</b>";// +  + BitmapMaterial 
			var textSprite:Sprite = new Sprite();
			textSprite.addChild(text);
			var textBitmap:BitmapData = new BitmapData(128,128);
			textBitmap.draw(textSprite);
			var textTexure:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(textBitmap));
			var textSprite3D:Sprite3D = new Sprite3D(textTexure,10, 10);
			textSprite3D.x = 50;
			//away.view.scene.addChild(textSprite3D);
			
			away.addRenderJob(function():void{
				//var stage2dPos:Vector3D = away.view.project(textSprite3D.scenePosition); 
				//trace(stage2dPos);
				light.position = away.view.camera.position;
				
				var num:int=0;
				for(num=0;num<container3d.numChildren;num++){
					container3d.removeChildAt(num);
				}
				
				
				for(num=0;num<infoVec.length;num++){
					var st:Sprite3dText = infoVec[num];
					var dist:Number = Vector3D.distance(st.s.position , away.view.camera.position);
					var angle:Number = dp3(st.s.position , away.view.camera.position)//Vector3D.angleBetween(st.s.position , away.view.camera.position);
					st.textField.visible = false;
					if(dist<50){//trace(angle);
					//if(angle<Math.PI*.5&&angle>0){
						container3d.addChild(st.s);
						var textPos:Vector3D = away.view.project(st.s.scenePosition); 
						st.textField.x = textPos.x;
						st.textField.y = textPos.y;
						st.textField.visible = true;
					}
				}
				
				/*if(away.move){
					sphere.rotationY = 0.1*(stage.mouseX - away.lastMouseX) + sphere.rotationY;
					sphere.rotationX = 0.1*(stage.mouseY - away.lastMouseY) + sphere.rotationX;
				}*/

			});
			
			away.addDarkFilter();
		}
		
		private function dp3(v1:Vector3D, v2:Vector3D):Number{
			v1.normalize();
			v2.normalize();
			return Math.sqrt((v1.x-v2.x)*(v1.x-v2.x) + (v1.y-v2.y)*(v1.y-v2.y) + (v1.z-v2.z)*(v1.z-v2.z));
		}		
	}

}

import away3d.entities.Mesh;
import away3d.entities.Sprite3D;
import away3d.primitives.LineSegment;

import flash.text.TextField;

class Sprite3dText{
	public var textField:TextField = new TextField();
	public var s:Mesh;//Sprite3D
	public var line:LineSegment;
}