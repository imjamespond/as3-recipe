package com.codechiev.glass
{
    import away3d.materials.*;
    import away3d.materials.methods.*;

    public class CarGlassLtMaterial extends ColorMaterial
    {
        public var ref:EnvMapMethod;
        public var falloffT:FalloffTransparencyMethod;
        public var falloff:FalloffMethod;

        public function CarGlassLtMaterial()
        {
            super(0xffffff, 1);
            //this._build();

			this.falloffT = new FalloffTransparencyMethod();
			this.falloffT.falloffIn = 0;
			this.falloffT.falloffOut = 1;
			this.falloffT.falloffPower = 1;
			addMethod(this.falloffT);
			this.falloff = new FalloffMethod();
			this.falloff.falloffIn = 0;
			this.falloff.falloffOut = 1;
			this.falloff.falloffPower = 3;
			addMethod(this.falloff);
			
        }// end function

        /*protected function _build() : void
        {
            var _loc_1:* = TexturesResources.getResource("studio_ref_dark");
            this.ref = new EnvMapMethod(_loc_1);
            addMethod(this.ref);
            return;
        }// end function*/

    }
}
