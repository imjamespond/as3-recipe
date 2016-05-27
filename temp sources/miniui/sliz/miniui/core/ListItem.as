package sliz.miniui.core 
{
    import flash.display.*;
    import flash.events.*;
    
    public class ListItem extends flash.events.EventDispatcher
    {
        public function ListItem(arg1:flash.display.DisplayObject, arg2:int=0, arg3:int=0, arg4:Object=null, arg5:Boolean=false)
        {
            super();
            this.display = arg1;
            this.id = arg2;
            this.index = arg3;
            this.data = arg4;
            if (arg5) 
            {
                arg1.addEventListener(flash.events.MouseEvent.CLICK, this.onClick);
            }
            return;
        }

        internal function onClick(arg1:flash.events.MouseEvent):void
        {
            dispatchEvent(new flash.events.Event(flash.events.Event.SELECT));
            return;
        }

        public var display:flash.display.DisplayObject;

        public var id:int;

        public var index:int;

        public var data:Object;
    }
}


