package com.codechiev.ribbon.material.method
{

  
    import away3d.arcane;
    import away3d.core.managers.Stage3DProxy;
    import away3d.materials.compilation.*;
    import away3d.materials.methods.*;
    import away3d.materials.utils.*;
    import away3d.textures.Texture2DBase;
    
    import com.codechiev.away3d.utils.AGAL;
	import com.codechiev.ribbon.material.compilation.RibbonShaderCompiler;
    
    import flash.display3D.*;
    import flash.geom.*;
	
	use namespace arcane;

    public class RibbonLightPaintMethod extends ShadingMethodBase
    {
        private var _camera:Vector3D;
        private var _cameraRegister:ShaderRegisterElement;
        private var _cameraRegisterIndex:int;
        //private var _centerRegister:ShaderRegisterElement;
        private var _colorRegisterIndex:int;
		
		public var pointRegister:ShaderRegisterElement;
		//public var pointIndex:uint;
		public var diffRegister:ShaderRegisterElement;
		//public var diffIndex:uint;
	
	

        public function RibbonLightPaintMethod()
        {		
            this._camera = new Vector3D();

        }// end function
		
		
		public function get camera():Vector3D
		{
			return _camera;
		}

		public function set camera(value:Vector3D):void
		{
			_camera = value;
		}

		override arcane function initVO(vo : MethodVO) : void
		{
			vo.needsGlobalVertexPos = true;
		}
		

		override arcane function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
        {
            //super.activate(vo, stage3DProxy);			
			var index:int = vo.vertexConstantsIndex;
			var data:Vector.<Number> = vo.vertexData;
			data[index] = -_camera.x;
			data[index + 1] = -_camera.y;
			data[index + 2] = -_camera.z;
			data[index + 3] = 20;
			
        }// end function

		
		protected function findTempReg(exclude : Array, excludeAnother : String = null) : String
		{
			var i : uint;
			var reg : String;
			
			while (true) {
				reg = "vt" + i;
				if (exclude.indexOf(reg) == -1 && excludeAnother != reg) return reg;
				++i;
			}
			
			// can't be reached
			return null;
		}
		
		
		public function getVertexCode2(vo : MethodVO, regCache : ShaderRegisterCache, compiler:RibbonShaderCompiler) : String
        {
            var code:String = "";
			
			//FIXME
			_cameraRegister = regCache.getFreeVertexConstant();
			vo.vertexConstantsIndex = _cameraRegister.index*4;//mark vertexConstantsIndex for activate
			var vt1:ShaderRegisterElement = regCache.getFreeVertexVectorTemp();
			regCache.addVertexTempUsages(vt1,1);
			//pointRegister = regCache.getFreeVertexAttribute();
			//compiler.pointIndex = pointRegister.index;
			diffRegister = regCache.getFreeVertexAttribute();
			compiler.diffIndex = diffRegister.index;
			code += "crs " + vt1 + ".xyz, " + diffRegister + ".xyz, " + _cameraRegister + ".xyz\n";//normal
			//code += "nrm " + vt1 + ".xyz, " + vt1 + ".xyz\n";
			code += "mul " + vt1 + ".xyz, " + vt1 + ".xyz, " + _cameraRegister + ".w\n";//scale length
			code += "mul " + vt1 + ".xyz, " + vt1 + ".xyz, " + diffRegister + ".w\n";//+-?
			code += "add vt0.xyz, " + vt1 + ".xyz, vt0.xyz\n";/**/
			regCache.removeVertexTempUsage(vt1);
            return code;
        }// end function


		
		public function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement,targetReg2:ShaderRegisterElement):String
		{				
			var code:String = "";

			return code;
		}
		

// end function

    }
}
