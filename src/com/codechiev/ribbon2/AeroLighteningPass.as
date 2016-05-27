package com.codechiev.ribbon2
{
    import __AS3__.vec.*;
    
    import away3d.cameras.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.filters.*;
    import away3d.materials.passes.*;
    import away3d.materials.utils.*;
    
    import com.codechiev.away3d.utils.AGAL;
    
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
	
	import away3d.*;
	use namespace arcane;

    public class AeroLighteningPass extends MaterialPassBase
    {
        private var _fragmentData:Vector.<Number>;
        private var _vertexData:Vector.<Number>;
        private var _cameraPositionData:Vector.<Number>;
        private var _camConfigs:Vector.<OrthConfig>;
        //private var _filter:Filter3DBase;
        public var name:String;
        private var _bufferReady:Boolean;
        private var _ci:uint;
        private var _texs:Vector.<Texture>;
        private var _buffs:Vector.<Texture>;

        public function AeroLighteningPass()
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
            _vertexData[1] = -1;
            _vertexData[2] = 1;
            _vertexData[3] = 0;
            _vertexData[4] = 0.05;
            _vertexData[5] = 1;
            _vertexData[6] = 300;
            _vertexData[7] = 0.5;
            _camConfigs = new Vector.<OrthConfig>;
            //_filter = new BlurFilter3D(7, 7, 4);
            _texs = new Vector.<Texture>(8, true);
            _buffs = new Vector.<Texture>(8, true);
            return;
        }// end function

        public function getConfig(param1:int) : OrthConfig
        {
            return _camConfigs[param1];
        }// end function

        public function addConfig(param1:OrthConfig) : void
        {
            _camConfigs.push(param1);
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

		arcane override  function getVertexCode() : String
        {
            //_projectedTargetRegister = "vt2";
            var code:String = "";
            code = code + AGAL.mov("vt0.xyz", "va0.xyz");
            code = code + AGAL.mov("vt0.w", "vc5.z");
            code = code + AGAL.sub("vt3.w", "va0.z", "vc5.w");
            code = code + AGAL.abs("vt3.w", "vt3.w");
            code = code + AGAL.mul("vt3.w", "vt3.w", "vc6.x");
            code = code + AGAL.add("vt3.w", "vt3.w", "vc6.y");
            code = code + AGAL.rcp("vt3.w", "vt3.w");
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
            code = code + AGAL.mul("vt3.z", "vt0.z", "vc5.y");
            code = code + AGAL.sub("vt3.w", "vt3.w", "vt3.z");
            code = code + AGAL.mul("v0.zw", "vt3.w", "va0.w");
            code = code + AGAL.mov("op", "vt0");
            return code;
        }// end function

		arcane override function getFragmentCode(fragmentAnimatorCode:String) : String
        {
            var code:String = "";
            code = code + AGAL.mov("ft0.w", "fc0.x");
            code = code + AGAL.mov("ft0.xyz", "v0.w");
            code = code + AGAL.mov("oc", "ft0");
            return code;
        }// end function

		arcane override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, viewProjection:Matrix3D):void
		{
			var context3D:Context3D = stage3DProxy.context3D;
            var _loc_7:OrthConfig = null;
            var _loc_9:Matrix3D = null;

            if (renderable.numTriangles < 1)
            {
                return;
            }
			var aero:AeroSubmesh = renderable as AeroSubmesh;
			var geom:RibbonGeometry = aero.subGeometry as RibbonGeometry;
            _vertexData[3] = aero.planeX;
			context3D.setCulling(Context3DTriangleFace.FRONT);
			context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, _vertexData, 2);
			var sceneTransform:Matrix3D = aero.getRenderSceneTransform(null);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 7, sceneTransform, true);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 11, renderable.inverseSceneTransform);
			renderable.activateVertexBuffer(0, stage3DProxy);
			renderable.activateVertexTangentBuffer(1, stage3DProxy);
			renderable.activateUVBuffer(2, stage3DProxy);
			context3D.setVertexBufferAt(3, geom.getVertexWaveBuffer(context3D), 0, Context3DVertexBufferFormat.FLOAT_4);
			context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, _fragmentData, 1);
            var _loc_8:int = 0;
            while (_loc_8 < _camConfigs.length)
            {
                
                _loc_7 = _camConfigs[_loc_8];
                _cameraPositionData[0] = _loc_7.campos.x;
                _cameraPositionData[1] = _loc_7.campos.y;
                _cameraPositionData[2] = _loc_7.campos.z;
                _loc_9 = new Matrix3D();
                _loc_9.copyFrom(sceneTransform);
                _loc_9.append(_loc_7.cam.viewProjection);
				context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _loc_9, true);
				context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, _cameraPositionData, 1);
				context3D.drawTriangles(geom.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
                _loc_8++;
            }
            return;
        }// end function

        public function renderFilter(param1:Context3D, param2:uint, param3:Camera3D, param4:Texture = null) : void
        {
            //_filter.render(param1, getrenderablee(param1, param2), param3);
            return;
        }// end function

        public function getTexture(param1:Context3D, param2:uint) : Texture
        {
            if (_texs[param2] == null)
            {
                _texs[param2] = param1.createTexture(256, 256, Context3DTextureFormat.BGRA, true);
                param1.setRenderToTexture(_texs[param2], false, 0);
                param1.clear(0, 0, 0, 1);
            }
            return _texs[param2];
        }// end function

        public function getBuffer(param1:Context3D, param2:uint) : Texture
        {
            if (_buffs[param2] == null)
            {
                _buffs[param2] = param1.createTexture(256, 256, Context3DTextureFormat.BGRA, true);
                param1.setRenderToTexture(_buffs[param2], false, 0);
                param1.clear(0, 0, 0, 1);
                //model.replaceTarget(param1);
            }
            return _buffs[param2];
        }// end function

		override arcane function activate(stage3DProxy:Stage3DProxy, camera:Camera3D):void
        {
			stage3DProxy.context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);//Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA
			super.activate(stage3DProxy, camera);
        }// end function

		arcane override function updateProgram(stage3DProxy:Stage3DProxy) : void
		{
			var fragmentAnimatorCode:String = "";
			AGALProgram3DCache.getInstance(stage3DProxy).setProgram3D(this, getVertexCode(), getFragmentCode(fragmentAnimatorCode));
		}// end function

        public function get bufferReady() : Boolean
        {
            return _bufferReady;
        }// end function

    }
}
