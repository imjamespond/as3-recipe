package 
{
	/**
	 * adjust both vertext & vertext RGB 
	 */	
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	import flash.utils.getTimer;

	[SWF(width="500", height="500", frameRate="60", backgroundColor="#FFFFFF")]
	public class AgalColorfulTriangle011 extends Sprite
	{
		private var context3D:Context3D;
		private var vertexbuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D; 
		private var program:Program3D;
		
		public function AgalColorfulTriangle011()
		{
			//First, you need initialize your stage as you program any 2D projects.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//You need to a create 3D stage.
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, initializeContext3D);
			stage.stage3Ds[0].requestContext3D();
			
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		private function initializeContext3D(e:Event):void
		{
			//Initialize context3D;		
			context3D = stage.stage3Ds[0].context3D;				
			context3D.configureBackBuffer(500, 500, 1, true);
			
			//Init vertex buffer.
			var vertices:Vector.<Number> = Vector.<Number>([
				// x,y,z, uv  r,g,b
				 0,0,0, 1,0,  1,0,0, 
				 1,0,0, 1,0,  0,1,0,
				 0,1,0, 1,0,  0,0,1]);		
			// 3 vertices, of 6 Numbers each
			vertexbuffer = context3D.createVertexBuffer(vertices.length/8, 8);		
			// offset 0, 3 vertices
			vertexbuffer.uploadFromVector(vertices, 0, vertices.length/8);
			
			//Init index buffer
			// total of 3 indices. 1 triangles by 3 vertices
			indexBuffer = context3D.createIndexBuffer(3);						
			// offset 0, count 3
			indexBuffer.uploadFromVector (Vector.<uint>([0, 1, 2]), 0, 3);
				
			//Create vertex assembler;
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"mov vt0 va0\n" +
				"mov vt1 vc0\n"+
				"sin vt1.w vt1.w\n" +
				"mul vt0.xy vt0.xy vt1.w\n"+ //
				"mov op, vt0\n" +
				"mov v0, va2\n" + 
				"mov v1, va1\n"
			);
			//Create fragment assembler;
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"mov ft0, v0\n" +
				"mov ft1, fc0\n" +
				"sin ft1, ft1\n" +
				"abs ft1, ft1\n"+
				"mul ft0, ft0, ft1.x\n"+
				"mov oc, ft0"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		
		protected function onRender(e:Event):void
		{
			if (!context3D) 
				return;
			
			context3D.clear (1, 1, 1, 1);
			
			// vertex position to attribute register 0
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// uv coordinates to attribute register 1
			context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);	
			// test coordinates to attribute register 1
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			// assign shader program
			context3D.setProgram(program);
			
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 0, 0, getTimer()/1000]);//
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, new<Number>[getTimer()/1000, 0, 0, 0]);//x,y,z,w
			
			context3D.drawTriangles(indexBuffer);
			
			context3D.present();
		}
	}
}