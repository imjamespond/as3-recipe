package sliz.miniui 
{
    import flash.events.*;
    
    public class Title extends sliz.miniui.Button
    {
        public function Title(arg1:String, arg2:sliz.miniui.Window=null, arg3:Number=100, arg4:Number=0, arg5:Number=0, arg6:Function=null)
        {
            super(arg1, arg4, arg5, arg2, arg6);
            tf.text = arg1;
            tf.width = arg3;
            tf.wordWrap = true;
            this.window = arg2;
            addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.onMouseDown);
            return;
        }

        internal function onMouseDown(arg1:flash.events.MouseEvent):void
        {
            this.sx = this.window.x - stage.mouseX;
            this.sy = this.window.y - stage.mouseY;
            stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.onMouseUp);
            return;
        }

        internal function onMouseMove(arg1:flash.events.MouseEvent):void
        {
            if (stage.mouseX < 0 || stage.mouseY < 0 || stage.mouseX > stage.stageWidth || stage.mouseY > stage.stageHeight) 
            {
                return;
            }
            this.window.x = stage.mouseX + this.sx;
            this.window.y = stage.mouseY + this.sy;
            arg1.updateAfterEvent();
            return;
        }

        internal function onMouseUp(arg1:flash.events.MouseEvent):void
        {
            stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.onMouseMove);
            stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.onMouseUp);
            return;
        }

        internal var window:sliz.miniui.Window;

        internal var sx:Number;

        internal var sy:Number;
    }
}


