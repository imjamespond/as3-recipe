package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.skin.*;
    
    public class Window extends sliz.miniui.Panel
    {
        public function Window(arg1:flash.display.DisplayObjectContainer=null, arg2:Number=0, arg3:Number=0, arg4:String=null)
        {
            super(arg1, arg2, arg3);
            this.title = new sliz.miniui.Title("Title", this, width);
            if (arg4) 
            {
                this.name = arg4;
            }
            this.title.tf.text = this.name;
            this.setMargin(10, 10, 10, 10);
            addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onMouseDown);
            filters = [sliz.miniui.skin.Style.shadow];
            return;
        }

        public override function setMargin(arg1:Number, arg2:Number, arg3:Number, arg4:Number):void
        {
            super.setMargin(arg1 + this.title.height, arg2, arg3, arg4);
            return;
        }

        internal function onMouseDown(arg1:flash.events.MouseEvent):void
        {
            parent.setChildIndex(this, (parent.numChildren - 1));
            return;
        }

        public override function setWH(arg1:Number, arg2:Number):void
        {
            super.setWH(arg1, arg2);
            this.title.tf.width = arg1 + left + right;
            return;
        }

        internal var title:sliz.miniui.Title;
    }
}


