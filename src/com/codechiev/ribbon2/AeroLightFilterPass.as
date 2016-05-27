package com.codechiev.ribbon2
{
    import away3d.cameras.*;
    import away3d.core.base.*;
    import away3d.materials.passes.*;
    import flash.display3D.*;

    public class AeroLightFilterPass extends MaterialPassBase
    {
        private var _aerolight:AeroLighteningPass;

        public function AeroLightFilterPass(param1:AeroLighteningPass)
        {
            this._aerolight = param1;
            return;
        }// end function

        override function activate(param1:Context3D, param2:uint, param3:Camera3D) : void
        {
            return;
        }// end function

        override function render(param1:IRenderable, param2:Context3D, param3:uint, param4:Camera3D) : void
        {
            this._aerolight.renderFilter(param2, param3, param4);
            return;
        }// end function

        override function deactivate(param1:Context3D) : void
        {
            return;
        }// end function

    }
}
