package com.codechiev.steadycam
{
    import away3d.cameras.lenses.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import com.codechiev.juke.Cursors;

    public class InteriorCamHelper extends Object
    {
        private var cam:SteadyCam;
        private var stage:Stage;
        private var _down:Boolean;
        private var downPosition:Point;
        private var m1:Matrix3D;
        private var m2:Matrix3D;
        private var _hAngle:Number;
        private var _vAngle:Number;
        private var _dist:Number;
        private var _nhAngle:Number;
        private var _nvAngle:Number;
        private static const UP:Vector3D = new Vector3D(0, 1, 0);
        private static const Z:Vector3D = new Vector3D(0, 0, 1);

        public function InteriorCamHelper(param1:SteadyCam, param2:Stage)
        {
            this.downPosition = new Point();
            this.stage = param2;
            this.cam = param1;
            this._build();
            return;
        }// end function

        public function reset() : void
        {
            this._grabMeasures();
            return;
        }// end function

        public function activate(param1:Boolean) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            if (param1)
            {
                this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.checkCursor);
                this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.wheel);
                this.stage.addEventListener(MouseEvent.MOUSE_DOWN, this.down);
            }
            else
            {
                this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.checkCursor);
                this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.wheel);
                this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.down);
                this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.move);
                this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.up);
                _loc_2 = PerspectiveLens(this.cam.lens).fieldOfView;
                if (_loc_2 != 60)
                {
                    _loc_3 = Math.abs(_loc_2 - 60) / 30;
                    Tweener.addTween(this.cam.lens, {fieldOfView:60, time:_loc_3, transition:Equations.easeInOutQuad});
                }
            }
            return;
        }// end function

        public function step() : void
        {
            var _loc_1:* = new Vector3D(1, 0, 0);
            this.m2 = new Matrix3D();
            this.m2.appendRotation(this._nvAngle / Math.PI * 180, Z);
            _loc_1 = this.m2.transformVector(_loc_1);
            this.m1 = new Matrix3D();
            this.m1.appendScale(this._dist, this._dist, this._dist);
            this.m1.appendRotation(this._nhAngle / Math.PI * 180, UP);
            _loc_1 = this.m1.transformVector(_loc_1);
            this.cam.positionOffset = _loc_1;
            return;
        }// end function

        private function _build() : void
        {
            this._grabMeasures();
            return;
        }// end function

        private function wheel(event:MouseEvent) : void
        {
            var _loc_2:* = PerspectiveLens(this.cam.lens).fieldOfView;
            _loc_2 = _loc_2 - event.delta * 0.5;
            PerspectiveLens(this.cam.lens).fieldOfView = Math.max(Math.min(_loc_2, 80), 38);
            return;
        }// end function

        private function _grabMeasures() : void
        {
            var _loc_1:* = this.cam.positionOffset;
            var _loc_2:* = Math.sqrt(_loc_1.x * _loc_1.x + _loc_1.z * _loc_1.z);
            var _loc_3:* = Math.atan2(-_loc_1.z, _loc_1.x);
            this._nhAngle = Math.atan2(-_loc_1.z, _loc_1.x);
            this._hAngle = _loc_3;
            _loc_3 = Math.atan2(_loc_1.y, _loc_2);
            this._nvAngle = Math.atan2(_loc_1.y, _loc_2);
            this._vAngle = _loc_3;
            this._dist = Math.sqrt(_loc_2 * _loc_2 + _loc_1.y * _loc_1.y);
            return;
        }// end function

        private function down(event:MouseEvent) : void
        {
            this._down = true;
            Mouse.cursor = Cursors.CLOSED_HAND;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.move);
            this.stage.addEventListener(MouseEvent.MOUSE_UP, this.up);
            this.downPosition.x = this.stage.mouseX;
            this.downPosition.y = this.stage.mouseY;
            return;
        }// end function

        private function up(event:MouseEvent) : void
        {
            this._down = false;
            Mouse.cursor = Cursors.OPEN_HAND;
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.move);
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.up);
            this._grabMeasures();
            return;
        }// end function

        private function checkCursor(event:MouseEvent) : void
        {
            if (event.target == this.stage && !this._down)
            {
                Mouse.cursor = Cursors.OPEN_HAND;
            }
            else if (event.target != this.stage)
            {
                Mouse.cursor = MouseCursor.AUTO;
            }
            return;
        }// end function

        private function move(event:MouseEvent) : void
        {
            var _loc_2:* = this.stage.mouseX - this.downPosition.x;
            this._nhAngle = this._hAngle - _loc_2 * 0.0018;
            var _loc_3:* = this.stage.mouseY - this.downPosition.y;
            this._nvAngle = this._vAngle - _loc_3 * 0.0018;
            return;
        }// end function

    }
}
