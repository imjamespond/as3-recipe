		package 
		{
			import flash.display.Bitmap;
			import flash.display.BitmapData;
			import away3d.containers.View3D;
			import away3d.filters.BloomFilter3D;
			import away3d.primitives.WireframeSphere;
			
			import flash.events.Event;
			import flash.events.MouseEvent;
			import flash.geom.Vector3D;
			import flash.text.TextField;
			import flash.text.TextFieldAutoSize;
			import flash.text.TextFormat;
			import flash.utils.getTimer;
			
			[SWF(backgroundColor="#FFFFFF", frameRate="60", width="465", height="465")]
			/**
			 * Away3D Explosion Effect
			 */
			public class TestExplode extends View3D
			{
				private static const LOOKPOINT : Vector3D = new Vector3D(0, 0, 0);
				private var _explosion : Explosion;
				private var _inited : Boolean;
				private var _capture : Bitmap;
				private var _tf : TextField;
				
				public function TestExplode()
				{
					super();
					if (stage) _initialize(null);
					else addEventListener(Event.ADDED_TO_STAGE, _initialize);
				}
				
				private function _initialize(event : Event) : void
				{
					removeEventListener(Event.ADDED_TO_STAGE, _initialize);
					
					// ★wonderfl capture
					//Wonderfl.disable_capture();
					//  _capture = addChild(new Bitmap(new BitmapData(465, 465, false, 0x000000))) as Bitmap ;
					
					
					antiAlias = 4;
					createObject();
					addEventListener(Event.ENTER_FRAME, onUpdate);
					
					camera.x = 200;
					camera.y = 00;
					camera.z = -200;
					
					addEventListener(MouseEvent.CLICK, onClick);
					
					for (var i : int = 0; i < 64; i++) {
						var sphere : WireframeSphere = scene.addChild(new WireframeSphere(1, 2, 3)) as WireframeSphere;
						sphere.x = Math.random() * 1024 - 512;
						sphere.y = Math.random() * 1024 - 512;
						sphere.z = Math.random() * 1024 - 512;
					}
					
					_tf = addChild(new TextField()) as TextField;
					_tf.defaultTextFormat = new TextFormat(null, 16, 0xffffff);
					_tf.autoSize = TextFieldAutoSize.LEFT;
					_tf.text = "CLICK TO STAGE!";
					_tf.mouseEnabled = false;
					_tf.x = stage.stageWidth * 0.5 - _tf.width * 0.5;
					_tf.y = stage.stageHeight * 0.9 - _tf.height * 0.5;
				}
				
				private function onClick(event : MouseEvent) : void
				{
					_explosion.doEffect();
				}
				
				private function createObject() : void
				{
					//----------------------------------
					//  create objects
					//----------------------------------
					_explosion = scene.addChild(new Explosion()) as Explosion;
				}
				
				private function onUpdate(event : Event) : void
				{
					if (!_inited) {
						_inited = true;
						filters3d = [new BloomFilter3D(16, 16, 0.2)];
					}
					
					var t : Number = getTimer();
					camera.x = Math.cos(t / 2048) * 512;
					camera.y = Math.sin(t / 2048) * 256;
					camera.z = 400;
					camera.lookAt(LOOKPOINT);
					render();
					
					_tf.alpha = (_tf.alpha ==1) ? 0.7 : 1;
					
					// wonderfl capture
					if (_capture) renderer.queueSnapshot(_capture.bitmapData);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Explosion
		//
		//--------------------------------------------------------------------------
		import a24.tween.Ease24;
		import a24.tween.Tween24;
		
		import away3d.containers.ObjectContainer3D;
		import away3d.entities.Mesh;
		import away3d.entities.Sprite3D;
		import away3d.lights.PointLight;
		import away3d.materials.TextureMaterial;
		import away3d.materials.lightpickers.LightPickerBase;
		import away3d.materials.lightpickers.StaticLightPicker;
		import away3d.primitives.PlaneGeometry;
		import away3d.textures.BitmapTexture;
		
		import com.codechiev._2d.Smoke;
		
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.Graphics;
		import flash.display.Loader;
		import flash.display.LoaderInfo;
		import flash.display.Shape;
		import flash.events.Event;
		import flash.geom.Matrix3D;
		import flash.net.URLRequest;
		import flash.system.LoaderContext;
		
		class Explosion extends ObjectContainer3D
		{
			private var _lines : Array;
			private var _ling : ExplosionRing;
			private var _smoke : ExplosionSmoke;
			private var _lightPicker : StaticLightPicker;
			
			public function Explosion()
			{
				super();
				
				var w : int = 32;
				var h : int = 128;
				
				var light : PointLight = new PointLight();
				light.ambientColor = 0xffe76f;
				light.ambient = 1;
				light.specular = 1;
				
				_lightPicker = new StaticLightPicker([light]);
				_lines = [];
				var max : int = 32;
				for (var i : int = 0; i < max; i++) {
					var line : ExplosionLine = addChild(new ExplosionLine(w, h, _lightPicker)) as ExplosionLine;
					line.scale(Math.random() * 0.5 + 0.5);
					_lines.push(line);
				}
				
				_ling = addChild(new ExplosionRing(480, _lightPicker)) as ExplosionRing;
				
				_smoke = addChild(new ExplosionSmoke(360, _lightPicker)) as ExplosionSmoke;
			}
			
			public function doEffect() : void
			{
				for (var i : int = 0; i < _lines.length; i++) {
					var line : ExplosionLine = _lines[i] as ExplosionLine;
					if (line) line.doEffect();
				}
				
				_ling.doEffect();
				_smoke.doEffect();
			}
		}
		// --------------------------------------------------------------------------
		//
		// Exprosion Line
		//
		// --------------------------------------------------------------------------
		class ExplosionLine extends ObjectContainer3D
		{
			private static var MAX_ALPHA : Number = 0.8;
			private var _lightPicker : LightPickerBase;
			private var line : Mesh;
			private var w : Number;
			private var h : Number;
			private var mat : TextureMaterial;
			
			public function ExplosionLine(wid : Number = 32, hei : Number = 128, lightPicker : LightPickerBase = null)
			{
				super();
				if (lightPicker) _lightPicker = lightPicker;
				
				visible = false;
				MAX_ALPHA = Math.random() * 0.25 + 0.75;
				
				w = wid || 32;
				h = hei || 128;
				
				var sp : Shape = new Shape();
				var startH : Number = 0;
				var endH : Number = h * 0.9;
				var leng : Number = endH - startH;
				var xx : Number = 32 >> 1;
				var g : Graphics = sp.graphics;
				g.moveTo(xx, 128 * 0.1);
				var max : int = 32;
				for (var i : int = 0; i < max; i++) {
					var yy : Number = leng / max * i + startH;
					g.lineStyle(0.1 * i * (i * 0.05), 0xffffff, 0.1 * i);
					g.lineTo(xx, yy);
				}
				g.endFill();
				
				var bmd : BitmapData = new BitmapData(w, h, true, 0x0);
				bmd.draw(sp);
				
				mat = new TextureMaterial(new BitmapTexture(bmd));
				mat.alphaBlending = true;
				mat.bothSides = true;
				mat.specular = 1;
				if (_lightPicker) mat.lightPicker = _lightPicker;
				
				var mat3d : Matrix3D = new Matrix3D();
				mat3d.appendTranslation(0, 0, -h >> 1);
				var geo : PlaneGeometry = new PlaneGeometry(w, h);
				geo.applyTransformation(mat3d);
				line = addChild(new Mesh(geo, mat)) as Mesh;
				line.rotationX = 90;
				sp = null;
				resetParams();
			}
			
			private function resetParams() : void
			{
				visible = false;
				
				line.y = 0;
				line.rotationY = 0;
				
				line.scaleX = 0;
				line.scaleY = 0;
				line.scaleZ = 0;
				mat.alpha = 1;
			}
			
			public function doEffect() : void
			{
				// ランダムな方向
				doRandomRotation();
				// パラメータリセット
				resetParams();
				//
				var t : Number = 0.35 + Math.random() * 0.45;
				var dt : Number = t * 0.7;
				var yy : Number = Math.random() * h * 0.5 + h * 0.5 ;
				var sz : Number = 0.5 * Math.random() + 1;
				
				Tween24.parallel(
					Tween24.tween(mat, t - dt).delay(dt).alpha(0)
					, Tween24.tween(line, t, Ease24._3_CubicInOut).y(yy).scaleX(1).scaleY(1).scaleZ(sz).rotationY(360*(Math.random()*4+2))
				).onComplete(onEffectComplete).play();
				
				visible = true;
			}
			
			private function doRandomRotation() : void
			{
				this.rotationX = Math.random() * 360;
				this.rotationY = Math.random() * 360;
				this.rotationZ = Math.random() * 360;
			}
			
			private function onEffectComplete() : void
			{
				// パラメータリセット
				resetParams();
			}
		}
		// --------------------------------------------------------------------------
		//
		// Exprosion  Ring
		//
		// --------------------------------------------------------------------------
		class ExplosionRing extends ObjectContainer3D
		{
			[Embed(source="/../embeds/lensflare/flare10.jpg")]
			private var Flare:Class;
			
			private static const DOMAIN_PATH : String = "http://www.romatica.com/dev/wonderfl/explosion/";
			private static const IMAGE_URL_EXPLOSION : String = DOMAIN_PATH + "ring.png";
			public static var  explosionBitmapData : BitmapData;
			private var _plane : Mesh;
			private var _flag : Boolean;
			private var _size : int;
			private var _loader : Loader;
			private var _lightPicker : LightPickerBase;
			
			public function ExplosionRing(size : int = 512, lightPicker : LightPickerBase = null)
			{
				super();
				if (lightPicker) _lightPicker = lightPicker;
				_size = size || 512;
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete_Handler);
				//_loader.load(new URLRequest(IMAGE_URL_EXPLOSION), new LoaderContext(true));
				
				explosionBitmapData = new Flare() as BitmapData;
			}
			
			private function loadComplete_Handler(event : Event) : void
			{
				explosionBitmapData = ((event.target as LoaderInfo).content as Bitmap).bitmapData;
				createObject();
			}
			
			private function createObject() : void
			{
				// ----------------------------------
				// create objects
				// ----------------------------------
				
				var material : TextureMaterial = new TextureMaterial(new BitmapTexture(explosionBitmapData));
				material.alphaBlending = true;
				material.bothSides = true;
				if (_lightPicker) material.lightPicker = _lightPicker;
				material.specular = 1;
				var planeGeo : PlaneGeometry = new PlaneGeometry(_size, _size, 16, 16);
				_plane = new Mesh(planeGeo, material);
				_plane.scaleX = _plane.scaleY = _plane.scaleZ = 0;
				scene.addChild(_plane);
			}
			
			public function doEffect() : void
			{
				if (!_plane) return ;
				if (_flag) return;
				_flag = true;
				_plane.rotateTo(Math.random() * 360, Math.random() * 360, Math.random() * 360);
				_plane.scaleX = _plane.scaleY = _plane.scaleZ = 0;
				_plane.rotationY = 0;
				var mat : TextureMaterial = _plane.material as TextureMaterial;
				mat.alpha = 0.4;
				var scale : Number = Math.random() * 0.3 + 0.9;
				Tween24.serial(
					Tween24.parallel(
						Tween24.tween(_plane, 0.3, Ease24._1_SineOut).scaleX(1).scaleY(1).scaleZ(1)
						, Tween24.tween(mat, 0.3).alpha(0.5))
					, Tween24.parallel(
						Tween24.tween(_plane, 0.25, Ease24._2_QuadIn).scaleX(scale).scaleY(scale).scaleZ(scale)
						,Tween24.tween(mat, 0.25, Ease24._2_QuadIn).alpha(0)
					)
					, Tween24.func(function() : void{_flag = false;})
				).play();
			}
		}
		// --------------------------------------------------------------------------
		//
		// Exprosion Smoke
		//
		// --------------------------------------------------------------------------
		class ExplosionSmoke extends ObjectContainer3D
		{
			[Embed(source="/../embeds/lensflare/flare2.jpg")]
			private var Smoke:Class;
			
			private static const DOMAIN_PATH : String = "http://www.romatica.com/dev/wonderfl/explosion/";
			private static const IMAGE_URL_SMOKE : String = DOMAIN_PATH + "smoke.png";
			private var _size : int;
			private var _loader : Loader;
			private var bitmapData : BitmapData;
			private var _sp3d : Sprite3D;
			private var mat : TextureMaterial;
			private var _lightPicker : LightPickerBase;
			
			public function ExplosionSmoke(size : int = 512, lightPicker : LightPickerBase = null)
			{
				super();
				
				if (lightPicker) _lightPicker = lightPicker;
				_size = size || 512;
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete_Handler);
				//_loader.load(new URLRequest(IMAGE_URL_SMOKE), new LoaderContext(true));
				
				bitmapData = new Smoke() as BitmapData;
				
				visible = false;
			}
			
			private function loadComplete_Handler(event : Event) : void
			{
				bitmapData = ((event.target as LoaderInfo).content as Bitmap).bitmapData;
				createObject();
			}
			
			private function createObject() : void
			{
				mat = new TextureMaterial(new BitmapTexture(bitmapData));
				mat.bothSides = true;
				mat.alphaBlending = true;
				if (_lightPicker) mat.lightPicker = _lightPicker;
				mat.specular = 1;
				
				_sp3d = addChild(new Sprite3D(mat, _size, _size)) as Sprite3D;
			}
			
			public function doEffect() : void
			{
				if (!_sp3d) return ;
				
				_sp3d.scaleX = _sp3d.scaleY = 0;
				_sp3d.rotationY = 0;
				_sp3d.rotateTo(Math.random() * 180, Math.random() * 180, Math.random() * 180);
				mat.alpha = 1;
				Tween24.tween(_sp3d, 1, Ease24._5_QuintOut).scaleX(1).scaleY(1).rotationY(Math.random() * 48).play();
				Tween24.tween(mat, 1, Ease24._5_QuintOut).alpha(0).play();
				visible = true;
			}
		}
		
		
		
