package
/**
 *Motion Blur and blend texture
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
	public class AgalSample6_2 extends Sprite
	{
		[Embed( source = "sedan.jpg" )]
		protected const TextureBitmap:Class;
		[Embed(source=("a.png"))]
		private var ImageSource2:Class;
		
		private const WIDTH:Number 		= 512;
		private const HEIGHT:Number 		= 512;	
		
		private var intensity:Number 		= 0;
		private var offsetU:Number 		= 0.4;
		private var offsetV:Number 		= 0.6;
		private var radius:Number 			= 0.4;
		private var fconstants : Vector.<Number>;	
		
		protected var context3D:Context3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexBuffer:IndexBuffer3D; 
		protected var program:Program3D;
		protected var texture:Texture;
		protected var texture1:Texture;
		protected var texture2:Texture;
		protected var texture3:Texture;
		protected var texture4:Texture;
		private var quadIndices : IndexBuffer3D ;
		private var quadVertices : VertexBuffer3D ;
		
		public function AgalSample6_2()
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
			
			texture1 = context3D.createTexture(this.WIDTH,this.HEIGHT, Context3DTextureFormat.BGRA, true);
			texture1.uploadFromBitmapData(new BitmapData(this.WIDTH,this.HEIGHT));
			texture2 = context3D.createTexture(this.WIDTH,this.HEIGHT, Context3DTextureFormat.BGRA, true);
			texture2.uploadFromBitmapData(new BitmapData(this.WIDTH,this.HEIGHT));
			texture3 = context3D.createTexture(this.WIDTH,this.HEIGHT, Context3DTextureFormat.BGRA, true);
			texture3.uploadFromBitmapData(new BitmapData(this.WIDTH,this.HEIGHT));
			
			var bm2:Bitmap = Bitmap(new ImageSource2());
			texture4 = context3D.createTexture(bm2.width,bm2.height, "bgra", false);
			texture4.uploadFromBitmapData(bm2.bitmapData);
			
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
				"mov ft2, v0\n" +
				"mov ft3, fc0\n" +
				"sin ft3, ft3\n" +
				"add ft2.xy, ft2.xy, ft3.xy\n"+
				"tex ft0, v0, fs0<2d,nearest>\n" +
				"tex ft1, ft2, fs1<2d,nearest>\n" +

				"mov ft4.xyzw, fc0.wwww\n"+
				"sge ft4.xyz, ft4.xyz, ft1.yyy\n"+//透明的 置1,有像素的置0
				"mul ft0, ft0, ft4\n"+//去掉有overlay中像素的
				//"kil ft4.x\n"+
				"add oc, ft0, ft1";
			
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
			
			
			//context3D.configureBackBuffer(800, 600,0);
			//context3D.setRenderToBackBuffer();
			context3D.setRenderToTexture (texture1,true,0,0);//将oc输出到贴图中去，然后再通过这段程序对贴图进行处理就可以了			!!注意要开启 depthstencil
			
			context3D.setProgram(program);
			
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);			
			
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 1, final, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 1, 1, getTimer()/1000]);//
			
			context3D.setProgramConstantsFromVector("fragment", 0, fconstants,1);//設置第一個片斷常量寄存器 fc0 (x, y, z, w)
			context3D.setProgramConstantsFromMatrix("fragment", 1, new Matrix3D());//单位矩阵，采樣时候用
			
			context3D.setTextureAt(0, texture);	
			context3D.setTextureAt(1, texture4);	
			
			context3D.clear(0, 0, 0, 1);	
			context3D.drawTriangles(indexBuffer);
			
			
			
			//context3D.setRenderToBackBuffer();
			context3D.setRenderToTexture (texture3,true,0,0);//这里设置后不能用在setTexture里
			
			var vertexShaderAssembler : AGALMiniAssembler 	= new AGALMiniAssembler();
			var vertexAssembleStr:String					=
				"mov op, va0\n" +
				"mov v0, va1";
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,vertexAssembleStr);		
			var fragmentShaderAssembler : AGALMiniAssembler	= new AGALMiniAssembler();
			var fragmentAssembleStr:String					=
				"tex ft0, v0, fs0<2d,nearest>\n"+
				"tex ft1, v0, fs1<2d,nearest>\n"+
				"sub ft1, ft1, ft0\n" +
				"mul ft1, ft1, fc0.z\n"+
				"add ft0, ft0, ft1\n"+
				"mov oc, ft0"
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,fragmentAssembleStr);
			var filterPgm:Program3D						= context3D.createProgram();
			filterPgm.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			context3D.setProgram(filterPgm);
			
			context3D.setVertexBufferAt(0, quadVertices, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(1, quadVertices, 2, Context3DVertexBufferFormat.FLOAT_2);			
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fconstants, fconstants.length / 4);
			
			context3D.setTextureAt (0, texture1);
			context3D.setTextureAt (1, texture2);
			
			context3D.clear(0, 0, 0, 1);
			context3D.drawTriangles(quadIndices,0,2);//在tmp上画画 四个顶点,从第几个点绘制,绘制数量
			context3D.setTextureAt (1, null);
			
			
			///*
			context3D.setRenderToBackBuffer();
			
			var vertexShaderAssembler2 : AGALMiniAssembler 	= new AGALMiniAssembler();
			var vertexAssembleStr2:String					=
				"mov op, va0\n" +
				"mov v0, va1";
			vertexShaderAssembler2.assemble( Context3DProgramType.VERTEX,vertexAssembleStr2);		
			var fragmentShaderAssembler2 : AGALMiniAssembler= new AGALMiniAssembler();
			var fragmentAssembleStr2:String					=
				"tex oc, v0, fs0<2d,linear,nomip>\n";
			fragmentShaderAssembler2.assemble( Context3DProgramType.FRAGMENT,fragmentAssembleStr2);
			var filterPgm2:Program3D						= context3D.createProgram();
			filterPgm2.upload( vertexShaderAssembler2.agalcode, fragmentShaderAssembler2.agalcode);
			context3D.setProgram(filterPgm2);
			
			context3D.setVertexBufferAt(0, quadVertices, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(1, quadVertices, 2, Context3DVertexBufferFormat.FLOAT_2);
			
			var tmp:Texture = texture3;
			texture3 = texture2;
			texture2 = tmp;	
			context3D.setTextureAt(0, texture3);
			
			context3D.clear(0, 0, 0, 1);
			context3D.drawTriangles(quadIndices,0,2);//在tmp上画画 四个顶点,从第几个点绘制,绘制数量
			//*/
			
			
			
			context3D.present();
		}
		
		
		
		
		
		
		
		
		
		private function start():void
		{
			var tf1:TextField	= new TextField();
			tf1.appendText('intense:');
			tf1.x		= 352;
			tf1.y		= 432;
			tf1.textColor = 0xFFFFFF;
			addChild(tf1);
			var tf2:TextField	= new TextField();
			tf2.appendText('X:');
			tf2.x		= 342;
			tf2.y		= 452;
			tf2.textColor = 0xFFFFFF;
			addChild(tf2);
			var tf3:TextField	= new TextField();
			tf3.appendText('Y:');
			tf3.x		= 342;
			tf3.y		= 472;
			tf3.textColor = 0xFFFFFF;
			addChild(tf3);
			var tf4:TextField	= new TextField();
			tf4.appendText(' ');
			tf4.x		= 332;
			tf4.y		= 492;
			tf4.textColor = 0xFFFFFF;
			addChild(tf4);			
			
			
			new PushButton(this, 182, 487, "open", onUpload);
			//new HSlider(this, 392, 492, onBar).setSliderParams(0, 100, 0);
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