package fr.digitas.jexplorer.d3.materials
{
    import away3d.materials.methods.*;
    import fr.digitas.jexplorer.resources.*;
    import com.codechiev.away3d.material.CarAluMaterial;

    public class CarAlloy1Material extends CarAluMaterial
    {
        public var aoMethod:AmbientOcclusionMapMethod;

        public function CarAlloy1Material()
        {
            return;
        }// end function

        override protected function _build() : void
        {
            super._build();
            this.aoMethod = new AmbientOcclusionMapMethod();
            this.aoMethod.compressedTexture = TexturesResources.getResource("alloy1AO");
            addMethod(this.aoMethod);
            return;
        }// end function

    }
}
