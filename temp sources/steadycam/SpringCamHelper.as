package com.codechiev.steadycam
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import com.codechiev.juke.Cursors;

    public class SpringCamHelper extends Object
    {
        private var cam:SteadyCam;
        private var stage:Stage;
        public var azMin:Number = 0.033;
        public var azMax:Number = 1.4;
        private var _down:Boolean;
        private var _lastWheel:int = -1;
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

        public function SpringCamHelper(param1:SteadyCam, param2:Stage)
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
            }
            Mouse.cursor = param1 ? (Cursors.OPEN_HAND) : (MouseCursor.AUTO);
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
            this._dist = this._dist - event.delta * 10;
            this._dist = Math.max(Math.min(this._dist, 2000), 200);
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

        private function _applyMeasures(param1:Number, param2:Number, param3:Number) : void
        {
            return;
        }// end function

        private function down(event:MouseEvent) : void
        {
            this._down = true;
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.move);
            this.stage.addEventListener(MouseEvent.MOUSE_UP, this.up);
            this.downPosition.x = this.stage.mouseX;
            this.downPosition.y = this.stage.mouseY;
            Mouse.cursor = Cursors.CLOSED_HAND;
            return;
        }// end function

        private function up(event:MouseEvent) : void
        {
            this._down = false;
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.move);
            this.stage.removeEventListener(MouseEvent.MOUSE_UP, this.up);
            this._grabMeasures();
            Mouse.cursor = Cursors.OPEN_HAND;
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
            this._nhAngle = this._hAngle + _loc_2 * 0.01;
            var _loc_3:* = this.stage.mouseY - this.downPosition.y;
            this._nvAngle = Math.min(this.azMax, Math.max(this.azMin, this._vAngle + _loc_3 * 0.01));
            return;
        }// end function

    }
}
