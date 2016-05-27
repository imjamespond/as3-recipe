package com.codechiev.away3d.material
{
    import __AS3__.vec.*;
    
    import away3d.core.managers.*;
    import away3d.materials.utils.*;
    import away3d.tools.atf.*;
    
    import com.codechiev.away3d.utils.AGAL;
    
    import flash.display3D.*;
    import away3d.materials.compilation.ShaderRegisterCache;
    import away3d.materials.compilation.ShaderRegisterElement;
    import away3d.materials.methods.ShadingMethodBase;

    public class ReflexionMethod extends ShadingMethodBase
    {
        private var _cubeTexture:CubeTexture3DProxy;
        private var _cubeMapIndex:int;
        private var _data:Vector.<Number>;
        private var _dataIndex:int;
        private var _fin:Number;
        private var _fout:Number;
        public var alphaAddition:Boolean;

        public function ReflexionMethod(param1)
        {
            super(true, true, false);
            this._cubeTexture = new CubeTexture3DProxy();
            if (param1 is CubeMap)
            {
                this._cubeTexture.cubeMap = param1;
            }
            else if (param1 is ATFFile)
            {
                this._cubeTexture.compressedTexture = param1;
            }
            this._data = new Vector.<Number>(4, true);
            this.falloffIn = 0;
            this.falloffOut = 1;
            this.falloffPower = 2;
            this._data[3] = 0.33;
            return;
        }// end function

        public function get envMap() : ATFFile
        {
            return this._cubeTexture.compressedTexture;
        }// end function

        public function set envMap(param1:ATFFile) : void
        {
            this._cubeTexture.compressedTexture = param1;
            return;
        }// end function

        override public function dispose(param1:Boolean) : void
        {
            this._cubeTexture.dispose(param1);
            return;
        }// end function

        public function get falloffIn() : Number
        {
            return this._fin;
        }// end function

        public function set falloffIn(param1:Number) : void
        {
            this._fin = param1;
            this._computeFalloff();
            return;
        }// end function

        public function get falloffOut() : Number
        {
            return this._fout;
        }// end function

        public function set falloffOut(param1:Number) : void
        {
            this._fout = param1;
            this._computeFalloff();
            return;
        }// end function

        public function get falloffPower() : Number
        {
            return this._data[2];
        }// end function

        public function set falloffPower(param1:Number) : void
        {
            this._data[2] = param1;
            return;
        }// end function

        public function get alphaAdding() : Number
        {
            return this._data[3];
        }// end function

        public function set alphaAdding(param1:Number) : void
        {
            this._data[3] = param1;
            return;
        }// end function

        private function _computeFalloff() : void
        {
            this._data[0] = this._fout - this._fin;
            this._data[1] = this._fin;
            this._data[0] = -this._data[0];
            return;
        }// end function

        override function activate(param1:Context3D, param2:uint) : void
        {
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, this._dataIndex, this._data, 1);
            param1.setTextureAt(this._cubeMapIndex, this._cubeTexture.getTextureForContext(param1, param2));
            return;
        }// end function

        override function deactivate(param1:Context3D) : void
        {
            param1.setTextureAt(this._cubeMapIndex, null);
            return;
        }// end function

        override function getFragmentPostLightingCode(param1:ShaderRegisterCache, param2:ShaderRegisterElement) : String
        {
            var _loc_8:String = null;
            var _loc_3:* = param1.getFreeFragmentConstant();
            var _loc_4:* = param1.getFreeFragmentVectorTemp();
            param1.addFragmentTempUsages(_loc_4, 1);
            var _loc_5:* = param1.getFreeFragmentVectorTemp();
            var _loc_6:String = "";
            var _loc_7:* = param1.getFreeTextureReg();
            this._cubeMapIndex = _loc_7.index;
            this._dataIndex = _loc_3.index;
            _loc_6 = _loc_6 + AGAL.dp3(_loc_4 + ".w", _viewDirFragmentReg + ".xyz", _normalFragmentReg + ".xyz");
            _loc_6 = _loc_6 + AGAL.sat(_loc_5 + ".w", _loc_4 + ".w");
            _loc_6 = _loc_6 + AGAL.mul(_loc_5 + ".w", _loc_5 + ".w", _loc_3 + ".x");
            _loc_6 = _loc_6 + AGAL.sub(_loc_5 + ".w", _loc_5 + ".w", _loc_3 + ".x");
            _loc_6 = _loc_6 + AGAL.pow(_loc_5 + ".w", _loc_5 + ".w", _loc_3 + ".z");
            _loc_6 = _loc_6 + AGAL.add(_loc_5 + ".w", _loc_5 + ".w", _loc_3 + ".y");
            _loc_6 = _loc_6 + AGAL.add(_loc_4 + ".w", _loc_4 + ".w", _loc_4 + ".w");
            _loc_6 = _loc_6 + AGAL.mul(_loc_4 + ".xyz", _normalFragmentReg + ".xyz", _loc_4 + ".w");
            _loc_6 = _loc_6 + AGAL.sub(_loc_4 + ".xyz", _viewDirFragmentReg + ".xyz", _loc_4 + ".xyz");
            _loc_6 = _loc_6 + AGAL.neg(_loc_4 + ".xyz", _loc_4 + ".xyz");
            if (this._cubeTexture.compressedTexture.count > 1)
            {
                _loc_8 = _smooth ? ("trilinear") : ("nearestMip");
            }
            else
            {
                _loc_8 = _smooth ? ("bilinear") : ("nearestNoMip");
            }
            _loc_6 = _loc_6 + AGAL.sample(_loc_4.toString(), _loc_4.toString(), "cube", _loc_7.toString(), _smooth ? ("bilinear") : ("nearestNoMip"), "clamp");
            _loc_6 = _loc_6 + AGAL.mul(_loc_4 + ".xyz", _loc_4 + ".xyz", _loc_5 + ".w");
            _loc_6 = _loc_6 + AGAL.add(param2 + ".xyz", param2 + ".xyz", _loc_4 + ".xyz");
            if (this.alphaAddition)
            {
                _loc_6 = _loc_6 + AGAL.add(_loc_4 + ".x", _loc_4 + ".x", _loc_4 + ".y");
                _loc_6 = _loc_6 + AGAL.add(_loc_4 + ".x", _loc_4 + ".x", _loc_4 + ".z");
                _loc_6 = _loc_6 + AGAL.mul(_loc_4 + ".x", _loc_4 + ".x", _loc_3 + ".w");
                _loc_6 = _loc_6 + AGAL.add(param2 + ".w", param2 + ".w", _loc_4 + ".x");
            }
            param1.removeFragmentTempUsage(_loc_4);
            return _loc_6;
        }// end function

    }
}
