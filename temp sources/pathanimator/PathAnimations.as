package com.codechiev.pathanimator
{
    import away3d.animators.*;
    import away3d.animators.data.*;
    import away3d.events.*;
    import flash.events.*;
    import flash.geom.*;
    import com.codechiev.steadycam.SteadyCam;
    import com.codechiev.car.Car;
    import com.codechiev.car.CarDoorHelper;

    public class PathAnimations extends EventDispatcher
    {
        //private var _car:Car;
		private var _car:Car;
        private var _studioCam:SteadyCam;
        private var camAnimator:TransformAnimator;
        private var targetAnimator:TransformAnimator;
        private var _currentAnim:String;
        private var _revert:Boolean;
        private var _isInside:Boolean = false;
        public static const INOUT_CHANGE:String = "INOUT_CHANGE";
        public static const SIT:String = "SIT";
        public static const EXIT:String = "EXIT";

        public function PathAnimations(car:Car, sdCam:SteadyCam)
        {
            this._studioCam = sdCam;
            this._car = car;
            this._build();
            return;
        }// end function

        public function set isInside(param1:Boolean) : void
        {
            if (this._isInside == param1)
            {
                return;
            }
            this._isInside = param1;
            dispatchEvent(new Event(INOUT_CHANGE));
            return;
        }// end function

        public function get isInside() : Boolean
        {
            return this._isInside;
        }// end function

        public function registerHelper(carDoor:CarDoorHelper) : void
        {
            carDoor.addEventListener(Event.SELECT, this.enter);
            return;
        }// end function

        public function abort() : void
        {
            this.camAnimator.stop();
            this.targetAnimator.stop();
            return;
        }// end function

        private function _build() : void
        {
            var _loc_1:TransformAnimationSequence = null;
            this.camAnimator = new TransformAnimator(this._studioCam);
            this.targetAnimator = new TransformAnimator(this._studioCam.target);
            var _loc_2:* = this._car.trunk.transform;
            this.camAnimator.additionalTransform = this._car.trunk.transform;
            this.targetAnimator.additionalTransform = _loc_2;
            this.camAnimator.addEventListener(AnimatorEvent.START, this.animStart);
            for each (_loc_1 in this._car.camPath.getCamSequences())
            {
                
                this.camAnimator.addSequence(_loc_1);
            }
            for each (_loc_1 in this._car.camPath.getTgtSequences())
            {
                
                this.targetAnimator.addSequence(_loc_1);
            }
            return;
        }// end function

        private function enter(event:Event) : void
        {
			/*TODO
            if (this._car.alloySelector.currentWheel != null)
            {
                return;
            }*/
            this.isInside = true;
            var carDoor:CarDoorHelper = event.currentTarget as CarDoorHelper;
            this.playAnim(carDoor.animId);
        }// end function

		
		/**
		 *播放动画 
		 * @param param1
		 * @param param2
		 * 
		 */
        public function playAnim(name:String, revert:Boolean = false) : void
        {
            var startPos:Vector3D = null;
            var endPos:Vector3D = null;
            var camAnimatorSeq:TransformAnimationSequence = this.camAnimator.getSequence(name);
            var targetAnimatorSeq:TransformAnimationSequence = this.targetAnimator.getSequence(name);
            this._currentAnim = name;
            this._revert = revert;
            if (this._studioCam.mode == SteadyCam.MANUAL)
            {
                startPos = camAnimatorSeq.getFirstPos();
                startPos = this._car.trunk.transform.transformVector(startPos);
                endPos = targetAnimatorSeq.getFirstPos();
                endPos = this._car.trunk.transform.transformVector(endPos);
                this._studioCam.goTo(startPos, endPos);
                this._studioCam.addEventListener(SteadyCam.CONNECTED, this.camConnected);
            }
            else if (this._studioCam.mode == SteadyCam.INTERIOR)
            {
                startPos = camAnimatorSeq.getLastPos();
                endPos = targetAnimatorSeq.getLastPos();
                this._studioCam.rotationTo(startPos, endPos, 2, SteadyCam.ANIM, this.camConnected);
                this.isInside = false;
            }
            return;
        }// end function

        private function camConnected(event:Event = null) : void
        {
            var _loc_3:int = 0;
            this._studioCam.lookOffset.z = 0;
            var _loc_3:* = _loc_3;
            this._studioCam.lookOffset.y = _loc_3;
            this._studioCam.lookOffset.x = _loc_3;
            var _loc_2:* = this.camAnimator.getSequence(this._currentAnim);
            _loc_2.addEventListener(AnimatorSeqEvent.SEQUENCE_DONE, this.animComplete);
            this._studioCam.mode = SteadyCam.ANIM;
            this.camAnimator.play(this._currentAnim, this._revert);
            this.targetAnimator.play(this._currentAnim, this._revert);
            this._studioCam.step(1);
            return;
        }// end function

        private function animStart(event:AnimatorEvent) : void
        {
            return;
        }// end function

        private function animComplete(event:AnimatorSeqEvent) : void
        {
            event.currentTarget.removeEventListener(AnimatorSeqEvent.SEQUENCE_DONE, this.animComplete);
            this.camAnimator.stop();
            this.targetAnimator.stop();
            if (this.isInside)
            {
                this.justSit(event.sequence.name);
            }
            else
            {
                this.justExit();
            }
            return;
        }// end function

        private function justSit(param1:String) : void
        {
            dispatchEvent(new TextEvent(SIT, false, false, param1));
            return;
        }// end function

        private function justExit() : void
        {
            dispatchEvent(new Event(EXIT));
            return;
        }// end function

    }
}
