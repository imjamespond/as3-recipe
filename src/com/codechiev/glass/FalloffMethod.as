package com.codechiev.glass
{
    import __AS3__.vec.*;
    
    import away3d.arcane;
    import away3d.core.managers.Stage3DProxy;
    import away3d.materials.compilation.ShaderRegisterCache;
    import away3d.materials.compilation.ShaderRegisterElement;
    import away3d.materials.methods.EffectMethodBase;
    import away3d.materials.methods.MethodVO;
    import away3d.materials.utils.*;
    
    import com.codechiev.away3d.utils.AGAL;
    
    import flash.display3D.*;

	use namespace arcane;
	
    public class FalloffMethod extends EffectMethodBase
    {
        private var _data:Vector.<Number>;
        private var _dataIndex:int;
        private var _fin:Number;
        private var _fout:Number;
        private var _backFace:Boolean;

        public function FalloffMethod(param1:Boolean = false)
        {
            //super(true, true, false);
            this._data = new Vector.<Number>(4, true);
            this._backFace = param1;
            this.falloffIn = 0;
            this.falloffOut = 1;
            this.falloffPower = 2;
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

        private function _computeFalloff() : void
        {
            this._data[0] = this._fout - this._fin;
            this._data[1] = this._fin;
            return;
        }// end function
		
		/**
		 * @inheritDoc
		 */
		override arcane function initVO(vo:MethodVO):void
		{
			vo.needsNormals = true;
			vo.needsView = true;
		}

		arcane override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy): void
        {
			stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, this._dataIndex, this._data, 1);
            return;
        }// end function

		arcane override function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String
        {
            var _loc_3:* = regCache.getFreeFragmentConstant();
            var _loc_4:* = regCache.getFreeFragmentVectorTemp();
            var _loc_5:String = "";
            this._dataIndex = _loc_3.index;
            _loc_5 = _loc_5 + AGAL.dp3(_loc_4 + ".x", _sharedRegisters.viewDirFragment + ".xyz", _sharedRegisters.normalFragment + ".xyz");
            if (!this._backFace)
            {
                _loc_5 = _loc_5 + AGAL.sat(_loc_4 + ".x", _loc_4 + ".x");
            }
            else
            {
                _loc_5 = _loc_5 + AGAL.neg(_loc_4 + ".x", _loc_4 + ".x");
            }
            _loc_5 = _loc_5 + AGAL.mul(_loc_4 + ".x", _loc_4 + ".x", _loc_3 + ".x");
            _loc_5 = _loc_5 + AGAL.add(_loc_4 + ".x", _loc_4 + ".x", _loc_3 + ".y");
            if (this._data[2] != 1)
            {
                _loc_5 = _loc_5 + AGAL.pow(_loc_4 + ".x", _loc_4 + ".x", _loc_3 + ".z");
            }
            _loc_5 = _loc_5 + AGAL.mul(targetReg + ".xyz", targetReg + ".xyz", _loc_4 + ".x");
            return _loc_5;
        }// end function

    }
}
