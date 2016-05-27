package sliz.miniui 
{
    import flash.display.*;
    
    public class LabelInput extends flash.display.Sprite
    {
        public function LabelInput(arg1:String, arg2:String="input text", arg3:flash.display.DisplayObjectContainer=null, arg4:Number=0, arg5:Number=0, arg6:Number=100, arg7:Function=null)
        {
            super();
            this.label = new sliz.miniui.Label(arg1, this);
            this.input = new sliz.miniui.Input("", arg2, this, arg7, this.label.width + 5, 0, arg6);
            this.x = arg4;
            this.y = arg5;
            if (arg3) 
            {
                arg3.addChild(this);
            }
            return;
        }

        public function getValue():String
        {
            return this.input.text;
        }

        public function setValue(arg1:String):void
        {
            this.input.text = arg1;
            return;
        }

        internal var label:sliz.miniui.Label;

        internal var input:sliz.miniui.Input;
    }
}


