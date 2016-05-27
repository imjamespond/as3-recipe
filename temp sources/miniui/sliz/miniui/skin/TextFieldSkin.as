package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    
    public class TextFieldSkin extends sliz.miniui.skin.SkinCore
    {
        public function TextFieldSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
        {
            super();
            this.target = arg1;
            this.bg = arg2;
            return;
        }

        protected var target:flash.text.TextField;

        protected var bg:flash.display.Sprite;
    }
}


