package com.codechiev.pathanimator
{
    import away3d.animators.*;
    import away3d.animators.data.*;
    import flash.events.*;
    import away3d.events.AnimatorEvent;

    public class AnimatorSeqEvent extends AnimatorEvent
    {
        private var _sequence:AnimationSequenceBase;
        private var _animator:AnimatorBase;
        public static const SEQUENCE_DONE:String = "SequenceDone";
        public static const START:String = "start";
        public static const STOP:String = "stop";

        public function AnimatorSeqEvent(type:String, animator:AnimatorBase, sequence:AnimationSequenceBase = null) : void
        {
            super(type, animator);
            this._sequence = sequence;
            this._animator = animator;
            return;
        }// end function


        public function get sequence() : AnimationSequenceBase
        {
            return this._sequence;
        }// end function

        override public function clone() : Event
        {
            return new AnimatorSeqEvent(type, this._animator, this._sequence);
        }// end function

    }
}
