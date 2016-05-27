package com.codechiev.pathanimator
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class TransformAnimationSequence extends AnimationSequenceBase
    {
        public var _frames:Vector.<Matrix3D>;

        public function TransformAnimationSequence(param1:String)
        {
            super(param1);
            this._frames = new Vector.<Matrix3D>;
            fixedFrameRate = false;
            return;
        }// end function

		public function addFrame(param1:Matrix3D, param2:uint) : void
        {
            _totalDuration = _totalDuration + param2;
            this._frames.push(param1);
            _durations.push(param2);
            return;
        }// end function

        public function getFirst() : Matrix3D
        {
            return this._frames[0].clone();
        }// end function

        public function getLast() : Matrix3D
        {
            return this._frames[(this._frames.length - 1)].clone();
        }// end function

        public function getFirstPos() : Vector3D
        {
            return this._frames[0].position.clone();
        }// end function

        public function getLastPos() : Vector3D
        {
            return this._frames[(this._frames.length - 1)].position.clone();
        }// end function

    }
}
