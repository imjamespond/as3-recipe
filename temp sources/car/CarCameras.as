package com.codechiev.car
{
    import __AS3__.vec.*;
    import away3d.animators.data.*;
    import away3d.containers.*;
    import flash.utils.*;
    import com.codechiev.pathanimator.TransformAnimationSequence;

    public class CarCameras extends Object
    {
        private var _camGroup:ObjectContainer3D;
        private var _vcAnims:Vector.<TransformAnimationSequence>;
        private var _vtAnims:Vector.<TransformAnimationSequence>;
        private var _dcAnims:Dictionary;
        private var _dtAnims:Dictionary;

        public function CarCameras(param1:ObjectContainer3D)
        {
            this._camGroup = param1;
            this._extract();
            return;
        }// end function

        public function getCameraSequence(param1:String) : TransformAnimationSequence
        {
            return this._dcAnims[param1];
        }// end function

        public function getTargetSequence(param1:String) : TransformAnimationSequence
        {
            return this._dtAnims[param1];
        }// end function

        public function getCamSequences() : Vector.<TransformAnimationSequence>
        {
            return this._vcAnims;
        }// end function

        public function getTgtSequences() : Vector.<TransformAnimationSequence>
        {
            return this._vtAnims;
        }// end function

        private function _extract() : void
        {
            var _loc_2:ObjectContainer3D = null;
            var _loc_3:ObjectContainer3D = null;
            var _loc_4:TransformAnimationSequence = null;
            var _loc_5:String = null;
            var _loc_1:* = this._camGroup.numChildren / 2;
            this._dcAnims = new Dictionary();
            this._dtAnims = new Dictionary();
            this._vcAnims = new Vector.<TransformAnimationSequence>(_loc_1, true);
            this._vtAnims = new Vector.<TransformAnimationSequence>(_loc_1, true);
            var _loc_6:int = 0;
            while (_loc_6 < _loc_1)
            {
                
                _loc_2 = this._camGroup.getChildAt(_loc_6 * 2);
                _loc_3 = this._camGroup.getChildAt(_loc_6 * 2 + 1);
                _loc_4 = _loc_2.extra.animation3DS;
                _loc_4.looping = false;
                if (_loc_4 == null)
                {
                    throw new Error("fr.digitas.jexplorer.d3.object.CarCameras - _extract : no anim");
                }
                _loc_5 = _loc_4.name;
                _loc_3.extra.animation3DS.name = _loc_5;
                _loc_3.extra.animation3DS.looping = false;
                this._dcAnims[_loc_5] = _loc_4;
                this._dtAnims[_loc_5] = _loc_3.extra.animation3DS;
                this._vcAnims[_loc_6] = _loc_4;
                this._vtAnims[_loc_6] = _loc_3.extra.animation3DS;
                _loc_6++;
            }
            return;
        }// end function

    }
}
