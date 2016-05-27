package sliz.miniui 
{
    import flash.display.*;
    import flash.text.*;
    import sliz.miniui.skin.*;
    
    public class Label extends flash.text.TextField
    {
        public function Label(arg1:String, arg2:flash.display.DisplayObjectContainer=null, arg3:Number=0, arg4:Number=0, arg5:Number=NaN)
        {
            super();
            defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
            textColor = 0;
            autoSize = flash.text.TextFieldAutoSize.LEFT;
            selectable = false;
            mouseWheelEnabled = false;
            this.x = arg3;
            this.y = arg4;
            if (arg5) 
            {
                width = arg5;
                wordWrap = true;
                multiline = true;
            }
            if (arg2) 
            {
                arg2.addChild(this);
            }
            this.text = arg1;
            return;
        }
    }
}


