package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.core.*;
    
    public class TabPanel extends flash.display.Sprite
    {
        public function TabPanel(arg1:Array=null, arg2:Number=0, arg3:Number=0, arg4:flash.display.DisplayObjectContainer=null, arg5:Function=null, arg6:Number=-1, arg7:int=1, arg8:Number=-5)
        {
            var loc2:*=null;
            var loc3:*=null;
            this.panels = [];
            super();
            this.tabBar = new sliz.miniui.TabBar(arg1, 0, 0, this, arg5, arg6, arg7, arg8);
            this.x = arg2;
            this.y = arg3;
            if (arg4) 
            {
                arg4.addChild(this);
            }
            var loc1:*=height;
            var loc4:*=0;
            var loc5:*=arg1;
            for each (loc2 in loc5) 
            {
                loc3 = new sliz.miniui.Panel();
                this.panels.push(loc3);
                loc3.y = loc1;
            }
            this.tabBar.addEventListener(flash.events.Event.SELECT, this.onSelect);
            this.tabBar.select(0);
            return;
        }

        public function getPanel(arg1:int):sliz.miniui.Panel
        {
            return this.panels[arg1];
        }

        internal function onSelect(arg1:flash.events.Event):void
        {
            var loc1:*=this.tabBar.getLastSelectItem();
            var loc2:*=this.tabBar.getSelectItem();
            if (loc1) 
            {
                removeChild(this.getPanel(loc1.index));
            }
            addChild(this.getPanel(loc2.index));
            return;
        }

        internal var tabBar:sliz.miniui.TabBar;

        internal var panels:Array;
    }
}


