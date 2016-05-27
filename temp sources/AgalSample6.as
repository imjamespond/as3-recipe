package
/**
 * Rational Blur 
 */
{
	import com.adobe.utils.*;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.*;
	import flash.display3D.textures.Texture;
	import flash.events.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
	public class AgalSample6 extends Sprite
	{
		[Embed( source = "sedan.jpg" )]
		protected const TextureBitmap:Class;
		
		private const WIDTH:Number 		= 512;
		private const HEIGHT:Number 		= 512;	

		private var intensity:Number 		= 5;
		private var offsetU:Number 		= 0.4;
		private var offsetV:Number 		= 0.6;
		private var radius:Number 			= 0.4;
		private var fconstants : Vector.<Number>;	
		
		protected var context3D:Context3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D; 
		protected var program:Program3D;
		protected var texture:Texture;
		private var quadIndices : IndexBuffer3D ;
		private var quadVertices : VertexBuffer3D ;
		
		public function AgalSample6()
		{
			stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initMolehill );
			stage.stage3Ds[0].requestContext3D();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;			

			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function initMolehill(e:Event):void
		{
			fconstants		= new <Number> [
				offsetU /* center x (u) */,
				offsetV /* center y (v) */,
				radius /* radius of the circle fully inside 1x1 uv quad */,
				intensity//strength.value /* p > 1, to compress image radially */
			];
			
			
			
			context3D 		= stage.stage3Ds[0].context3D;			
			
			context3D.configureBackBuffer(800, 600, 1, true);
			
			var vertices:Vector.<Number> = Vector.<Number>([
				-1,-1,0, 0, 0, // x, y, z, u, v
				-1, 1, 0, 0, 1,
				1, 1, 0, 1, 1,
				1, -1, 0, 1, 0,
				
				0, 0, 1, 0, 0,
				//prepare for index0 as UV coordinate of index0 is in conflict with The index4
				0, 0, 1, 1, 1
			]);
			
			// 4 vertices, of 5 Numbers each
			vertexbuffer = context3D.createVertexBuffer(vertices.length/5, 5);
			// offset 0, 4 vertices
			vertexbuffer.uploadFromVector(vertices, 0, vertices.length/5);
			
			// total of 6 indices. 2 triangles by 3 vertices each
			indexBuffer = context3D.createIndexBuffer(18);					
			// offset 0, count 6
			indexBuffer.uploadFromVector (Vector.<uint>([
				//bottom
				0,1,2,
				2,3,0,
				
				5,0,1,
				4,1,2,
				4,2,3,
				5,3,0]), 0, 18);//3 point define a plane 
			
			var bitmap:Bitmap = new TextureBitmap();
			texture = context3D.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmap.bitmapData);
			
			var vertexShaderAssembler : AGALMiniAssembler 	= new AGALMiniAssembler();
			var vertexAssembleStr:String					=
				//"mov op, va0\n" +
				
				"mov vt6 vc0\n"+
				
				"mov vt2 vc1\n"+
				"mov vt3 vc2\n"+
				"mov vt4 vc3\n"+
				"mov vt5 vc4\n"+
				
				//"add vt2.z vt2.z vt2.z\n"+ //对顶点变形
				"sin vt6.w vt6.w\n"+ //
				//"mul vt2.x vt2.x vt6.w\n"+ //拉伸
				//"mul vt3.y vt3.y vt6.w\n"+ //
				//"mul vt4.z vt4.z vt6.w\n"+ //
				
				"add vt2.w vt2.w vt6.w\n"+ //平移,额...旋转在外面append到vc0即vt6了		
				
				"m44 op, va0, vt2\n" + // project to clipspace
				
				"mov vt0, va1\n" +				//將頂點移至 頂點臨時寄存器 一个顶点对应一个UV坐标
				//"neg vt0.y, vt0.y\n" +			//將Y軸顛倒
				//"add vt0.y, vt0.y, vc0.y\n" +	//y+1？
				"div vt0, vt0, vc0.y\n" +		//when <1 mean anplify/escalate; when >1 mean shrink
				
				"mov v0, vt0";

			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,vertexAssembleStr);

			
			var fragmentShaderAssembler : AGALMiniAssembler	= new AGALMiniAssembler();
			var fragmentAssembleStr:String					=
				"tex ft1, v0, fs0 <2d,linear,nomip>\n" + //<2d,nearest,repeat>
				"mov oc, ft1";
			
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,fragmentAssembleStr);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			
			
			quadIndices = context3D.createIndexBuffer(6);
			quadIndices.uploadFromVector(Vector.<uint>([0, 2, 1, 1, 2, 3]), 0, 6);
			
			quadVertices = context3D.createVertexBuffer(4, 4);
			quadVertices.uploadFromVector(Vector.<Number>([-1, -1, 0, 1, -1, 1, 0, 0, 1, -1, 1, 1, 1, 1, 1, 0]), 0, 4);
			
			start();
			
		}
		
		protected function onRender(e:Event):void
		{
			if ( !context3D ) 
				return;
			
			//context3D.clear ( 1, 1, 1, 1 );
			
			// vertex position to attribute register 0
			context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// uv coordinates to attribute register 1
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			
			
			// assign texture to texture sampler 0
			context3D.setTextureAt(0, texture);			
			// assign shader program
			context3D.setProgram(program);
			
			//matrix transforms
			//view
			var view:Matrix3D	= new Matrix3D();
			view.appendTranslation( 0, 0, -4 );//視角平移
			
			//modle
			var model:Matrix3D 	= new Matrix3D();
			//model.appendRotation( getTimer()/50, Vector3D.Z_AXIS);
			model.appendRotation( getTimer()/50, Vector3D.X_AXIS);
			//model.appendRotation( getTimer()/50, Vector3D.Y_AXIS);
			//trace(getTimer()/50 + '-' + model.rawData);
			
			//projection
			var projection:PerspectiveMatrix3D = new PerspectiveMatrix3D();
			projection.perspectiveFieldOfViewRH( 45, 1, 1, 100 ); //fov aspectRadio畫面比例 Z軸視距近戰與遠點
			
			//final
			var final:Matrix3D	= new Matrix3D();
			final.append( model );
			final.append( view );//trace(view.rawData);
			final.append( projection );
			
		

			


			
			// vertex position to attribute register 0
			context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// uv coordinates to attribute register 1
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);		
			// assign texture to texture sampler 0
			context3D.setTextureAt(0, texture);			
			// assign shader program
			context3D.setProgram(program);			
			//set const for vertex shader
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, final, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 1, 1, getTimer()/1000]);//
			//set const for fragment shader
			context3D.setProgramConstantsFromVector("fragment", 0, new<Number>[0, intensity, intensity*2, 28]);//設置第一個片斷常量寄存器 fc0 (x, y, z, w)
			context3D.setProgramConstantsFromMatrix("fragment", 1, new Matrix3D());//单位矩阵，采樣时候用
			
			//context3D.configureBackBuffer(800, 600,0);
			var tmp:Texture = context3D.createTexture (512, 512, Context3DTextureFormat.BGRA,true);//
			context3D.setRenderToTexture (tmp,true,0,0);//将oc输出到贴图中去，然后再通过这段程序对贴图进行处理就可以了			!!注意要开启 depthstencil
			context3D.clear ( 1, 1, 1, 1 );		
			context3D.drawTriangles(indexBuffer);
			
			
			
			/**/
		
			var vertexShaderAssembler : AGALMiniAssembler 	= new AGALMiniAssembler();
			var vertexAssembleStr:String					=
				"mov op, va0\n" +
				"mov v0, va1";
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,vertexAssembleStr);
			
			var fragmentShaderAssembler : AGALMiniAssembler	= new AGALMiniAssembler();
			var fragmentAssembleStr:String					=
				"sub ft0, v0, fc0\n" +
				"sub ft0.zw, ft0.zw, ft0.zw\n" /* ft0 = radius vector */  +
				"dp3 ft1, ft0, ft0\n" /* ft1 = radius, squared */ +
				"sqt ft1, ft1\n" /* ft1 = radius */ +
				"div ft1.xy, ft1.xy, fc0.zz\n" /* ft1.xy = normalized radius */ +
				"pow ft1.x, ft1.x, fc0.w\n" /* ft1.x = normalized radius ^ p */ +
				"mul ft0.xy, ft0.xy, ft1.xx\n" +
				"div ft0.xy, ft0.xy, ft1.yy\n" /* ft0 = scaled radius vector */ +
				"add ft0.xy, ft0.xy, fc0.xy\n" /* ft0 = corresponding uv */ +
				"tex oc, ft0, fs0<2d,clamp,linear>\n";
			
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,fragmentAssembleStr);
			var _program3D:Program3D						= context3D.createProgram();
			_program3D.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			context3D.setProgram(_program3D);
			// vertex position to attribute register 0
			context3D.setVertexBufferAt(0, quadVertices, 0, Context3DVertexBufferFormat.FLOAT_2);
			// uv coordinates to attribute register 1
			context3D.setVertexBufferAt(1, quadVertices, 2, Context3DVertexBufferFormat.FLOAT_2);
			// now apply inverse transform	
			context3D.setRenderToBackBuffer();
			context3D.setTextureAt (0, tmp);
			//
			//context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, final, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fconstants, fconstants.length / 4);
			//
			context3D.clear(0, 0, 0, 1);
			context3D.drawTriangles(quadIndices,0,-1);//在tmp上画画 四个顶点,从第几个点绘制,绘制数量
			

			context3D.present();
		}
		
		
		
		
		
		
		
		
		
		private function start():void
		{
			var tf1:TextField	= new TextField();
			tf1.appendText('radius:');
			tf1.x		= 352;
			tf1.y		= 432;
			addChild(tf1);
			var tf2:TextField	= new TextField();
			tf2.appendText('focusX:');
			tf2.x		= 342;
			tf2.y		= 452;
			addChild(tf2);
			var tf3:TextField	= new TextField();
			tf3.appendText('focusY:');
			tf3.x		= 342;
			tf3.y		= 472;
			addChild(tf3);
			var tf4:TextField	= new TextField();
			tf4.appendText('intensity:');
			tf4.x		= 332;
			tf4.y		= 492;
			addChild(tf4);			
			
			
			new PushButton(this, 182, 487, "open", onUpload);
			new HSlider(this, 392, 492, onBar).setSliderParams(1, 100, 50);
			new HSlider(this, 392, 452, onBarU).setSliderParams(0, 1, .5);
			new HSlider(this, 392, 472, onBarV).setSliderParams(0, 1, .5);
			new HSlider(this, 392, 432, onBarR).setSliderParams(0, 1, .5);
		}
		
		private function onBar(e:Event):void
		{
			intensity 	= e.currentTarget.value * .1;
			fconstants	= new <Number> [offsetU,offsetV,radius,intensity];
		}
		private function onBarU(e:Event):void
		{
			offsetU 	= e.currentTarget.value;
			fconstants	= new <Number> [offsetU,offsetV,radius,intensity];
		}
		private function onBarV(e:Event):void
		{
			offsetV 	= e.currentTarget.value;
			fconstants	= new <Number> [offsetU,offsetV,radius,intensity];
		}
		private function onBarR(e:Event):void
		{
			radius 	= e.currentTarget.value;trace(radius);
			fconstants	= new <Number> [offsetU,offsetV,radius,intensity];
		}		
		private function onUpload(e:Event):void
		{
			var fr:FileReference = new FileReference();
			fr.addEventListener(Event.SELECT, onSelect);
			fr.browse([new FileFilter("图片", "*.jpg;*.png")]);
		}
		
		private function onSelect(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.SELECT, onSelect);
			e.currentTarget.addEventListener(Event.COMPLETE, onComplete);
			e.currentTarget.addEventListener(Event.OPEN, function(e:Event):void { } );
			e.currentTarget.load();
		}
		
		private function onComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, onComplete);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderOnComplete);
			loader.loadBytes(e.currentTarget.data);
		}
		
		private function loaderOnComplete(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.COMPLETE, loaderOnComplete);
			
			var btmap:BitmapData = new BitmapData(WIDTH, HEIGHT);
			btmap.draw(e.currentTarget.loader, new Matrix(1, 0, 0, 1, (WIDTH - e.currentTarget.loader.width) / 2, (HEIGHT - e.currentTarget.loader.height) / 2));
			
			texture.uploadFromBitmapData(btmap);
			
		}		
		
		
		
	}//class

}//package