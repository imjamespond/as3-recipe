package com.codechiev.away3d.material
{
    import away3d.materials.*;
    import away3d.materials.methods.*;
    import fr.digitas.jexplorer.resources.*;

    public class CarAluMaterial extends ColorMaterial
    {
        public var ref:ReflexionMethod;

        public function CarAluMaterial()
        {
            super(3223857, 1);
            var _loc_1:Boolean = true;
            smooth = true;
            mipmap = _loc_1;
            this._build();
            return;
        }// end function

        protected function _build() : void
        {
            this.ref = new ReflexionMethod(TexturesResources.getResource("studio_diff"));
            this.ref.falloffIn = 0.6;
            this.ref.falloffOut = 1;
            this.ref.falloffPower = 1.53;
            addMethod(this.ref);
            return;
        }// end function

    }
}
