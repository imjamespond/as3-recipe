package sliz.miniui.skin 
{
    import flash.display.*;
    import flash.text.*;
    
    public class RadioSkin extends sliz.miniui.skin.TextFieldSkin
    {
        public function RadioSkin(arg1:flash.text.TextField, arg2:flash.display.Sprite)
        {
            super(arg1, arg2);
            return;
        }

        public override function setState(arg1:int):void
        {
            super.setState(arg1);
            bg.graphics.clear();
            bg.graphics.beginFill(15658734);
            bg.graphics.lineStyle(0);
            bg.graphics.drawCircle(7, 8, 7);
            var loc1:*=arg1;
            switch (loc1) 
            {
                case 0:
                case 2:
                {
                    bg.filters = [sliz.miniui.skin.Style.btnFilter];
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 1:
                {
                    bg.filters = [sliz.miniui.skin.Style.btnOverFilter, sliz.miniui.skin.Style.glowOverFilter];
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 3:
                {
                    bg.graphics.beginFill(0);
                    bg.graphics.drawCircle(7, 8, 3);
                    bg.filters = [sliz.miniui.skin.Style.btnDownFilter, sliz.miniui.skin.Style.glowDownFIlter];
                    target.textColor = loc1 = 0;
                    target.borderColor = loc1;
                    break;
                }
                case 4:
                {
                    bg.filters = [];
                    target.textColor = loc1 = 11184810;
                    target.borderColor = loc1;
                    break;
                }
            }
            return;
        }

        public override function init():void
        {
            bg.graphics.beginFill(15658734);
            bg.graphics.lineStyle(0);
            bg.graphics.drawCircle(7, 8, 7);
            target.filters = [];
            target.x = 14;
            target.autoSize = flash.text.TextFieldAutoSize.LEFT;
            target.setTextFormat(sliz.miniui.skin.Style.btnTfm);
            target.defaultTextFormat = sliz.miniui.skin.Style.btnTfm;
            target.border = false;
            target.background = false;
            target.selectable = false;
            this.setState(0);
            return;
        }
    }
}


