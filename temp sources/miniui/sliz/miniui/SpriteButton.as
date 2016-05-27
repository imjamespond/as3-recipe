package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class SpriteButton extends sliz.miniui.core.SkinAbleSprite
    {
        public function SpriteButton(arg1:Number=0, arg2:Number=0, arg3:flash.display.DisplayObjectContainer=null, arg4:Function=null)
        {
            var loc1:*=null;
            if (sliz.miniui.core.UIManager.spriteSkin == null) 
            {
                loc1 = new sliz.miniui.skin.SpriteSkin(this);
            }
            else 
            {
                loc1 = new sliz.miniui.core.UIManager.spriteSkin(this);
            }
            super(loc1);
            this.x = arg1;
            this.y = arg2;
            if (arg3) 
            {
                arg3.addChild(this);
            }
            loc1.init();
            this.addMouseEffect();
            if (arg4 != null) 
            {
                addEventListener(flash.events.MouseEvent.CLICK, arg4);
            }
            return;
        }

        public function addMouseEffect():void
        {
            addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.btnOut);
            addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.btnOver);
            return;
        }

        public function removeMouseEffect():void
        {
            removeEventListener(flash.events.MouseEvent.MOUSE_OUT, this.btnOut);
            removeEventListener(flash.events.MouseEvent.MOUSE_OVER, this.btnOver);
            if (stage) 
            {
                stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.btnUp);
            }
            return;
        }

        internal function btnOver(arg1:flash.events.MouseEvent):void
        {
            this.isOver = true;
            this.updateButtonEffect();
            addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.btnDown);
            stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.btnUp);
            return;
        }

        internal function btnOut(arg1:flash.events.MouseEvent):void
        {
            this.isOver = false;
            this.updateButtonEffect();
            removeEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.btnDown);
            return;
        }

        internal function btnDown(arg1:flash.events.MouseEvent):void
        {
            this.isPressed = true;
            this.updateButtonEffect();
            return;
        }

        internal function btnUp(arg1:flash.events.MouseEvent):void
        {
            this.isPressed = false;
            this.updateButtonEffect();
            return;
        }

        public function setEnabled(arg1:Boolean):void
        {
            mouseEnabled = arg1;
            this.updateButtonEffect();
            return;
        }

        protected function updateButtonEffect():void
        {
            if (mouseEnabled) 
            {
                if (!this.isOver && !this.isPressed) 
                {
                    setState(0);
                }
                else if (!this.isOver && this.isPressed) 
                {
                    setState(2);
                }
                else if (this.isOver && !this.isPressed) 
                {
                    setState(1);
                }
                else 
                {
                    setState(3);
                }
            }
            else 
            {
                setState(4);
            }
            return;
        }

        protected var state:int;

        protected var isPressed:Boolean=false;

        protected var isOver:Boolean=false;
    }
}


