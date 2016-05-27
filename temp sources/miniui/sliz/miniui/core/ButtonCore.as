package sliz.miniui.core 
{
    import flash.display.*;
    import flash.text.*;
    import sliz.miniui.*;
    import sliz.miniui.skin.*;
    
    public class ButtonCore extends sliz.miniui.SpriteButton
    {
        public function ButtonCore(arg1:String, arg2:sliz.miniui.skin.SkinCore=null, arg3:Number=0, arg4:Number=0, arg5:flash.display.DisplayObjectContainer=null, arg6:Function=null)
        {
            this.tf = new flash.text.TextField();
            addChild(this.tf);
            this.tf.text = "  " + arg1 + "  ";
            super(arg3, arg4, arg5, arg6);
            if (arg2 == null) 
            {
                if (sliz.miniui.core.UIManager.buttonCoreSkin == null) 
                {
                    setSkin(new sliz.miniui.skin.ButtonCoreSkin(this.tf, this));
                }
                else 
                {
                    setSkin(new sliz.miniui.core.UIManager.buttonCoreSkin(this.tf, this));
                }
            }
            else 
            {
                setSkin(arg2);
            }
            this.skin.init();
            return;
        }

        public function get text():String
        {
            return this.tf.text;
        }

        public function set text(arg1:String):void
        {
            this.tf.text = arg1;
            return;
        }

        public var tf:flash.text.TextField;
    }
}


