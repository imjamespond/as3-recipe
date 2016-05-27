package com.codechiev.ribbon2
{
    import __AS3__.vec.*;
    import away3d.bounds.*;
    import away3d.core.base.*;
    import away3d.entities.*;
    import flash.geom.*;

    public class Ribbon extends Mesh
    {
        private var _ribbonGeoms:Vector.<RibbonGeometry>;
        private var _currentGeoms:RibbonGeometry;
        public var power:Number = 0;

        public function Ribbon()
        {
			super(null,null);
            init();
            //_bounds = new NullBounds(true);
			bounds.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
        }// end function

        public function set stepProgress(param1:Number) : void
        {
            _currentGeoms.stepProgress = param1;
            return;
        }// end function

        public function setMiplevel(param1:int) : void
        {
            var _loc_2:RibbonGeometry = null;
            for each (_loc_2 in _ribbonGeoms)
            {
                _loc_2.miplevel = param1;
            }
            return;
        }// end function

        public function clearAll() : void
        {
            var subGeom:ISubGeometry = null;
            while (geometry.subGeometries.length > 0)
            {
				subGeom = geometry.subGeometries[0];
                geometry.removeSubGeometry(subGeom);
				subGeom.dispose();
            }
            init();
            return;
        }// end function

        private function init() : void
        {
            _ribbonGeoms = new Vector.<RibbonGeometry>;
            _currentGeoms = new RibbonGeometry();
            geometry.addSubGeometry(_currentGeoms);
            _ribbonGeoms.push(_currentGeoms);
            return;
        }// end function

        override protected function updateBounds() : void
        {
            _boundsInvalid = false;
            return;
        }// end function

        public function addPoint(point:Vector3D) : void
        {
            var lastPos:Vector3D = null;
            if (!_currentGeoms.addPoint(point, power))
            {
                _currentGeoms.complete();
				/*lastPos = _currentGeoms.getLastPosition();
                _currentGeoms = new RibbonGeometry();
                geometry.addSubGeometry(_currentGeoms);
                _ribbonGeoms.push(_currentGeoms);
                if (power > 0)
                {
                    _currentGeoms.addPoint(lastPos, power);
                    _currentGeoms.addPoint(point, power);
                }*/
            }
            return;
        }// end function

        public function get ribbonGeom() : RibbonGeometry
        {
            return _currentGeoms;
        }// end function

    }
}
