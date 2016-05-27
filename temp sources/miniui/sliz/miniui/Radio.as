package sliz.miniui 
{
    import flash.display.*;
    import sliz.miniui.core.*;
    import sliz.miniui.skin.*;
    
    public class Radio extends sliz.miniui.ToggleButton
    {
        public function Radio(arg1:String, arg2:Number=0, arg3:Number=0, arg4:flash.display.DisplayObjectContainer=null, arg5:Function=null)
        {
            super(arg1, arg2, arg3, arg4, arg5);
            tf.text = arg1;
            if (sliz.miniui.core.UIManager.radioSkin != null) 
            {
                setSkin(new sliz.miniui.core.UIManager.radioSkin(tf, this));
            }
            else 
            {
                setSkin(new sliz.miniui.skin.RadioSkin(tf, this));
            }
            skin.init();
            return;
        }
    }
}


