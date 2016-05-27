package sliz.miniui.core 
{
    import flash.events.*;
    
    public class ListCore extends flash.events.EventDispatcher
    {
        public function ListCore(arg1:Number=0, arg2:int=0, arg3:Number=0, arg4:Number=0, arg5:Number=0)
        {
            super();
            this.items = [];
            this.gap = arg1;
            this.direction = arg2;
            return;
        }

        public function add(arg1:sliz.miniui.core.ListItem, arg2:int=-1, arg3:Boolean=false):void
        {
            var loc1:*=null;
            if (arg2 == -1) 
            {
                arg2 = this.items.length;
            }
            arg2 = Math.min(this.items.length, arg2);
            if (this.direction != 0) 
            {
                arg1.display.x = 0;
                if (loc1 = this.items[(arg2 - 1)]) 
                {
                    arg1.display.x = loc1.display.x + loc1.display.width + this.gap;
                }
            }
            else 
            {
                arg1.display.y = 0;
                if (loc1 = this.items[(arg2 - 1)]) 
                {
                    arg1.display.y = loc1.display.y + loc1.display.height + this.gap;
                }
            }
            arg1.index = arg2;
            this.items.push(arg1);
            if (arg3) 
            {
                arg1.addEventListener(flash.events.Event.SELECT, this.onSelect);
            }
            return;
        }

        public function del(arg1:sliz.miniui.core.ListItem):sliz.miniui.core.ListItem
        {
            var loc2:*=NaN;
            var loc3:*=null;
            var loc4:*=null;
            if (this.direction != 0) 
            {
                loc2 = arg1.display.width + this.gap;
                loc3 = "x";
            }
            else 
            {
                loc2 = arg1.display.height + this.gap;
                loc3 = "y";
            }
            var loc1:*=(this.items.length - 1);
            while (loc1 > arg1.index) 
            {
                (loc4 = this.items[loc1]).display[loc3] = loc4.display[loc3] - loc2;
                var loc5:*;
                var loc6:*=((loc5 = loc4).index - 1);
                loc5.index = loc6;
                --loc1;
            }
            arg1.removeEventListener(flash.events.Event.SELECT, this.onSelect);
            return this.items.splice(arg1.index, 1)[0];
        }

        public function delAt(arg1:int):sliz.miniui.core.ListItem
        {
            var loc1:*=this.items[arg1];
            return this.del(loc1);
        }

        public function move():void
        {
            return;
        }

        public function getItem(arg1:int):sliz.miniui.core.ListItem
        {
            return this.items[arg1];
        }

        public function select(arg1:int):void
        {
            this.selectByItem(this.items[arg1]);
            return;
        }

        internal function selectByItem(arg1:sliz.miniui.core.ListItem):void
        {
            if (arg1 == null) 
            {
                return;
            }
            this.lastSelectItem = this.selectItem;
            this.selectItem = arg1;
            if (this.selectItem != this.lastSelectItem) 
            {
                dispatchEvent(new flash.events.Event(flash.events.Event.SELECT));
            }
            return;
        }

        internal function onSelect(arg1:flash.events.Event):void
        {
            this.selectByItem(arg1.currentTarget as sliz.miniui.core.ListItem);
            return;
        }

        public function getSelectItem():sliz.miniui.core.ListItem
        {
            return this.selectItem;
        }

        public function getLastSelectItem():sliz.miniui.core.ListItem
        {
            return this.lastSelectItem;
        }

        public var items:Array;

        internal var gap:Number;

        internal var direction:int;

        internal var selectItem:sliz.miniui.core.ListItem;

        internal var lastSelectItem:sliz.miniui.core.ListItem;
    }
}


