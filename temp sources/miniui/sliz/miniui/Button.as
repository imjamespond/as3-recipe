package sliz.miniui
{
    import flash.display.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class Button extends sliz.miniui.core.ButtonCore
    {
        public function Button(arg1:String, arg2:Number=0, arg3:Number=0, arg4:flash.display.DisplayObjectContainer=null, arg5:Function=null, arg6:sliz.miniui.skin.SkinCore=null)
        {
            super(arg1, arg6, arg2, arg3, arg4, arg5);
            addMouseEffect();
            return;
        }
    }
}


