package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    
    public class TextListSkin extends sliz.miniui.skin.ButtonCoreSkin
    {
        public function TextListSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
        {
            super(arg1, arg2);
            return;
        }

        public override function setState(arg1:int):void
        {
            this.state = arg1;
            var loc1:*=arg1;
            switch (loc1) 
            {
                case 0:
                case 2:
                {
                    target.borderColor = 16119285;
                    break;
                }
                case 1:
                {
                    target.borderColor = 10526880;
                    break;
                }
                case 3:
                {
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 4:
                {
                    target.textColor = loc1 = 11184810;
                    target.borderColor = loc1;
                    break;
                }
            }
            return;
        }

        public override function init():void
        {
            target.filters = [];
            target.autoSize = flash.text.TextFieldAutoSize.NONE;
            target.backgroundColor = 16777215;
            return;
        }
    }
}


