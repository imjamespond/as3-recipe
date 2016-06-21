package com.codechiev.ribbon2
{
    import away3d.core.managers.*;
    import away3d.materials.*;
    import away3d.textures.ATFCubeTexture;
    import away3d.textures.ATFData;
    
    import com.codechiev.away3d.ResourcesManager;
    
    import flash.display3D.*;
    import away3d.textures.ATFTexture;

    public class LightPaintMaterial extends MaterialBase
    {
        private var _texture:ATFCubeTexture;
        private var _opening:Number = 0;//affect ribbon width
        private var _dezoom:Number = 0;
        private var _pass:LightPaintPass;
        private var _pass2:LightPaintPass;
        private var _pass3:LightPaintDiffusePass;

        public function LightPaintMaterial()
        {
            clearPasses();
            _pass = new LightPaintPass();
            addPass(_pass);
            _pass2 = new LightPaintPass();
            //addPass(_pass2);
            _pass2.waveScale = -3;
            _pass2.ribbonWidth = 3;
            _pass2.atf = new ATFCubeTexture(ResourcesManager.getResourceBytesArray("hourglass_cubemap.atf"));
            _pass.atf = _pass2.atf;
            _pass3 = new LightPaintDiffusePass();
           	//addPass(_pass3);
            _pass3.atf = new ATFTexture(ResourcesManager.getResourceBytesArray("fire.atf"));
            //culling = Context3DTriangleFace.NONE;
			_pass.bothSides=true;
			_pass2.bothSides=true;
			_pass3.bothSides=true;
            return;
        }// end function

        public function get opening() : Number
        {
            return _opening;
        }// end function

        public function set opening(param1:Number) : void
        {
            _opening = param1;
            _update();
            return;
        }// end function

        public function get dezoom() : Number
        {
            return _dezoom;
        }// end function

        public function set dezoom(param1:Number) : void
        {
            _dezoom = param1;
            _update();
            return;
        }// end function

        private function _update() : void
        {
            var _loc_1:* = 7 * _dezoom + 1;
            var _loc_2:* = 2 * _dezoom + 1;
            var _loc_3:* = 5 * _dezoom + 1;
            _pass2.ribbonWidth = 3 * _opening * _loc_1;
            _pass.ribbonWidth = 9 * _opening * _loc_1;
            _pass3.ribbonWidth = 25 * _opening * _loc_1;
            _pass3.uvmult = 5 / _loc_3;
            _pass2.waveScale = -30 * _loc_2;
            _pass.waveScale = 150 * _loc_2;
            _pass3.waveScale = 1 * _loc_2;
            return;
        }// end function

        override public function get requiresBlending() : Boolean
        {
            return true;
        }// end function

        public function get atf() : ATFData
        {
            return _texture ? (_texture.atfData) : (null);
        }// end function

        public function set atf(param1:ATFData) : void
        {
            _texture = _texture || new ATFCubeTexture(null);
            _texture.atfData = param1;
            return;
        }// end function

        public function get texture() : ATFCubeTexture
        {
            return _texture;
        }// end function

    }
}
