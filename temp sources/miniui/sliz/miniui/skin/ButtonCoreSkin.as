package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    
    public class ButtonCoreSkin extends sliz.miniui.skin.TextFieldSkin
    {
        public function ButtonCoreSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
        {
            super(arg1, arg2);
            return;
        }

        public override function setState(arg1:int):void
        {
            super.setState(arg1);
            var loc1:*=arg1;
            switch (loc1) 
            {
                case 0:
                case 2:
                {
                    target.filters = [sliz.miniui.skin.Style.btnFilter];
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 1:
                {
                    target.filters = [sliz.miniui.skin.Style.btnOverFilter, sliz.miniui.skin.Style.glowOverFilter];
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 3:
                {
                    target.filters = [sliz.miniui.skin.Style.btnDownFilter, sliz.miniui.skin.Style.glowDownFIlter];
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 4:
                {
                    target.filters = [];
                    target.textColor = loc1 = 11184810;
                    target.borderColor = loc1;
                    break;
                }
            }
            return;
        }

        public override function init():void
        {
            target.autoSize = flash.text.TextFieldAutoSize.LEFT;
            target.setTextFormat(sliz.miniui.skin.Style.btnTfm);
            target.defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
            target.border = true;
            target.borderColor = 0;
            target.background = true;
            target.backgroundColor = 15658734;
            target.selectable = false;
            target.textColor = 0;
            this.setState(0);
            return;
        }
    }
}


