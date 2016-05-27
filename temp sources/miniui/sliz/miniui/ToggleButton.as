package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    
    public class ToggleButton extends sliz.miniui.Button
    {
        public function ToggleButton(arg1:String, arg2:Number=0, arg3:Number=0, arg4:flash.display.DisplayObjectContainer=null, arg5:Function=null)
        {
            addEventListener(flash.events.MouseEvent.CLICK, this.onClick);
            super(arg1, arg2, arg3, arg4, arg5);
            return;
        }

        internal function onClick(arg1:flash.events.Event):void
        {
            this.setToggle(!this.toggle);
            return;
        }

        public function setToggle(arg1:Boolean):void
        {
            this.toggle = arg1;
            this.updateButtonEffect();
            return;
        }

        public function getToggle():Boolean
        {
            return this.toggle;
        }

        protected override function updateButtonEffect():void
        {
            super.updateButtonEffect();
            if (mouseEnabled && this.toggle) 
            {
                setState(3);
            }
            return;
        }

        internal var toggle:Boolean=false;
    }
}


