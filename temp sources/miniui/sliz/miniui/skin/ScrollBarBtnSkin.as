package sliz.miniui.skin 
{
    import flash.display.*;
    
    public class ScrollBarBtnSkin extends sliz.miniui.skin.SpriteSkin
    {
        public function ScrollBarBtnSkin(arg1:flash.display.Sprite, arg2:int=0, arg3:Number=12, arg4:Number=13)
        {
            this.setWH(arg3, arg4);
            this.type = arg2;
            super(arg1);
            return;
        }

        public function setWH(arg1:Number, arg2:Number):void
        {
            this.width = arg1;
            this.height = arg2;
            return;
        }

        public override function setState(arg1:int):void
        {
            super.setState(arg1);
            target.graphics.clear();
            var loc1:*=15658734;
            var loc2:*=0;
            var loc4:*=arg1;
            switch (loc4) 
            {
                case 0:
                {
                    loc1 = 15658734;
                    loc2 = 0;
                    target.filters = [sliz.miniui.skin.Style.btnFilter];
                    break;
                }
                case 1:
                {
                    loc1 = 15658734;
                    loc2 = 0;
                    target.filters = [sliz.miniui.skin.Style.btnOverFilter, sliz.miniui.skin.Style.glowOverFilter];
                    break;
                }
                case 2:
                {
                    loc1 = 15658734;
                    loc2 = 0;
                    target.filters = [sliz.miniui.skin.Style.btnDownFilter, sliz.miniui.skin.Style.glowDownFIlter];
                    break;
                }
                case 3:
                {
                    loc1 = 11184810;
                    loc2 = 11184810;
                    target.filters = [];
                    break;
                }
            }
            target.graphics.beginFill(loc1);
            target.graphics.lineStyle(1, loc2);
            if (this.type != 2) 
            {
                target.graphics.drawRect(0, 0, this.width, this.height);
            }
            else 
            {
                target.graphics.drawRect((-this.width) / 2, (-this.height) / 2, this.width, this.height);
            }
            target.graphics.lineStyle(1, 3487029);
            target.graphics.beginFill(12040119);
            var loc3:*=2;
            if (this.type != 0) 
            {
                if (this.type == 1) 
                {
                    target.graphics.moveTo(this.width - loc3 * 2, this.height / 2);
                    target.graphics.lineTo(loc3, loc3);
                    target.graphics.lineTo(loc3, this.height - loc3);
                    target.graphics.lineTo(this.width - loc3 * 2, this.height / 2);
                }
            }
            else 
            {
                target.graphics.moveTo(loc3, this.height / 2);
                target.graphics.lineTo(this.width - loc3 * 2, loc3);
                target.graphics.lineTo(this.width - loc3 * 2, this.height - loc3);
                target.graphics.lineTo(loc3, this.height / 2);
            }
            return;
        }

        public override function init():void
        {
            this.setState(0);
            return;
        }

        internal var width:Number;

        internal var height:Number;

        internal var type:int;
    }
}


