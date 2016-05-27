package sliz.utils 
{
    import flash.display.*;
    
    public class UIUtils extends Object
    {
        public function UIUtils()
        {
            super();
            return;
        }

        public static function changeStage(arg1:flash.display.Stage):void
        {
            arg1.align = flash.display.StageAlign.TOP_LEFT;
            arg1.scaleMode = flash.display.StageScaleMode.NO_SCALE;
            return;
        }
    }
}


