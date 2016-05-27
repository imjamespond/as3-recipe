package com.codechiev.ribbon2
{
    import away3d.cameras.*;
    import away3d.cameras.lenses.*;
    import flash.geom.*;

    public class OrthConfig extends Object
    {
        private var _cam:Camera3D;
        private var _orthlens:OrthographicOffCenterLens;
        private var _campos:Vector3D;

        public function OrthConfig()
        {
            this._cam = new Camera3D();
            var _loc_1:* = new OrthographicOffCenterLens(-500, 500, -250, 250);
            this._orthlens = new OrthographicOffCenterLens(-500, 500, -250, 250);
            this._cam.lens = _loc_1;
            this._orthlens.far = 10000;
            this._campos = new Vector3D();
            return;
        }// end function

        public function get cam() : Camera3D
        {
            return this._cam;
        }// end function

        public function get orthlens() : OrthographicOffCenterLens
        {
            return this._orthlens;
        }// end function

        public function get campos() : Vector3D
        {
            return this._campos;
        }// end function

    }
}
