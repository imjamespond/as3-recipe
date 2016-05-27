package com.codechiev.pathanimator
{
    import away3d.animators.*;
    import away3d.animators.utils.*;
    import away3d.core.base.*;
    
    import flash.geom.*;

    public class TransformAnimator extends AnimatorBase
    {
        private var _sequences:Array;
        private var _activeSequence:TransformAnimationSequence;
        //private var _absoluteTime:Number;
        private var _target:Object3D;
        private var _tlUtil:TimelineUtil;
        private var _revert:Boolean = false;
        public var additionalTransform:Matrix3D;

        public function TransformAnimator(obj:Object3D)
        {
			super(new AnimationSetBase());
            this._sequences = [];
            this._target = obj;
            this._tlUtil = new TimelineUtil();
            return;
        }// end function

        public function play(param1:String, param2:Boolean = false) : void
        {
            this._activeSequence = this._sequences[param1];
            if (!this._activeSequence)
            {
                throw new Error("Clip not found! : " + param1);
            }
            this._revert = param2;
            this.reset2();
            start();
            if (param2)
            {
                this.updateAnimation(0, 0.1);
            }
            else
            {
                this.updateAnimation(0, 0);
            }
            return;
        }// end function

        /**/
		private function reset2() : void
        {
            this._absoluteTime = this._revert ? (this._activeSequence.duration) : (0);
        }// end function

        public function addSequence(param1:TransformAnimationSequence) : void
        {
            this._sequences[param1.name] = param1;
        }// end function

        /*override*/ protected function updateAnimation(param1:Number, param2:Number) : void
        {
            this._absoluteTime = this._absoluteTime + (this._revert ? (-param2) : (param2));
            this._tlUtil.updateFrames(this._absoluteTime, this._activeSequence, this._revert);
            var _loc_3:* = this._activeSequence._frames[this._tlUtil.frame0];
            var _loc_4:* = this._activeSequence._frames[this._tlUtil.frame1];
            var _loc_5:* = Matrix3D.interpolate(_loc_3, _loc_4, this._tlUtil.blendWeight);
            if (this.additionalTransform)
            {
                _loc_5.append(this.additionalTransform);
            }
            this._target.transform = _loc_5;
        }// end function

        function getSequence(param1:String) : TransformAnimationSequence
        {
            return this._sequences[param1];
        }// end function

    }
}
