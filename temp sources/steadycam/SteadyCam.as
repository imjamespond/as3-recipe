package com.codechiev.steadycam
{
    import away3d.cameras.*;
    import away3d.containers.*;
    import away3d.core.base.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;

    public class SteadyCam extends Camera3D
    {
        public var dirx:Number = 0;
        public var dirz:Number = 0;
        private var _mode:uint = 0;
        //private var _currentRo:RotatedOffset;
        private var _walk:Boolean = false;
        private var walkspeed:Number = 0;
        private var walkdirx:Number = 0;
        private var walkdirz:Number = 0;
        private var ldir:Vector3D;
        private var _lastTime:int = 0;
        private const _target:ObjectContainer3D = new ObjectContainer3D();
        public var _paralaxmul:Number = 0;
        private var _paralax:Point;
        private var _walkheight:Number = 0;
        private var _walkMov:Vector3D;
        private var _walkMovCycle:Number = 0;
        private var _breathMov:Vector3D;
        private var _breathMovCycle:Number = 0;
        private var _gotoPos:Vector3D;
        private var _gotoTgt:Vector3D;
        private var _gotoInitDist:Number;
        private var _stage:Stage;
        private var _gotoInitTgt:Vector3D;
        private var _connectProgress:Number = 0;
        private const _connectInitLo:Vector3D = new Vector3D();
        private var _connectInitPos:Vector3D;
        private var _connectInitTgt:Vector3D;
        public var stiffness:Number = 4;
        public var damping:Number = 20;
        public var mass:Number = 40;
        public var positionOffset:Vector3D;
        public var lookOffset:Vector3D;
        public var springTarget:Object3D;
        private var _helper:SpringCamHelper;
        private var _velocity:Vector3D;
        private var _dv:Vector3D;
        private var _stretch:Vector3D;
        private var _force:Vector3D;
        private var _acceleration:Vector3D;
        private var _intHelper:InteriorCamHelper;
        private var _intInitPos:Vector3D;
        private var _intInitTgt:Vector3D;
        private var _desiredPosition:Vector3D;
        private var _lookAtPosition:Vector3D;
        private var _xPositionOffset:Vector3D;
        private var _xLookOffset:Vector3D;
        private var _xPosition:Vector3D;
        public static const HEIGHT:Number = 300;
        public static const MANUAL:uint = 0;
        public static const GOTO:uint = 1;
        public static const CONNECT:uint = 2;
        public static const IDLE:uint = 3;
        public static const SPRING:uint = 4;
        public static const ROTATION:uint = 5;
        public static const PANO:uint = 6;
        public static const INTERIOR:uint = 7;
        public static const SPRING_LOCK:uint = 8;
        public static const ANIM:uint = 9;
        public static const CONNECTED:String = "sc_connected";
        public static const TGT_HEIGHT:Number = 35;

        public function SteadyCam(param1:Stage)
        {
            this.ldir = new Vector3D();
            //this._target = new ObjectContainer3D();
            this._paralax = new Point();
            this._walkMov = new Vector3D();
            this._breathMov = new Vector3D();
            //this._connectInitLo = new Vector3D();
            this.positionOffset = new Vector3D(0, 5, -50);
            this.lookOffset = new Vector3D(0, 2, 10);
            this._velocity = new Vector3D();
            this._dv = new Vector3D();
            this._stretch = new Vector3D();
            this._force = new Vector3D();
            this._acceleration = new Vector3D();
            this._desiredPosition = new Vector3D();
            this._lookAtPosition = new Vector3D();
            this._xPositionOffset = new Vector3D();
            this._xLookOffset = new Vector3D();
            this._xPosition = new Vector3D();
            this._stage = param1;
            super(lens);
            this._helper = new SpringCamHelper(this, param1);
            this._intHelper = new InteriorCamHelper(this, param1);
            this._target.name = "SteadyCam-target";
            name = "SteadyCam";
            return;
        }// end function

        public function get mode() : uint
        {
            return this._mode;
        }// end function

        public function set mode(param1:uint) : void
        {
            if (this._mode == param1)
            {
                return;
            }
            var _loc_2:* = this._mode;
            this._mode = param1;
            this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.keyDown);
            this._stage.removeEventListener(KeyboardEvent.KEY_UP, this.keyUp);
            this._intHelper.activate(false);
            this._helper.activate(false);
            switch(this._mode)
            {
                case SPRING:
                {
                    this._helper.activate(true);
                }
                case SPRING_LOCK:
                {
                    this._helper.reset();
                    this.stopInertias();
                    this.initPositionOffset();
                    break;
                }
                case GOTO:
                {
                    break;
                }
                case ROTATION:
                {
                    this.initPositionOffset();
                    break;
                }
                case MANUAL:
                {
                    this._initWalkKeys();
                    this._walkheight = y;
                    var _loc_3:* = (-Math.PI) / 2;
                    this._walkMovCycle = (-Math.PI) / 2;
                    this._breathMovCycle = _loc_3;
                    _loc_3 = 0;
                    this._paralax.y = 0;
                    this._paralax.x = _loc_3;
                    this._paralaxmul = _loc_3;
                    Tweener.addTween(this, {_paralaxmul:1, time:1.2, transition:"linear"});
                    break;
                }
                case INTERIOR:
                {
                    this._initInterior();
                    break;
                }
                case IDLE:
                case ANIM:
                {
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _initInterior() : void
        {
            this.stopInertias();
            var _loc_1:* = this._target.position.subtract(position);
            _loc_1.normalize();
            _loc_1.scaleBy(45);
            this._target.position = position.add(_loc_1);
            var _loc_2:* = this._target.transform.clone();
            _loc_2.invert();
            this.positionOffset.copyFrom(_loc_2.transformVector(position));
            var _loc_3:int = 0;
            this.lookOffset.z = 0;
            this.lookOffset.y = _loc_3;
            this.lookOffset.x = _loc_3;
            this._intHelper.reset();
            this._intHelper.activate(true);
            return;
        }// end function

        private function stopInertias() : void
        {
            var _loc_1:* = new Vector3D();
            this._velocity.copyFrom(_loc_1);
            this._dv.copyFrom(_loc_1);
            this._stretch.copyFrom(_loc_1);
            this._force.copyFrom(_loc_1);
            this._acceleration.copyFrom(_loc_1);
            return;
        }// end function

        public function walkMode() : void
        {
            this.mode = MANUAL;
            return;
        }// end function

        public function idle() : void
        {
            this.mode = IDLE;
            return;
        }// end function

        public function springMode() : void
        {
            this._helper.reset();
            this.mode = SPRING;
            return;
        }// end function

        public function rotationTo(param1:Vector3D, toPos:Vector3D, duration:Number, mode:uint, doneFunc:Function = null, transitionFunc:Function = null) : void
        {
            this.mode = ROTATION;
            if (transitionFunc == null)
            {
                transitionFunc = Equations.easeInOutQuart;
            }
            Tweener.addTween(this.lookOffset, {x:toPos.x, z:toPos.z, y:toPos.y, time:duration, transition:transitionFunc});
            /*旋转某个东西
			if (this._currentRo)
            {
                Tweener.removeTweens(this._currentRo);
            }
            this._currentRo = new RotatedOffset(this.positionOffset, param1);
            Tweener.addTween(this._currentRo, {progress:1, time:duration, transition:transitionFunc, onComplete:this.rotationComplete, onCompleteParams:[mode, doneFunc]});
            */
        }// end function

        private function initPositionOffset() : void
        {
            var _loc_1:* = this.springTarget || this._target;
            var _loc_2:* = _loc_1.transform.clone();
            _loc_2.invert();
            this.positionOffset.copyFrom(_loc_2.transformVector(position));
            this.lookOffset.copyFrom(_loc_2.transformVector(this._lookAtPosition));
            return;
        }// end function

        private function rotationComplete(mode:uint, doneFunc:Function) : void
        {
            this._stepRotation(1);
            this.mode = mode;
            //this._currentRo = null;
            if (doneFunc != null)
            {
				doneFunc.apply();
            }
            return;
        }// end function

        public function goTo(param1:Vector3D, param2:Vector3D) : void
        {
            this._gotoPos = param1;
            this._gotoTgt = param2;
            this._gotoInitTgt = this.springTarget.position.clone();
            var _loc_3:* = this.springTarget.transform.clone();
            _loc_3.invert();
            this._connectInitLo.copyFrom(_loc_3.transformVector(this._lookAtPosition));
            this._gotoInitDist = Vector3D.distance(position, this._gotoPos);
            this.mode = this._gotoInitDist > 100 ? (GOTO) : (CONNECT);
            return;
        }// end function

        public function stop() : void
        {
            return;
        }// end function

        public function step(param1:Number) : void
        {
            switch(this._mode)
            {
                case MANUAL:
                {
                    this._stepManual(param1);
                    break;
                }
                case GOTO:
                {
                    this._stepGoto(param1);
                    break;
                }
                case CONNECT:
                {
                    this._stepConnect(param1);
                    break;
                }
                case SPRING:
                {
                    this._helper.step();
                }
                case SPRING_LOCK:
                {
                    this._stepSpring(param1);
                    break;
                }
                case ROTATION:
                {
                    this._stepRotation(param1);
                    break;
                }
                case IDLE:
                {
                    this._stepIdle(param1);
                    break;
                }
                case ANIM:
                {
                    this._stepAnim(param1);
                    break;
                }
                case INTERIOR:
                {
                    this._stepInterior(param1);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function _stepInterior(param1:Number) : void
        {
            var _loc_2:* = this._target;
            this._intHelper.step();
            this._xPositionOffset = _loc_2.transform.deltaTransformVector(this.positionOffset);
            this._desiredPosition = _loc_2.position.add(this._xPositionOffset);
            this._stretch = this.position.subtract(this._desiredPosition);
            this._stretch.scaleBy(-this.stiffness);
            this._dv = this._velocity.clone();
            this._dv.scaleBy(this.damping);
            this._force = this._stretch.subtract(this._dv);
            this._acceleration = this._force.clone();
            this._acceleration.scaleBy(1 / 30);
            this._velocity.x = this._velocity.x + this._acceleration.x * param1;
            this._velocity.y = this._velocity.y + this._acceleration.y * param1;
            this._velocity.z = this._velocity.z + this._acceleration.z * param1;
            x = position.x + this._velocity.x * param1;
            y = position.y + this._velocity.y * param1;
            z = position.z + this._velocity.z * param1;
            invalidateSceneTransform();
            this._xLookOffset = _loc_2.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = _loc_2.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _stepRotation(param1:Number) : void
        {
            var _loc_2:* = this.springTarget || this._target;
            this._xPositionOffset = _loc_2.transform.deltaTransformVector(this.positionOffset);
            this._desiredPosition = _loc_2.position.add(this._xPositionOffset);
            x = this._desiredPosition.x;
            y = this._desiredPosition.y;
            z = this._desiredPosition.z;
            invalidateSceneTransform();
            this._xLookOffset = _loc_2.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = _loc_2.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _stepSpring(param1:Number) : void
        {
            var _loc_2:* = this.springTarget || this._target;
            this._xPositionOffset = _loc_2.transform.deltaTransformVector(this.positionOffset);
            this._desiredPosition = _loc_2.position.add(this._xPositionOffset);
            this._stretch = this.position.subtract(this._desiredPosition);
            this._stretch.scaleBy(-this.stiffness);
            this._dv = this._velocity.clone();
            this._dv.scaleBy(this.damping);
            this._force = this._stretch.subtract(this._dv);
            this._acceleration = this._force.clone();
            this._acceleration.scaleBy(1 / this.mass);
            this._velocity.x = this._velocity.x + this._acceleration.x * param1;
            this._velocity.y = this._velocity.y + this._acceleration.y * param1;
            this._velocity.z = this._velocity.z + this._acceleration.z * param1;
            if (this._velocity.length < 0.05)
            {
                return;
            }
            x = position.x + this._velocity.x * param1;
            y = position.y + this._velocity.y * param1;
            z = position.z + this._velocity.z * param1;
            invalidateSceneTransform();
            this._xLookOffset = _loc_2.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = _loc_2.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _connect() : void
        {
            this.mode = CONNECT;
            this._connectProgress = 0;
            this._connectInitPos = position.clone();
            this._connectInitLo.copyFrom(this.lookOffset);
            this._connectInitTgt = this._target.position.clone();
            return;
        }// end function

        public function gogogo() : void
        {
            this._xPositionOffset = this._target.transform.deltaTransformVector(this.positionOffset);
            position = this._target.position.add(this._xPositionOffset);
            this._xLookOffset = this._target.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = this._target.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _stepIdle(param1:Number) : void
        {
            this._xPositionOffset = this._target.transform.deltaTransformVector(this.positionOffset);
            position = this._target.position.add(this._xPositionOffset);
            this._xLookOffset = this._target.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = this._target.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _stepAnim(param1:Number) : void
        {
            this._xLookOffset = this._target.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = this._target.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _stepManual(param1:Number) : void
        {
            this._walk = this.dirx != 0 || this.dirz != 0;
            var _loc_2:* = this.springTarget;
            var _loc_3:* = Vector3D.distance(this.springTarget.position, position);
            this.ldir.x = this.dirx;
            this.ldir.y = 0;
            this.ldir.z = this.dirz;
            if (_loc_3 < 500 && this.ldir.z > 0)
            {
                this.ldir.z = 0;
                if (this.dirx == 0)
                {
                    this._walk = false;
                }
            }
            else if (_loc_3 > 2000 && this.ldir.z < 0)
            {
                this.ldir.z = 0;
                if (this.dirx == 0)
                {
                    this._walk = false;
                }
            }
            this.ldir = transform.deltaTransformVector(this.ldir);
            this.ldir.normalize();
            if (this._walkMovCycle > Math.PI)
            {
                this._walkMovCycle = this._walkMovCycle - Math.PI * 2;
                this.playRandomStep();
            }
            this._breathMovCycle = this._breathMovCycle + 0.06 * param1;
            if (this._walk)
            {
                this._walkMovCycle = this._walkMovCycle + 0.18 * param1;
                if (this.walkspeed < 1)
                {
                    this.walkspeed = this.walkspeed + 0.065 * param1;
                }
                this.walkdirx = 0.7 * this.walkdirx + 0.3 * this.ldir.x;
                this.walkdirz = 0.7 * this.walkdirz + 0.3 * this.ldir.z;
                _loc_3 = Math.sqrt(this.walkdirx * this.walkdirx + this.walkdirz * this.walkdirz);
                this.walkdirx = this.walkdirx / _loc_3;
                this.walkdirz = this.walkdirz / _loc_3;
            }
            else
            {
                this._walkMovCycle = this._walkMovCycle * 0.95;
                this.walkspeed = this.walkspeed * 0.9;
                this.walkdirx = this.walkdirx * 0.9;
                this.walkdirz = this.walkdirz * 0.9;
            }
            this._walkMov.y = Math.max(6 * Math.sin(this._walkMovCycle + Math.PI / 2), -4);
            this._breathMov.y = 0.7 * Math.sin(this._breathMovCycle + Math.PI / 2);
            this._walkheight = this._walkheight + (HEIGHT - this._walkheight) * 0.07;
            var _loc_4:* = (Math.sin(this._walkMovCycle + Math.PI / 2) + 1) * 0.1 + 0.8;
            x = x + (this.walkdirx * this.walkspeed * 8 * _loc_4 * param1 + this._breathMov.x);
            z = z + (this.walkdirz * this.walkspeed * 8 * _loc_4 * param1 + this._breathMov.z);
            y = this._walkheight + this._walkMov.y + this._breathMov.y;
            this.lookOffset.x = 0;
            this.lookOffset.y = TGT_HEIGHT + this._breathMov.y;
            this.lookOffset.z = 0;
            this._xLookOffset = _loc_2.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = _loc_2.position.add(this._xLookOffset);
            var _loc_5:* = this._stage.mouseX / this._stage.stageWidth * 2 - 1;
            var _loc_6:* = this._stage.mouseY / this._stage.stageHeight * 2 - 1;
            this._paralax.x = this._paralax.x + (_loc_5 - this._paralax.x) * 0.1;
            this._paralax.y = this._paralax.y + (_loc_6 - this._paralax.y) * 0.1;
            var _loc_7:* = this._lookAtPosition.subtract(position);
            var _loc_8:* = this._lookAtPosition.subtract(position).crossProduct(Vector3D.Y_AXIS);
            var _loc_9:* = _loc_7.crossProduct(_loc_8);
            _loc_8.normalize();
            _loc_9.normalize();
            _loc_8.scaleBy((-this._paralax.x) * 50 * this._paralaxmul);
            _loc_9.scaleBy(this._paralax.y * 30 * this._paralaxmul);
            this._lookAtPosition.incrementBy(_loc_8);
            this._lookAtPosition.incrementBy(_loc_9);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function playRandomStep() : void
        {
            var _loc_1:* = Math.ceil(Math.random() * 3);
			//TODO
            //soundManager.playSound("walk" + _loc_1, false, 0.5);
            return;
        }// end function

        private function _stepGoto(param1:Number) : void
        {
            this.ldir = this._gotoPos.subtract(position);
            this.ldir.normalize();
            if (this._walkMovCycle > Math.PI)
            {
                this._walkMovCycle = this._walkMovCycle - Math.PI * 2;
                this.playRandomStep();
            }
            this._breathMovCycle = this._breathMovCycle + 0.06 * param1;
            this._walkMovCycle = this._walkMovCycle + 0.18 * param1;
            if (this.walkspeed < 1)
            {
                this.walkspeed = this.walkspeed + 0.065 * param1;
            }
            this.walkdirx = 0.7 * this.walkdirx + 0.3 * this.ldir.x;
            this.walkdirz = 0.7 * this.walkdirz + 0.3 * this.ldir.z;
            var _loc_2:* = Math.sqrt(this.walkdirx * this.walkdirx + this.walkdirz * this.walkdirz);
            this.walkdirx = this.walkdirx / _loc_2;
            this.walkdirz = this.walkdirz / _loc_2;
            this._walkMov.y = Math.max(6 * Math.sin(this._walkMovCycle + Math.PI / 2), -4);
            this._breathMov.y = 0.7 * Math.sin(this._breathMovCycle + Math.PI / 2);
            var _loc_3:* = (Math.sin(this._walkMovCycle + Math.PI / 2) + 1) * 0.1 + 0.8;
            x = x + (this.walkdirx * this.walkspeed * 8 * _loc_3 * param1 + this._breathMov.x);
            z = z + (this.walkdirz * this.walkspeed * 8 * _loc_3 * param1 + this._breathMov.z);
            var _loc_4:* = Vector3D.distance(position, this._gotoPos);
            var _loc_5:* = 1 - _loc_4 / this._gotoInitDist;
            var _loc_6:* = 1 - _loc_5;
            y = _loc_5 * this._gotoPos.y + _loc_6 * HEIGHT + this._walkMov.y + this._breathMov.y;
            this._target.x = _loc_5 * this._gotoTgt.x + _loc_6 * this._gotoInitTgt.x;
            this._target.y = _loc_5 * this._gotoTgt.y + _loc_6 * this._gotoInitTgt.y;
            this._target.z = _loc_5 * this._gotoTgt.z + _loc_6 * this._gotoInitTgt.z;
            this.lookOffset.x = _loc_6 * this._connectInitLo.x;
            this.lookOffset.y = _loc_6 * this._connectInitLo.y;
            this.lookOffset.z = _loc_6 * this._connectInitLo.z;
            if (_loc_5 > 0.9)
            {
                this._connect();
            }
            this._xLookOffset = this._target.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = this._target.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _stepConnect(param1:Number) : void
        {
            this._connectProgress = this._connectProgress + 0.05 * param1;
            var _loc_2:* = this._connectProgress;
            if (_loc_2 >= 1)
            {
                _loc_2 = 1;
                dispatchEvent(new Event(CONNECTED));
                this.mode = ANIM;
            }
            var _loc_3:* = 1 - _loc_2;
            x = _loc_2 * this._gotoPos.x + _loc_3 * this._connectInitPos.x;
            y = _loc_2 * this._gotoPos.y + _loc_3 * this._connectInitPos.y;
            z = _loc_2 * this._gotoPos.z + _loc_3 * this._connectInitPos.z;
            this._target.x = _loc_2 * this._gotoTgt.x + _loc_3 * this._connectInitTgt.x;
            this._target.y = _loc_2 * this._gotoTgt.y + _loc_3 * this._connectInitTgt.y;
            this._target.z = _loc_2 * this._gotoTgt.z + _loc_3 * this._connectInitTgt.z;
            this.lookOffset.x = _loc_3 * this._connectInitLo.x;
            this.lookOffset.y = _loc_3 * this._connectInitLo.y;
            this.lookOffset.z = _loc_3 * this._connectInitLo.z;
            this._xLookOffset = this._target.transform.deltaTransformVector(this.lookOffset);
            this._lookAtPosition = this._target.position.add(this._xLookOffset);
            lookAt(this._lookAtPosition);
            return;
        }// end function

        private function _initWalkKeys() : void
        {
            this._stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDown);
            this._stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUp);
            return;
        }// end function

        private function keyUp(event:KeyboardEvent) : void
        {
            var _loc_2:* = event.keyCode;
            switch(_loc_2)
            {
                case Keyboard.UP:
                case 90:
                {
                    if (this.dirz == 1)
                    {
                        this.dirz = 0;
                    }
					//TODO
                    //TipsActions.getInstance().makeAction(TipType.WALK);
                    break;
                }
                case Keyboard.DOWN:
                case 83:
                {
                    if (this.dirz == -1)
                    {
                        this.dirz = 0;
                    }
                    //TipsActions.getInstance().makeAction(TipType.WALK);
                    break;
                }
                case Keyboard.LEFT:
                case 81:
                {
                    if (this.dirx == -1)
                    {
                        this.dirx = 0;
                    }
                    //TipsActions.getInstance().makeAction(TipType.WALK);
                    break;
                }
                case Keyboard.RIGHT:
                case 68:
                {
                    if (this.dirx == 1)
                    {
                        this.dirx = 0;
                    }
					//TODO
                    //TipsActions.getInstance().makeAction(TipType.WALK);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function keyDown(event:KeyboardEvent) : void
        {
            var _loc_2:* = event.keyCode;
            switch(_loc_2)
            {
                case Keyboard.UP:
                case 90:
                {
                    this.dirz = 1;
                    break;
                }
                case Keyboard.DOWN:
                case 83:
                {
                    this.dirz = -1;
                    break;
                }
                case Keyboard.LEFT:
                case 81:
                {
                    this.dirx = -1;
                    break;
                }
                case Keyboard.RIGHT:
                case 68:
                {
                    this.dirx = 1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function get target() : ObjectContainer3D
        {
            return this._target;
        }// end function

    }
}
