package sliz.miniui 
{
    import flash.display.*;
    import sliz.miniui.core.*;
    import sliz.miniui.layouts.*;
    import sliz.miniui.skin.*;
    
    public class Panel extends sliz.miniui.core.SkinAbleSprite
    {
        public function Panel(arg1:flash.display.DisplayObjectContainer=null, arg2:Number=0, arg3:Number=0)
        {
            var loc1:*=null;
            this.childs = [];
            if (sliz.miniui.core.UIManager.panelSkin == null) 
            {
                loc1 = new sliz.miniui.skin.PanelSkin(this);
            }
            else 
            {
                loc1 = new sliz.miniui.core.UIManager.panelSkin(this);
            }
            super(loc1);
            if (arg1) 
            {
                arg1.addChild(this);
            }
            this.x = arg2;
            this.y = arg3;
            return;
        }

        public function add(arg1:flash.display.DisplayObject, arg2:String=null, arg3:Object=null):void
        {
            addChild(arg1);
            if (arg2) 
            {
                this.childs[arg2] = {"c":arg1, "l":arg3};
            }
            else 
            {
                this.childs.push({"c":arg1, "l":arg3});
            }
            return;
        }

        public function remove(arg1:flash.display.DisplayObject):void
        {
            return;
        }

        internal function update():void
        {
            updateSkin();
            return;
        }

        public function setWH(arg1:Number, arg2:Number):void
        {
            this.maxW = arg1;
            this.maxH = arg2;
            this.update();
            return;
        }

        public function doLayout():void
        {
            if (this.layout) 
            {
                this.layout.doLayout();
            }
            return;
        }

        public function setLayout(arg1:sliz.miniui.layouts.Layout):void
        {
            this.layout = arg1;
            return;
        }

        public function getLayout():sliz.miniui.layouts.Layout
        {
            return this.layout;
        }

        public function getChildByLayoutName(arg1:String):flash.display.DisplayObject
        {
            return this.childs[arg1].c;
        }

        public function getLayoutObj(arg1:String):Object
        {
            return this.childs[arg1].l;
        }

        public function setMargin(arg1:Number, arg2:Number, arg3:Number, arg4:Number):void
        {
            this.top = arg1;
            this.bottom = arg2;
            this.left = arg3;
            this.right = arg4;
            return;
        }

        public function get maxH():Number
        {
            return this._maxH;
        }

        public function set maxH(arg1:Number):void
        {
            this._maxH = arg1;
            return;
        }

        public function get maxW():Number
        {
            return this._maxW;
        }

        public function set maxW(arg1:Number):void
        {
            this._maxW = arg1;
            return;
        }

        public function get top():Number
        {
            return this._top;
        }

        public function set top(arg1:Number):void
        {
            this._top = arg1;
            return;
        }

        public function get bottom():Number
        {
            return this._bottom;
        }

        public function set bottom(arg1:Number):void
        {
            this._bottom = arg1;
            return;
        }

        public function get left():Number
        {
            return this._left;
        }

        public function set left(arg1:Number):void
        {
            this._left = arg1;
            return;
        }

        public function get right():Number
        {
            return this._right;
        }

        public function set right(arg1:Number):void
        {
            this._right = arg1;
            return;
        }

        public var childs:Array;

        protected var _top:Number=10;

        protected var _bottom:Number=10;

        protected var _left:Number=10;

        protected var _right:Number=10;

        internal var _maxH:Number=0;

        internal var _maxW:Number=0;

        internal var layout:sliz.miniui.layouts.Layout;
    }
}


