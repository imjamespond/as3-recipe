package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    import sliz.miniui.*;
    
    public class InputSkin extends sliz.miniui.skin.TextFieldSkin
    {
        public function InputSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
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
                {
                    target.borderColor = 5739711;
                    target.filters = [sliz.miniui.skin.Style.inputFilter, sliz.miniui.skin.Style.glowDownFIlter];
                    target.textColor = 0;
                    if ((bg as sliz.miniui.Input).isWaitInput) 
                    {
                        target.text = "";
                    }
                    break;
                }
                case 1:
                {
                    target.borderColor = 10066329;
                    target.filters = [sliz.miniui.skin.Style.inputFilter];
                    target.textColor = 0;
                    break;
                }
                case 2:
                {
                    target.textColor = 10066329;
                    target.text = (bg as sliz.miniui.Input).defText;
                }
            }
            return;
        }

        public override function init():void
        {
            target.defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
            target.border = true;
            target.borderColor = 10066329;
            target.background = true;
            target.backgroundColor = 16777215;
            target.textColor = 0;
            target.filters = [sliz.miniui.skin.Style.inputFilter];
            return;
        }
    }
}


