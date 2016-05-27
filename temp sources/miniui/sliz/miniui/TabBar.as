package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.core.*;
    
    public class TabBar extends sliz.miniui.Menu
    {
        public function TabBar(arg1:Array=null, arg2:Number=0, arg3:Number=0, arg4:flash.display.DisplayObjectContainer=null, arg5:Function=null, arg6:Number=-1, arg7:int=1, arg8:Number=-5)
        {
            super(arg1, arg2, arg3, arg6, arg4, arg5, arg7, arg8);
            filters = [];
            return;
        }

        public override function add(arg1:String, arg2:int=0, arg3:Object=null):void
        {
            var loc1:*=new sliz.miniui.TabItem(arg1, menuWidth);
            addChild(loc1);
            list.add(new sliz.miniui.core.ListItem(loc1, 0, 0, {"text":arg1, "id":arg2}, true), -1, true);
            return;
        }

        protected override function onSelect(arg1:flash.events.Event):void
        {
            dispatchEvent(new flash.events.Event(flash.events.Event.SELECT));
            var loc1:*=getSelectItem();
            loc1.display.parent.setChildIndex(loc1.display, (loc1.display.parent.numChildren - 1));
            var loc2:*=loc1.display as sliz.miniui.TabItem;
            loc2.removeMouseEffect();
            loc2.setState(3);
            loc1 = getLastSelectItem();
            if (loc1) 
            {
                loc2 = loc1.display as sliz.miniui.TabItem;
                loc2.addMouseEffect();
                loc2.setState(0);
            }
            return;
        }
    }
}


