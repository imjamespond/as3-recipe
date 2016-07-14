package 
{
	/**
	 * adjust both vertext & vertext RGB 
	 */	
	import com.adobe.utils.AGALMiniAssembler;
	import com.bit101.components.CheckBox;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.utils.getTimer;

	[SWF(width="500", height="500", frameRate="60", backgroundColor="#FFFFFF")]
	public class AgalSetDepthTest extends Sprite
	{
		private var context3D:Context3D;
		private var vertexbuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D; 
		private var program:Program3D;
		private var program2:Program3D;
		
		private var passCompareMode:String=Context3DCompareMode.LESS;
		private var destinationFactor:String=Context3DBlendFactor.ZERO;
		
		public function AgalSetDepthTest()
		{
			init();
			
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
				 0,0,.99, 1,0,  1,0,0, 
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
			indexBuffer.uploadFromVector (Vector.<uint>([0, 2, 1]), 0, 3);
				
			//Create vertex assembler;
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"mov vt0 va0\n" +
				
				"mul vt0.xy vt0.xy, vc0.ww\n" +
				"mov op, vt0\n" +
				"mov v0, va2\n" + 
				"mov v1, va1\n"
			);
			//Create fragment assembler;
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"mov ft0, v0\n" +
				"mov oc, ft0"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			//Create vertex assembler;
			var vertexShaderAssembler2 : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler2.assemble( Context3DProgramType.VERTEX,
				"mov vt0 va0\n" +
				
				"sub vt0.xyz vt0.xyz, vc0.www \n" +
				"mov op, vt0\n" +
				"mov v0, va2\n" + 
				"mov v1, va1\n"
			);
			//Create fragment assembler;
			var fragmentShaderAssembler2 : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler2.assemble( Context3DProgramType.FRAGMENT,
				"mov ft0, v0\n" +
				"mov oc, ft0"
			);
			
			program2 = context3D.createProgram();
			program2.upload( vertexShaderAssembler2.agalcode, fragmentShaderAssembler2.agalcode);
		}
		
		protected function onRender(e:Event):void
		{
			if (!context3D) 
				return;
			
			context3D.clear (0, 0, 0, 1);
			
			for(var i:uint=0; i<10; i++){
				context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);	
				context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 0, 0, i*.1]);//
				
				context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
				context3D.setProgram(program2);
				context3D.setCulling(Context3DTriangleFace.BACK);
				context3D.setDepthTest(true, Context3DCompareMode.LESS);//the destination depth value will be updated from the source pixel when true. 
				context3D.drawTriangles(indexBuffer);
				context3D.setDepthTest(false, Context3DCompareMode.LESS);
			}
			
			context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(2, vertexbuffer, 5, Context3DVertexBufferFormat.FLOAT_3);	
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 0, new<Number>[0, 0, 0, -2]);//
			
			context3D.setBlendFactors(Context3DBlendFactor.ONE, destinationFactor);
			context3D.setProgram(program);
			context3D.setCulling(Context3DTriangleFace.BACK);
			context3D.setDepthTest(false, passCompareMode);
			context3D.drawTriangles(indexBuffer);
			context3D.setDepthTest(false, Context3DCompareMode.LESS);
			//context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, new<Number>[getTimer()/1000, 0, 0, 0]);//x,y,z,w
			context3D.present();
		}
		
		public function init():void{
			new CheckBox(this, 0, 0, "less or greater", function(e:Event):void{
				var selected:Boolean = e.currentTarget.selected;
				if(selected)
					passCompareMode = Context3DCompareMode.GREATER;
				else
					passCompareMode = Context3DCompareMode.LESS;
			});
			
			new CheckBox(this, 0, 20, "destinationFactor", function(e:Event):void{
				var selected:Boolean = e.currentTarget.selected;
				if(selected)
					destinationFactor = Context3DBlendFactor.DESTINATION_ALPHA;
				else
					destinationFactor = Context3DBlendFactor.ZERO;
			});
			
		}
	}
}