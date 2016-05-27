package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class Silder extends sliz.miniui.core.SkinAbleSprite
    {
        public function Silder(arg1:Number=0, arg2:Number=0, arg3:flash.display.DisplayObjectContainer=null, arg4:String="num", arg5:Function=null, arg6:Number=100, arg7:Number=0, arg8:Function=null)
        {
            var loc1:*=null;
            this.binds = [];
            this.rotation = arg7;
            this.l = arg6;
            this.rect = new sliz.miniui.SilderBlack(0, 0, this);
            this.diffX = this.rect.width / 2;
            this.diffY = this.rect.height / 2;
            this.x = arg1;
            this.y = arg2;
            if (arg4 != null) 
            {
                this.showLabel = arg4;
                this.label = new sliz.miniui.Label("a");
                addChild(this.label);
                this.label.x = arg6 + 5;
                this.label.y = (-this.label.height) / 2;
                if (arg5 != null) 
                {
                    this.showLabelFun = arg5;
                }
                else 
                {
                    this.showLabelFun = this.simpleLabelFun;
                }
                this.updatelabel();
                addEventListener(flash.events.Event.CHANGE, this.updatelabel);
            }
            if (arg3) 
            {
                arg3.addChild(this);
            }
            if (arg8 != null) 
            {
                addEventListener(flash.events.Event.CHANGE, arg8);
            }
            this.rect.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onMouseDown);
            if (sliz.miniui.core.UIManager.silderSkin == null) 
            {
                loc1 = new sliz.miniui.skin.SilderSkin(this);
            }
            else 
            {
                loc1 = new sliz.miniui.core.UIManager.silderSkin(this);
            }
            super(loc1);
            updateSkin();
            return;
        }

        public function setBlackSkin(arg1:Class):void
        {
            this.rect.setSkin(new arg1(this.rect, 2, 19));
            this.rect.updateSkin();
            this.l = this.l - this.rect.width + this.diffX * 2;
            this._diffX = this.rect.width / 2;
            this.value = this.value;
            updateSkin();
            return;
        }

        public function bind(arg1:Object, arg2:String, arg3:Function=null):void
        {
            this.binds.push({"target":arg1, "name":arg2, "func":arg3});
            return;
        }

        public function unBind(arg1:Object, arg2:String=null):void
        {
            return;
        }

        internal function updatelabel(arg1:flash.events.Event=null):void
        {
            this.label.text = this.showLabel.replace(new RegExp("num", "g"), "" + this.showLabelFun(this.value));
            return;
        }

        internal function simpleLabelFun(arg1:Number):String
        {
            return arg1 + "";
        }

        internal function testBind():void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=0;
            var loc6:*=this.binds;
            for each (loc1 in loc6) 
            {
                loc2 = loc1.target;
                loc3 = loc1.name;
                if ((loc4 = loc1.func) != null) 
                {
                    loc2[loc3] = loc4(this.value);
                    continue;
                }
                loc2[loc3] = this.value;
            }
            return;
        }

        internal function onMouseDown(arg1:flash.events.MouseEvent):void
        {
            this.sx = mouseX - this.rect.x;
            stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onMouseUp);
            return;
        }

        internal function onMouseMove(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=mouseX - this.sx;
            this.value = loc1 / this.l;
            this.testBind();
            arg1.updateAfterEvent();
            return;
        }

        internal function onMouseUp(arg1:flash.events.MouseEvent):void
        {
            stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onMouseUp);
            return;
        }

        public function get l():Number
        {
            return this._l;
        }

        public function set l(arg1:Number):void
        {
            this._l = arg1;
            return;
        }

        public override function get width():Number
        {
            return this.l + 2 * this.diffX;
        }

        public override function get x():Number
        {
            return super.x - this.diffX;
        }

        public override function set x(arg1:Number):void
        {
            super.x = arg1 + this.diffX;
            return;
        }

        public override function get y():Number
        {
            return super.y + this.diffY;
        }

        public override function set y(arg1:Number):void
        {
            super.y = arg1 + this.diffY;
            return;
        }

        public function get value():Number
        {
            return this._value;
        }

        public function set value(arg1:Number):void
        {
            arg1 = Math.max(0, arg1);
            arg1 = Math.min(1, arg1);
            if (this._value != arg1) 
            {
                this._value = arg1;
                dispatchEvent(new flash.events.Event(flash.events.Event.CHANGE));
            }
            this.rect.x = arg1 * this.l;
            return;
        }

        public function get diffX():Number
        {
            return this._diffX;
        }

        public function set diffX(arg1:Number):void
        {
            this._diffX = arg1;
            return;
        }

        internal var rect:sliz.miniui.SilderBlack;

        internal var _l:Number;

        internal var binds:Array;

        internal var _value:Number=0;

        internal var label:sliz.miniui.Label;

        internal var showLabel:String;

        internal var showLabelFun:Function;

        internal var sx:Number;

        internal var _diffX:Number;

        internal var diffY:Number;
    }
}


