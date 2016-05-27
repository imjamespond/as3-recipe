package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class Menu extends sliz.miniui.core.SkinAbleSprite
    {
        public function Menu(arg1:Array=null, arg2:Number=0, arg3:Number=0, arg4:Number=100, arg5:flash.display.DisplayObjectContainer=null, arg6:Function=null, arg7:int=0, arg8:Number=1)
        {
            var loc1:*=null;
            if (sliz.miniui.core.UIManager.menuSkin == null) 
            {
                loc1 = new sliz.miniui.skin.MenuSkin(this);
            }
            else 
            {
                loc1 = new sliz.miniui.core.UIManager.menuSkin(this);
            }
            super(loc1);
            this.list = new sliz.miniui.core.ListCore(arg8, arg7, 0, arg4);
            this.list.addEventListener(flash.events.Event.SELECT, this.onSelect);
            this.menuWidth = arg4;
            filters = [sliz.miniui.skin.Style.shadow];
            this.reset(arg1);
            this.x = arg2;
            this.y = arg3;
            if (arg5) 
            {
                arg5.addChild(this);
            }
            if (arg6 != null) 
            {
                addEventListener(flash.events.Event.SELECT, arg6);
            }
            return;
        }

        public function add(arg1:String, arg2:int=0, arg3:Object=null):void
        {
            var loc1:*=new sliz.miniui.MenuItem(arg1, this.menuWidth);
            addChild(loc1);
            this.list.add(new sliz.miniui.core.ListItem(loc1, arg2, 0, {"text":arg1, "id":arg2, "data":arg3}, true), -1, true);
            updateSkin();
            return;
        }

        public function delByIndex(arg1:int):void
        {
            var loc1:*=this.list.delAt(arg1);
            removeChild(loc1.display);
            updateSkin();
            return;
        }

        public function delById(arg1:int):void
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=this.list.items;
            for each (loc1 in loc3) 
            {
                if (loc1.id != arg1) 
                {
                    continue;
                }
                this.list.del(loc1);
                removeChild(loc1.display);
                updateSkin();
                return;
            }
            return;
        }

        public function move():void
        {
            return;
        }

        public function reset(arg1:Array):void
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=0;
            var loc5:*=this.list.items;
            for each (loc1 in loc5) 
            {
                if (!(loc1.display && loc1.display.parent)) 
                {
                    continue;
                }
                loc1.display.parent.removeChild(loc1.display);
            }
            this.list.items = [];
            loc2 = 0;
            if (arg1) 
            {
                loc4 = 0;
                loc5 = arg1;
                for each (loc3 in loc5) 
                {
                    this.add(loc3, loc2++);
                }
            }
            return;
        }

        public function getItem(arg1:int):sliz.miniui.core.ListItem
        {
            return this.list.getItem(arg1);
        }

        protected function onSelect(arg1:flash.events.Event):void
        {
            dispatchEvent(new flash.events.Event(flash.events.Event.SELECT));
            return;
        }

        public function getSelectItem():sliz.miniui.core.ListItem
        {
            return this.list.getSelectItem();
        }

        public function getLastSelectItem():sliz.miniui.core.ListItem
        {
            return this.list.getLastSelectItem();
        }

        public function select(arg1:int):void
        {
            this.list.select(arg1);
            return;
        }

        protected var list:sliz.miniui.core.ListCore;

        protected var menuWidth:Number;
    }
}


