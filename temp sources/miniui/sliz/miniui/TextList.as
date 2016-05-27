package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class TextList extends sliz.miniui.Button
    {
        public function TextList(arg1:Array=null, arg2:Number=0, arg3:Number=0, arg4:Number=100, arg5:flash.display.DisplayObjectContainer=null, arg6:Function=null)
        {
            var loc1:*="";
            super(loc1, arg2, arg3, arg5, this.onClick);
            if (sliz.miniui.core.UIManager.textListSkin == null) 
            {
                setSkin(new sliz.miniui.skin.TextListSkin(tf, this));
            }
            else 
            {
                setSkin(new sliz.miniui.core.UIManager.textListSkin(tf, this));
            }
            tf.width = arg4;
            getSkin().init();
            if (arg6 != null) 
            {
                addEventListener(flash.events.Event.SELECT, arg6);
            }
            this.menu = new sliz.miniui.Menu(arg1, 0, 0, arg4, null, this.onSelect);
            if (arg1 && arg1.length) 
            {
                this.select(0);
            }
            return;
        }

        internal function onSelect(arg1:flash.events.Event):void
        {
            tf.text = "  " + this.menu.getSelectItem().data.text + "  ";
            dispatchEvent(new flash.events.Event(flash.events.Event.SELECT));
            return;
        }

        internal function onClick(arg1:flash.events.Event):void
        {
            if (this.menu.parent) 
            {
                this.hideMenuNextFrame();
            }
            else 
            {
                this.showMenuNextFrame();
            }
            return;
        }

        public function showMenu():void
        {
            var loc1:*=null;
            if (stage) 
            {
                stage.addChild(this.menu);
                stage.addEventListener(flash.events.MouseEvent.CLICK, this.clickStage);
                loc1 = localToGlobal(new flash.geom.Point(0, height));
                this.menu.x = loc1.x;
                this.menu.y = Math.min(loc1.y, stage.stageHeight - this.menu.height);
            }
            return;
        }

        public function hideMenu():void
        {
            if (this.menu.parent) 
            {
                this.menu.parent.removeChild(this.menu);
            }
            return;
        }

        internal function showMenuNextFrame():void
        {
            this.isMenuShow = true;
            addEventListener(flash.events.Event.ENTER_FRAME, this.onMenuChange);
            return;
        }

        internal function hideMenuNextFrame():void
        {
            this.isMenuShow = false;
            addEventListener(flash.events.Event.ENTER_FRAME, this.onMenuChange);
            return;
        }

        internal function clickStage(arg1:flash.events.MouseEvent):void
        {
            stage.removeEventListener(flash.events.MouseEvent.CLICK, this.clickStage);
            this.hideMenuNextFrame();
            return;
        }

        internal function onMenuChange(arg1:flash.events.Event):void
        {
            removeEventListener(flash.events.Event.ENTER_FRAME, this.onMenuChange);
            if (this.isMenuShow) 
            {
                this.showMenu();
            }
            else 
            {
                this.hideMenu();
            }
            return;
        }

        public function add(arg1:String, arg2:int=0):void
        {
            this.menu.add(arg1, arg2);
            return;
        }

        public function reset(arg1:Array):void
        {
            this.menu.reset(arg1);
            return;
        }

        public function getItem(arg1:int):sliz.miniui.core.ListItem
        {
            return this.menu.getItem(arg1);
        }

        public function getSelectItem():sliz.miniui.core.ListItem
        {
            return this.menu.getSelectItem();
        }

        public function getLastSelectItem():sliz.miniui.core.ListItem
        {
            return this.menu.getLastSelectItem();
        }

        public function select(arg1:int):void
        {
            this.menu.select(arg1);
            return;
        }

        internal var menu:sliz.miniui.Menu;

        internal var isMenuShow:Boolean=false;
    }
}


