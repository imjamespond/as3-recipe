package com.codechiev.ribbon2
{
    import __AS3__.vec.*;
    
    import away3d.materials.compilation.ShaderRegisterCache;
    import away3d.materials.compilation.ShaderRegisterElement;
    import away3d.materials.methods.*;
    import away3d.materials.passes.*;
    import away3d.materials.utils.*;
    
    import com.codechiev.away3d.utils.AGAL;
    
    import flash.display3D.*;

    public class WallLighteningMethod extends ShadingMethodBase
    {
        var _totalLightColorReg:ShaderRegisterElement;
        protected var _AOInputRegister:ShaderRegisterElement;
        protected var _AOInputIndex:int;
        private var _data:Vector.<Number>;
        private var _dataReg:ShaderRegisterElement;
        private var _min:Number = 0;
        private var _max:Number = 1;
        private var _aerolight:AeroLighteningPass;
        private var name:String;
        private static var _GMin:Number = 0;
        private static var _GMax:Number = 1;

        public function WallLighteningMethod(pass:AeroLighteningPass, param2:String, param3:Boolean = true)
        {
            name = param2;
            _aerolight = pass;
            super(false, false, false);
            _passes = new Vector.<MaterialPassBase>;
            if (param3)
            {
                _passes[0] = new AeroLightFilterPass(pass);
            }
            _data = new Vector.<Number>(4, true);
            return;
        }// end function

        override function set numLights(param1:int) : void
        {
            _needsNormals = param1 > 0;
            super.numLights = param1;
            return;
        }// end function

        override function get needsUV() : Boolean
        {
            return true;
        }// end function

        override function getFragmentPostLightingCode(param1:ShaderRegisterCache, param2:ShaderRegisterElement) : String
        {
            var _loc_4:ShaderRegisterElement = null;
            var code:String = "";
            _loc_4 = param1.getFreeFragmentVectorTemp();
            _AOInputRegister = param1.getFreeTextureReg();
            _AOInputIndex = _AOInputRegister.index;
            _dataReg = param1.getFreeFragmentConstant();
            _smooth = true;
            code = code + getTex2DSampleCode(_loc_4, _AOInputRegister);
            code = code + AGAL.mul(_loc_4 + ".x", _loc_4 + ".x", _dataReg + ".x");
            code = code + AGAL.add(_loc_4 + ".x", _loc_4 + ".x", _dataReg + ".y");
            code = code + AGAL.sat(_loc_4 + ".x", _loc_4 + ".x");
            code = code + AGAL.mul(param2 + ".xyz", _loc_4 + ".x", param2 + ".xyz");
            return code;
        }// end function

        override function activate(param1:Context3D, param2:uint) : void
        {
            param1.setTextureAt(_AOInputIndex, _aerolight.getTexture(param1, param2));
            _updateData();
            param1.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, _dataReg.index, _data);
            return;
        }// end function

        override function deactivate(param1:Context3D) : void
        {
            param1.setTextureAt(_AOInputIndex, null);
            return;
        }// end function

        public function get globalLow() : Number
        {
            return _GMin;
        }// end function

        public function set globalLow(param1:Number) : void
        {
            _GMin = param1;
            return;
        }// end function

        public function get globalHigh() : Number
        {
            return _GMax;
        }// end function

        public function set globalHigh(param1:Number) : void
        {
            _GMax = param1;
            return;
        }// end function

        public function get low() : Number
        {
            return _min;
        }// end function

        public function set low(param1:Number) : void
        {
            _min = param1;
            return;
        }// end function

        public function get high() : Number
        {
            return _max;
        }// end function

        public function set high(param1:Number) : void
        {
            _max = param1;
            return;
        }// end function

        private function _updateData() : void
        {
            var _loc_1:* = Math.max(_GMin, _min);
            var _loc_2:* = _GMax * _max;
            _data[0] = 1 / (_loc_2 - _loc_1);
            _data[1] = (-_loc_1) * _data[0];
            return;
        }// end function

    }
}
