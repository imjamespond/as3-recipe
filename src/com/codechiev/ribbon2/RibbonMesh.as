package com.codechiev.ribbon2
{
    import away3d.bounds.*;
    import away3d.core.base.*;
    import away3d.entities.*;
    import away3d.events.*;
    import away3d.materials.*;

    public class RibbonMesh extends Mesh
    {
        public var decay:Number = 0.0035;

        public function RibbonMesh(mtl:MaterialBase = null, geom:Geometry = null)
        {
            super(geom, mtl);
            _bounds = new NullBounds(true);
            return;
        }// end function

        public function step(param1:Number) : void
        {
            var _loc_2:AeroSubmesh = null;
            for each (_loc_2 in subMeshes)
            {
                _loc_2.step(param1);
            }
            return;
        }// end function

        override protected function updateBounds() : void
        {
            return;
        }// end function

        protected function addSubMesh(param1:SubGeometry) : void
        {
            var _loc_2:* = new AeroSubmesh(param1 as RibbonGeometry, this, null);
            var _loc_3:* = subMeshes.length;
            _loc_2.decay = this.decay;
            _loc_2._index = _loc_3;
			subMeshes[_loc_3] = _loc_2;
            return;
        }// end function

        /*public function removeSubmesh(param1:AeroSubmesh) : void
        {
            var _loc_2:* = subMeshes.indexOf(param1);
            if (_loc_2 < 0)
            {
                return;
            }
			subMeshes.splice(_loc_2, 1);
            var _loc_3:* = subMeshes.length;
            var _loc_4:* = _loc_2;
            while (_loc_4 < _loc_3)
            {
				subMeshes[_loc_4]._index = _loc_4;
                _loc_4++;
            }
            return;
        }// end function*/

        protected function onSubGeometryRemoved(event:GeometryEvent) : void
        {
            return;
        }// end function

    }
}
