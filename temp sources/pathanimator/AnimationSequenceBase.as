package com.codechiev.pathanimator
{
    import __AS3__.vec.*;
    import away3d.events.*;
    import away3d.library.assets.*;
	import away3d.arcane;
    import flash.geom.*;

	use namespace arcane;
	
    public class AnimationSequenceBase extends NamedAssetBase implements IAsset
    {
        public var looping:Boolean = true;
        protected var _rootDelta:Vector3D;
        var _totalDuration:uint;
        var _fixedFrameRate:Boolean = true;
        var _durations:Vector.<uint>;
        private var _animationEvent:AnimatorEvent;

        public function AnimationSequenceBase(param1:String)
        {
            super(param1);
            this._durations = new Vector.<uint>;
            this._rootDelta = new Vector3D();
            this._animationEvent = new AnimatorSeqEvent(AnimatorSeqEvent.SEQUENCE_DONE, null, this);
            return;
        }// end function

        public function get assetType() : String
        {
            return AssetType.ANIMATION;
        }// end function

        public function get fixedFrameRate() : Boolean
        {
            return this._fixedFrameRate;
        }// end function

        public function set fixedFrameRate(param1:Boolean) : void
        {
            this._fixedFrameRate = param1;
            return;
        }// end function

        public function get rootDelta() : Vector3D
        {
            return this._rootDelta;
        }// end function

        public function dispose(param1:Boolean) : void
        {
            return;
        }// end function

        public function get duration() : uint
        {
            return this._totalDuration;
        }// end function

        function notifyPlaybackComplete() : void
        {
            dispatchEvent(this._animationEvent);
            return;
        }// end function

    }
}
