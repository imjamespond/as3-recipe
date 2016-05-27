package com.codechiev.car
{
    import away3d.containers.*;
    import away3d.entities.*;
    import away3d.events.*;
    import away3d.tools.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.ui.*;
    import fr.digitas.jexplorer.d3.scene.misc.*;
    import fr.digitas.jexplorer.d3.utils.*;
    import fr.digitas.jexplorer.sound.*;
    import fr.digitas.jexplorer.ui.*;
    import fr.digitas.jexplorer.ui.tips.*;

    public class CarDoorHelper extends EventDispatcher
    {
        private var _active:Boolean;
        private var _doorOpen:Boolean;
        private var _arrowHelper:DoorArrow;
        public var animId:String;
        private var _oldRotation:Number = 0;
        private var _canClick:Boolean;
        private var _initArrowX:Number;
        private var _left:Boolean;
        private var _downPos:Point;
        private var _doorname:String;
        private var _unlocked:Boolean = false;
        private var _iactive:Mesh;
        private var _iactive_group:Mesh;
        private var _iactivep:ObjectContainer3D;
        private var _stage:Stage;
        private var _down:Boolean;
        private var _isOver:Boolean;
        private var _drag_iactive:Mesh;
        private var _door:Mesh;
        private var _arrow1:Mesh;
        private var _dragHelper:DragRotationHelper;

        public function CarDoorHelper(param1:Mesh, param2:Mesh, param3:Stage, param4:String, param5:Boolean)
        {
            this._downPos = new Point();
            this._left = param5;
            this._doorname = param4;
            this._stage = param3;
            this._iactive_group = param2;
            this._iactive = findChild(this._iactive_group, param4 + "_move") as Mesh;
            this._iactive.lpMouse = true;
            this._iactive.material = null;
            this._iactivep = this._iactive_group.parent;
            this._door = param1;
            this._drag_iactive = findChild(param1, "iac_" + param4) as Mesh;
            this._arrow1 = findChild(param1, param4 + "_garw") as Mesh;
            this._arrowHelper = new DoorArrow(this._arrow1, param5);
            this._drag_iactive.bothsideMouse = true;
            this._dragHelper = new DragRotationHelper(this._door, Vector3D.Y_AXIS, param3, this._drag_iactive);
            if (param5)
            {
                this._dragHelper.setRange(0, 75);
            }
            else
            {
                this._dragHelper.setRange(-75, 0);
            }
            this._dragHelper.addEventListener(Event.CHANGE, this.onRotationChange);
            this._drag_iactive.addEventListener(MouseEvent3D.MOUSE_OVER, this.dragOver);
            this._drag_iactive.addEventListener(MouseEvent3D.MOUSE_OUT, this.dragOut);
            this._drag_iactive.addEventListener(MouseEvent3D.MOUSE_DOWN, this.dragDown);
            this._iactive.addEventListener(MouseEvent3D.MOUSE_DOWN, this.enterClick);
            this._iactive.addEventListener(MouseEvent3D.MOUSE_OVER, this.overtest);
            this._stage.addEventListener(MouseEvent.MOUSE_UP, this.dragUp);
            this._door.removeChild(this._arrow1);
            this._iactivep.removeChild(this._iactive_group);
            var _loc_6:* = findChild(param1, param4 + "_int") as Mesh;
            param1.removeChild(_loc_6);
            param1.removeChild(this._drag_iactive);
            new Flat().apply(param1);
            param1.addChild(_loc_6);
            param1.addChild(this._drag_iactive);
            return;
        }// end function

        public function dispose() : void
        {
            this._drag_iactive.removeEventListener(MouseEvent3D.MOUSE_OVER, this.dragOver);
            this._drag_iactive.removeEventListener(MouseEvent3D.MOUSE_OUT, this.dragOut);
            this._drag_iactive.removeEventListener(MouseEvent3D.MOUSE_DOWN, this.dragDown);
            this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.dragUp);
            return;
        }// end function

        public function openDoor() : void
        {
            this._dragHelper.resetTo(this._left ? (75) : (-75));
            Tweener.addTween(this._door, {rotationY:this._left ? (75) : (-75), time:0.6, transition:Equations.easeInOutQuad, onComplete:this.onDoorOpened});
            return;
        }// end function

        public function closeDoor() : void
        {
            Tweener.addTween(this._door, {rotationY:0, time:1.1, transition:Equations.easeInOutQuad, onComplete:this.onDoorClosed});
            return;
        }// end function

        public function activate(param1:Boolean) : void
        {
            this._dragHelper.activate(param1);
            this._iactive.lpMouse = param1;
            if (param1)
            {
                this._drag_iactive.addEventListener(MouseEvent3D.MOUSE_OVER, this.dragOver);
                this._drag_iactive.addEventListener(MouseEvent3D.MOUSE_OUT, this.dragOut);
                this._drag_iactive.addEventListener(MouseEvent3D.MOUSE_DOWN, this.dragDown);
                this._iactive.addEventListener(MouseEvent3D.MOUSE_OVER, this.enterOver);
                this._iactive.addEventListener(MouseEvent3D.MOUSE_OUT, this.enterOut);
                this._iactive.addEventListener(MouseEvent3D.MOUSE_DOWN, this.enterClick);
                this._stage.addEventListener(MouseEvent.MOUSE_UP, this.dragUp);
            }
            else
            {
                this._drag_iactive.removeEventListener(MouseEvent3D.MOUSE_OVER, this.dragOver);
                this._drag_iactive.removeEventListener(MouseEvent3D.MOUSE_OUT, this.dragOut);
                this._drag_iactive.removeEventListener(MouseEvent3D.MOUSE_DOWN, this.dragDown);
                this._iactive.removeEventListener(MouseEvent3D.MOUSE_OVER, this.enterOver);
                this._iactive.removeEventListener(MouseEvent3D.MOUSE_OUT, this.enterOut);
                this._iactive.removeEventListener(MouseEvent3D.MOUSE_DOWN, this.enterClick);
                this._stage.removeEventListener(MouseEvent.MOUSE_UP, this.dragUp);
                this._arrowHelper.hide();
                var _loc_2:Boolean = false;
                this._isOver = false;
                this._down = _loc_2;
            }
            return;
        }// end function

        private function enterOver(param1:MouseEvent3D) : void
        {
            Mouse.cursor = Cursors.FINGER;
            return;
        }// end function

        private function enterOut(param1:MouseEvent3D) : void
        {
            Mouse.cursor = MouseCursor.AUTO;
            return;
        }// end function

        private function overtest(param1:MouseEvent3D) : void
        {
            return;
        }// end function

        private function enterClick(param1:MouseEvent3D) : void
        {
            TipsActions.getInstance().makeAction(TipType.INSIDE);
            Mouse.cursor = MouseCursor.AUTO;
            dispatchEvent(new Event(Event.SELECT));
            return;
        }// end function

        private function onRotationChange(event:Event) : void
        {
            if (Math.abs(this._dragHelper.rotation) > 40)
            {
                if (!(this._doorOpen || this._down))
                {
                    this._iactivep.addChild(this._iactive_group);
                    TipsActions.getInstance().makeAction(TipType.DOOR);
                    this._doorOpen = true;
                }
            }
            else if (this._doorOpen)
            {
                this._iactivep.removeChild(this._iactive_group);
                this._doorOpen = false;
            }
            if (Math.abs(this._dragHelper.rotation) > 0.1)
            {
                if (this._unlocked)
                {
                    return;
                }
                this._unlocked = true;
                dispatchEvent(new Event(Event.OPEN));
                soundManager.playSound("door-open");
            }
            else
            {
                if (!this._unlocked)
                {
                    return;
                }
                this._unlocked = false;
                dispatchEvent(new Event(Event.CLOSE));
                soundManager.playSound("door-close");
            }
            this._oldRotation = this._dragHelper.rotation;
            return;
        }// end function

        private function onDoorOpened() : void
        {
            return;
        }// end function

        private function onDoorClosed() : void
        {
            this._dragHelper.resetTo(0);
            return;
        }// end function

        private function dragUp(event:MouseEvent) : void
        {
            if (this._isOver)
            {
                Mouse.cursor = Cursors.OPEN_HAND;
            }
            else if (this._down)
            {
                Mouse.cursor = MouseCursor.AUTO;
                this.removeArrow();
            }
            if (this._canClick)
            {
                this._click();
            }
            this._down = false;
            this._canClick = false;
            this.onRotationChange(null);
            return;
        }// end function

        private function _click() : void
        {
            if (Math.abs(this._dragHelper.rotation) < 4)
            {
                this.openDoor();
            }
            else if (Math.abs(this._dragHelper.rotation) > 40)
            {
                this.closeDoor();
            }
            return;
        }// end function

        private function dragDown(param1:MouseEvent3D) : void
        {
            this._downPos.x = this._stage.mouseX;
            this._downPos.y = this._stage.mouseY;
            this._canClick = true;
            this._stage.addEventListener(MouseEvent.MOUSE_MOVE, this.move);
            Mouse.cursor = Cursors.CLOSED_HAND;
            if (this._doorOpen)
            {
                this._iactivep.removeChild(this._iactive_group);
            }
            this._doorOpen = false;
            this._down = true;
            return;
        }// end function

        private function move(event:MouseEvent) : void
        {
            if (Math.abs(this._stage.mouseX - this._downPos.x) > 2 || Math.abs(this._stage.mouseY - this._downPos.y) > 2)
            {
                this._canClick = false;
            }
            return;
        }// end function

        private function dragOut(param1:MouseEvent3D) : void
        {
            this._isOver = false;
            if (this._down)
            {
                return;
            }
            Mouse.cursor = MouseCursor.AUTO;
            this.removeArrow();
            return;
        }// end function

        private function dragOver(param1:MouseEvent3D) : void
        {
            Mouse.cursor = Cursors.OPEN_HAND;
            this._isOver = true;
            this.addArrow();
            return;
        }// end function

        private function addArrow() : void
        {
            this._door.addChild(this._arrow1);
            this._arrowHelper.show();
            return;
        }// end function

        private function removeArrow() : void
        {
            this._arrowHelper.hide();
            return;
        }// end function

        public function get unlocked() : Boolean
        {
            return this._unlocked;
        }// end function

    }
}
