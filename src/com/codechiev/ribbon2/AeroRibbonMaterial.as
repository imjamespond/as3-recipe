package com.codechiev.ribbon2
{
    import __AS3__.vec.*;
    
    import away3d.core.managers.*;
    import away3d.materials.*;
    import away3d.textures.ATFCubeTexture;
    
    import com.codechiev.away3d.ResourcesManager;
    import com.codechiev.ribbon2.*;
    
    import flash.display3D.*;
    import away3d.textures.ATFTexture;

    public class AeroRibbonMaterial extends MaterialBase
    {
        private var _texture:ATFCubeTexture;
        private var _opening:Number = 0;
        private var _dezoom:Number = 0;
        private var _pass:AeroPass;

        public function AeroRibbonMaterial(param1:Vector.<AeroLighteningPass> = null)
        {
            var _loc_2:AeroLighteningPass = null;
            clearPasses();
            if (param1)
            {
                for each (_loc_2 in param1)
                {
                    
                    _loc_2.ribbonWidth = 25;
                    addPass(_loc_2);
                }
            }
            var _loc_3:* = new AeroPass();
            this._pass = new AeroPass();
            addPass(_loc_3);
            this._pass.ribbonWidth = 25;
            this._pass.uvmult = 160;
            this._pass.atf = new ATFTexture(ResourcesManager.getResourceBytesArray("hourglass_cubemap.atf"));
            //culling = Context3DTriangleFace.NONE;
            return;
        }// end function

        public function get xplane() : Number
        {
            return this._pass.xplane;
        }// end function

        public function set xplane(param1:Number) : void
        {
            this._pass.xplane = param1;
            return;
        }// end function

        public function get opening() : Number
        {
            return this._opening;
        }// end function

        public function set opening(param1:Number) : void
        {
            this._opening = param1;
            this._update();
            return;
        }// end function

        public function get dezoom() : Number
        {
            return this._dezoom;
        }// end function

        public function set dezoom(param1:Number) : void
        {
            this._dezoom = param1;
            this._update();
            return;
        }// end function

        private function _update() : void
        {
            return;
        }// end function

        override public function get requiresBlending() : Boolean
        {
            return true;
        }// end function

        public function get atf() : ATFCubeTexture
        {
			return this._texture;
        }// end function

        public function set atf(param1:ATFCubeTexture) : void
        {
            //this._texture = this._texture || new CubeTexture3DProxy();
			_texture = param1;      
        }// end function

        public function get texture() : ATFCubeTexture
        {
            return this._texture;
        }// end function

    }
}
