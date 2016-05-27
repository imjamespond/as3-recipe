package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class ScrollBar extends flash.display.Sprite
    {
        public function ScrollBar(arg1:Number=0, arg2:Number=0, arg3:flash.display.DisplayObjectContainer=null, arg4:Number=100, arg5:Number=0, arg6:Function=null)
        {
            super();
            this.x = arg1;
            this.y = arg2;
            if (arg3) 
            {
                arg3.addChild(this);
            }
            if (arg6 != null) 
            {
                addEventListener(flash.events.Event.CHANGE, arg6);
            }
            this.up = new sliz.miniui.SpriteButton(0, 0, this, this.onUp);
            if (sliz.miniui.core.UIManager.scrollBarBtnSkin == null) 
            {
                this.up.setSkin(new sliz.miniui.skin.ScrollBarBtnSkin(this.up));
            }
            else 
            {
                this.up.setSkin(new sliz.miniui.core.UIManager.scrollBarBtnSkin(this.up));
            }
            this.up.updateSkin();
            this.silder = new sliz.miniui.Silder(this.up.width, 0, this, null, null, arg4, arg5, this.onScroll);
            this.silder.y = this.up.height / 2 - this.silder.height / 2;
            this.down = new sliz.miniui.SpriteButton(this.silder.x + this.silder.width, 0, this, this.onDown);
            if (sliz.miniui.core.UIManager.scrollBarBtnSkin == null) 
            {
                this.down.setSkin(new sliz.miniui.skin.ScrollBarBtnSkin(this.down, 1));
            }
            else 
            {
                this.down.setSkin(new sliz.miniui.core.UIManager.scrollBarBtnSkin(this.down, 1));
            }
            this.down.updateSkin();
            if (sliz.miniui.core.UIManager.scrollBarSkin == null) 
            {
                this.silder.setSkin(new sliz.miniui.skin.ScrollBarSkin(this.silder));
            }
            else 
            {
                this.silder.setSkin(new sliz.miniui.core.UIManager.scrollBarSkin(this.silder));
            }
            this.silder.updateSkin();
            if (sliz.miniui.core.UIManager.scrollBarBtnBlackSkin == null) 
            {
                this.silder.setBlackSkin(sliz.miniui.skin.ScrollBarBtnSkin);
            }
            else 
            {
                this.silder.setBlackSkin(sliz.miniui.core.UIManager.scrollBarBtnBlackSkin);
            }
            this.silder.x = this.up.width;
            addEventListener(flash.events.MouseEvent.MOUSE_WHEEL, this.onWheel);
            return;
        }

        internal function onWheel(arg1:flash.events.MouseEvent):void
        {
            this.silder.value = this.silder.value - arg1.delta / 40;
            return;
        }

        internal function onUp(arg1:flash.events.Event):void
        {
            this.silder.value = this.silder.value - 0.1;
            return;
        }

        internal function onDown(arg1:flash.events.Event):void
        {
            this.silder.value = this.silder.value + 0.1;
            return;
        }

        internal function onScroll(arg1:flash.events.Event):void
        {
            dispatchEvent(new flash.events.Event(flash.events.Event.CHANGE));
            return;
        }

        internal var silder:sliz.miniui.Silder;

        internal var up:sliz.miniui.SpriteButton;

        internal var down:sliz.miniui.SpriteButton;
    }
}


