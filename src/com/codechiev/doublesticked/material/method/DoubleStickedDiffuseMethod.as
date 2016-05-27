package com.codechiev.doublesticked.material.method
{

  
    import away3d.arcane;
    import away3d.core.managers.Stage3DProxy;
    import away3d.materials.compilation.*;
    import away3d.materials.methods.*;
    import away3d.materials.utils.*;
    import away3d.textures.Texture2DBase;
    
    import com.codechiev.away3d.utils.AGAL;
    
    import flash.display3D.*;
    import flash.geom.*;
	
	use namespace arcane;

    public class DoubleStickedDiffuseMethod extends ShadingMethodBase
    {
        private var _progress:Number;
        private var _radius:Number;
        private var _center:Vector3D;
        private var _color1:uint;
        private var _color2:uint;
        private var _distanceRegister:ShaderRegisterElement;
        private var _distanceRegisterIndex:int;
        private var _color1Register:ShaderRegisterElement;
        private var _color2Register:ShaderRegisterElement;
        private var _vdataRegister:ShaderRegisterElement;
        private var _centerRegister:ShaderRegisterElement;
        private var _colorRegisterIndex:int;

        private var _vdata:Vector.<Number>;
		private var _colordata:Vector.<Number>;
		private var _data:Vector.<Number>;
	
	

        public function DoubleStickedDiffuseMethod()
        {		
			
            this._colordata = new Vector.<Number>(8, true);
            this._vdata = new Vector.<Number>(4, true);
            this._data = new Vector.<Number>(4, true);
            this.progress = 0.5;
            //this.radius = 1000;
            this.color1 = 13631488;
            this.color2 = 65280;
            this.center = new Vector3D(0, 0, 50);
            this._vdata[0] = 1;//影响法向强度,
            this._vdata[1] = 1;
            this._vdata[2] = 0.94;//影响范围,有rcp越大,范围收小
			
            this._colordata[uint(3)] = 0.05;
            return;
        }// end function
		
		
		override arcane function initVO(vo : MethodVO) : void
		{
			vo.needsGlobalVertexPos = true;
		}
		

        public function get progress() : Number
        {
            return this._progress;
        }// end function

        public function set progress(param1:Number) : void
        {
            this._progress = param1;
            //this._data[uint(3)] = this._progress * this._radius;
            this.invalidate();
            return;
        }// end function

        public function get radius() : Number
        {
            return this._radius;
        }// end function

        public function set radius(param1:Number) : void
        {
            this._radius = param1;
            this._vdata[uint(3)] =  this._radius;
            this.invalidate();
            return;
        }// end function

        public function get center() : Vector3D
        {
            return this._center;
        }// end function

        public function set center(param1:Vector3D) : void
        {
            this._center = param1;
            this._data[uint(0)] = this._center.x;
            this._data[uint(1)] = this._center.y;
            this._data[uint(2)] = this._center.z;
            this.invalidate();
            return;
        }// end function

        public function get color1() : uint
        {
            return this._color1;
        }// end function

        public function set color1(param1:uint) : void
        {
            this._color1 = param1;
            this._colordata[uint(0)] = (param1 >> 16 & 255) / 255;
            this._colordata[uint(1)] = (param1 >> 8 & 255) / 255;
            this._colordata[uint(2)] = (param1 & 255) / 255;
            this.invalidate();
            return;
        }// end function

        public function get color2() : uint
        {
            return this._color2;
        }// end function

        public function set color2(param1:uint) : void
        {
            this._color2 = param1;
            this._colordata[uint(4)] = (param1 >> 16 & 255) / 255;
            this._colordata[uint(5)] = (param1 >> 8 & 255) / 255;
            this._colordata[uint(6)] = (param1 & 255) / 255;
            this._colordata[uint(7)] = 1;
            this.invalidate();
            return;
        }// end function

        public function invalidate() : void
        {
            return;
        }// end function

		override arcane function activate(vo : MethodVO, stage3DProxy : Stage3DProxy) : void
        {
            //super.activate(vo, stage3DProxy);
						
			var index:int = vo.vertexConstantsIndex;
			var data:Vector.<Number> = vo.vertexData;
			data[index] = _vdata[0];
			data[index + 1] = _data[1];
			data[index + 2] = _data[2];
			data[index + 3] = _data[3];
			
			data[index + 4] = _vdata[0];
			data[index + 5] = _vdata[1];
			data[index + 6] = _vdata[2];
			data[index + 7] = _vdata[3];
            return;
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
		
		
		override arcane function getVertexCode(vo : MethodVO, regCache : ShaderRegisterCache) : String
        {
			this._centerRegister = regCache.getFreeVertexConstant();
			vo.vertexConstantsIndex = _centerRegister.index*4;
			this._vdataRegister = regCache.getFreeVertexConstant();


            var vt1:ShaderRegisterElement = regCache.getFreeVertexVectorTemp();
			regCache.addVertexTempUsages(vt1,1);
			var vt2:ShaderRegisterElement = regCache.getFreeVertexVectorTemp();
            var code:String = "";
		
			code = code + AGAL.sub(vt1 + ".xyz", _sharedRegisters.localPosition + ".xyz", this._centerRegister + ".xyz");
			code = code + AGAL.dp3(vt1 + ".w", vt1 + ".xyz", vt1 + ".xyz");
			code = code + AGAL.sqrt(vt1 + ".w", vt1 + ".w");//计算顶点到中心点距离
			
			code = code + AGAL.sub(vt1 + ".w", vt1 + ".w", _vdataRegister + ".w");//radius是随时间变化量 顶点到中心点距离 - 应该是作用半径
			code = code + AGAL.mov(this._distanceRegister + ".xyzw", vt1 + ".w");
			code = code + AGAL.abs(vt1 + ".w", vt1 + ".w");
			code = code + AGAL.mul(vt1 + ".w", vt1 + ".w", _vdataRegister + ".z");//0.04
			code = code + AGAL.mul(vt1 + ".w", vt1 + ".w", vt1 + ".w");
			code = code + AGAL.add(vt1 + ".w", vt1 + ".w", _vdataRegister + ".y");//1
			code = code + AGAL.rcp(vt1 + ".w", vt1 + ".w");
			//code = code + AGAL.mov("vt0", "va2");//估计是顶点法线
			code = code + AGAL.mul(vt2+".xyz", _sharedRegisters.animatedNormal +".xyz", _vdataRegister+ ".x");
			code = code + AGAL.mul(vt2+".xyz", vt2+".xyz", vt1 + ".w");

			code = code + AGAL.add(_sharedRegisters.localPosition + ".xyz", _sharedRegisters.localPosition+".xyz", vt2+".xyz");//顶点加上法向增量
			code = code + AGAL.mov(_sharedRegisters.localPosition + ".w", _vdataRegister+ ".y");//0?
			//_loc_3 = _loc_3 + AGAL.m44(_loc_2.toString(), _loc_2.toString(), "vc0");//坐标系变换
			//_loc_3 = _loc_3 + AGAL.mov("op", _loc_2.toString());

			regCache.removeVertexTempUsage(vt1);
			regCache.removeVertexTempUsage(_sharedRegisters.animatedNormal);
            return code;
        }// end function

        public function getDistanceRegister( regCache:ShaderRegisterCache) : ShaderRegisterElement
        {
			
			this._distanceRegister = regCache.getFreeVarying();//invoke before getVertext
			this._distanceRegisterIndex = this._distanceRegister.index;
	
            return this._distanceRegister;
        }
		
		public function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement,targetReg2:ShaderRegisterElement):String
		{				
			var code:String = "";
			var t2:ShaderRegisterElement = null;
			
			t2 = regCache.getFreeFragmentVectorTemp();
			regCache.addFragmentTempUsages(t2, 1);
			
			code = code + AGAL.mul(targetReg + ".w", this._distanceRegister + ".x", targetReg + ".w");
			code = code + AGAL.sat(targetReg + ".w", targetReg + ".w");	
			code = code + AGAL.mul(t2 + ".xyz", targetReg + ".xyz", targetReg + ".w");//计算第一张图 受 半径影响		
			code = code + AGAL.sub(targetReg + ".xyz", targetReg + ".xyz", t2 + ".xyz");//计算第一张图影响值
			
			code = code + AGAL.mul(t2 + ".xyz", targetReg2 + ".xyz", targetReg + ".w");//计算第二张图 受 第一张图影响	
			code = code + AGAL.add(targetReg + ".xyz", targetReg + ".xyz", t2 + ".xyz");
			code = code + AGAL.mov(targetReg + ".w", targetReg2+ ".w");
			
			regCache.removeFragmentTempUsage(t2);
			regCache.removeFragmentTempUsage(targetReg2);	
			return code;
		}
		

// end function

    }
}
