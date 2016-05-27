package com.codechiev.ribbon2
{
    import __AS3__.vec.*;
    
    import away3d.*;
    import away3d.cameras.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.materials.passes.*;
    import away3d.materials.utils.*;
    import away3d.textures.ATFTexture;
	use namespace arcane;
    
    import com.codechiev.away3d.utils.AGAL;
    
    import flash.display3D.*;
    import flash.geom.*;


    public class AeroPass extends MaterialPassBase
    {
        private var _diffuseColor:uint;
        private var _fragmentData:Vector.<Number>;
        private var _vertexData:Vector.<Number>;
        private var _cameraPositionData:Vector.<Number>;
        private var _texture:ATFTexture;

        public function AeroPass()
        {
            _cameraPositionData = new Vector.<Number>(4, true);
            _cameraPositionData[3] = 1;
            _vertexData = new Vector.<Number>(4, true);
            _fragmentData = new Vector.<Number>(4, true);
            _fragmentData[0] = 1;
            _fragmentData[1] = 1;
            _fragmentData[2] = 1;
            _fragmentData[3] = 1;
            _vertexData = new Vector.<Number>(8, true);
            _vertexData[0] = 250;
            _vertexData[1] = 50;
            _vertexData[2] = 1;
            _vertexData[3] = 0;
            _vertexData[4] = 0.0035;
            _vertexData[5] = 20;
            _vertexData[6] = 300;
            _vertexData[7] = 0.5;
            return;
        }// end function

		public function get atf() : ATFTexture
		{
			return _texture ;//? (_texture.atfData) : (null);
		}// end function
		
		public function set atf(texture:ATFTexture) : void
		{
			_texture = texture;
			return;
		}// end function

        public function get xplane() : Number
        {
            return _vertexData[3];
        }// end function

        public function set xplane(param1:Number) : void
        {
            _vertexData[3] = param1;
            return;
        }// end function

        public function get ribbonWidth() : Number
        {
            return _vertexData[0];
        }// end function

        public function set ribbonWidth(param1:Number) : void
        {
            _vertexData[0] = param1;
            return;
        }// end function

        public function get uvmult() : Number
        {
            return _vertexData[1];
        }// end function

        public function set uvmult(param1:Number) : void
        {
            _vertexData[1] = param1;
            return;
        }// end function

		arcane override  function getVertexCode() : String
        {
            //_projectedTargetRegister = "vt2";
            var code:String = "";
            code = code + AGAL.mov("vt0.xyz", "va0.xyz"); 
            code = code + AGAL.mov("vt0.w", "vc5.z");
            code = code + AGAL.sub("vt1.w", "va0.z", "vc5.w");
            code = code + AGAL.abs("vt1.w", "vt1.w");
            code = code + AGAL.add("vt1.w", "vt1.w", "vc6.y");
            code = code + AGAL.mul("vt1.w", "vt1.w", "vc6.x");
            code = code + AGAL.sub("v0.zw", "va0.w", "vt1.w");
            code = code + AGAL.mov("vt1.xyz", "va3.xyz");
            code = code + AGAL.add("vt0.xyz", "vt0.xyz", "vt1.xyz");
            code = code + AGAL.add("vt1", "vt0", "va1");
            code = code + AGAL.m34("vt0.xyz", "vt0", "vc7");
            code = code + AGAL.mov("vt0.w", "vt0.w");
            code = code + AGAL.m34("vt1.xyz", "vt1", "vc7");
            code = code + AGAL.mov("vt1.w", "vt0.w");
            code = code + AGAL.sub("vt1", "vt1", "vt0");
            code = code + AGAL.sub("vt2", "vt0", "vc4");
            code = code + AGAL.cross("vt2.xyz", "vt2.xyz", "vt1.xyz");
            code = code + AGAL.normalize("vt2.xyz", "vt2.xyz");
            code = code + AGAL.mov("v0.x", "vc5.z");
            code = code + AGAL.mul("vt1.y", "va2.x", "vc6.w");
            code = code + AGAL.add("v0.y", "vt1.y", "vc6.w");
            code = code + AGAL.mul("vt2", "vt2", "vc5.x");
            code = code + AGAL.mul("vt2", "vt2", "va2.x");
            code = code + AGAL.add("vt1", "vt0", "vt2");
            code = code + AGAL.m33("vt1.xyz", "vt1", "vc11");
            code = code + AGAL.m44("vt0", "vt1", "vc0");
            code = code + AGAL.mov("op", "vt0");
            return code;
        }// end function

		arcane override function getFragmentCode(fragmentAnimatorCode:String) : String
        {
            var code:String = "";
            code = code + AGAL.sample("ft0", "v0", "2d", "fs0", "nearestMip", "repeat");
            code = code + AGAL.mov("ft0.w", "v0.w");
            code = code + AGAL.mov("oc", "ft0");
            return code;
        }// end function

		arcane override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{	
			var context3D:Context3D = stage3DProxy.context3D;
            if (renderable.numTriangles < 1)
            {
                return;
            }
            var aero:AeroSubmesh = renderable as AeroSubmesh;
			var geom:RibbonGeometry = aero.subGeometry as RibbonGeometry;
			var camPos:Vector3D = camera.scenePosition;
            _cameraPositionData[0] = camPos.x;
            _cameraPositionData[1] = camPos.y;
            _cameraPositionData[2] = camPos.z;
            _vertexData[3] = aero.planeX;
            _vertexData[4] = aero.decay;
			context3D.setCulling(Context3DTriangleFace.FRONT);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjection, true);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, _cameraPositionData, 1);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, _vertexData, 2);
			var sceneTransform:Matrix3D = aero.getRenderSceneTransform(null);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 7, sceneTransform, true);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 11, renderable.inverseSceneTransform);
			renderable.activateVertexBuffer(0, stage3DProxy);
			renderable.activateVertexTangentBuffer(1, stage3DProxy);
			renderable.activateUVBuffer(2, stage3DProxy);
			context3D.setVertexBufferAt(3, geom.getVertexWaveBuffer(context3D), 0, Context3DVertexBufferFormat.FLOAT_4);
			context3D.setTextureAt(0, _texture.getTextureForStage3D(stage3DProxy));
			
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _fragmentData, 1);
			context3D.drawTriangles(geom.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);//trace("lightpass.numTriangles:",renderable.numTriangles);
        }// end function

		override arcane function activate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
		{
			stage3DProxy.context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);//Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA	
			stage3DProxy.context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
			super.activate(stage3DProxy, camera);
            return;
        }// end function


		arcane override function updateProgram(stage3DProxy:Stage3DProxy) : void
		{
			var fragmentAnimatorCode:String = "";
			AGALProgram3DCache.getInstance(stage3DProxy).setProgram3D(this, getVertexCode(), getFragmentCode(fragmentAnimatorCode));
		}// end function

    }
}
