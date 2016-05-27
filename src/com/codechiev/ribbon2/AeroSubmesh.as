package com.codechiev.ribbon2
{
    import away3d.core.base.*;
    import away3d.entities.*;
    import away3d.materials.*;
	import away3d.arcane;
	use namespace arcane;
	
    public class AeroSubmesh extends SubMesh
    {
        public var decay:Number = 0.0035;
        private var _planeX:Number = 700;

        public function AeroSubmesh(param1:RibbonGeometry, param2:Mesh, param3:MaterialBase = null)
        {
            super(param1, param2, param3);
            return;
        }// end function

        private function remove() : void
        {
            //(parentMesh as RibbonMesh).removeSubmesh(this);
            return;
        }// end function

        public function get planeX() : Number
        {
            return this._planeX;
        }// end function

        public function set planeX(param1:Number) : void
        {
            this._planeX = param1;
            return;
        }// end function

        public function step(param1:Number = 26) : void
        {
            this._planeX = this._planeX - param1;
            if (this._planeX < -700)
            {
                this.remove();
            }
            return;
        }// end function

    }
}
