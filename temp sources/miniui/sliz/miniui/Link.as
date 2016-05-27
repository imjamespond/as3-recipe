package sliz.miniui 
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    
    public class Link extends flash.text.TextField
    {
        public function Link(arg1:String, arg2:String="http://game-develop.net/blog/", arg3:Number=0, arg4:Number=0, arg5:flash.display.DisplayObjectContainer=null, arg6:Function=null, arg7:String="a{color:#0000dd;font-family:宋体;}a:hover {color:#0000dd;text-decoration:underline;}")
        {
            super();
            var loc1:*;
            (loc1 = new flash.text.StyleSheet()).parseCSS(arg7);
            styleSheet = loc1;
            autoSize = flash.text.TextFieldAutoSize.LEFT;
            this.x = arg3;
            this.y = arg4;
            if (arg5) 
            {
                arg5.addChild(this);
            }
            if (arg6 != null) 
            {
                addEventListener(flash.events.TextEvent.LINK, arg6);
            }
            htmlText = "<a href=\'" + arg2 + "\' target=\'_blank\'>" + arg1 + "</a>";
            return;
        }
    }
}


