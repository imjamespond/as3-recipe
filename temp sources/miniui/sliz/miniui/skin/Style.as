package sliz.miniui.skin 
{
    import flash.filters.*;
    import flash.text.*;
    
    public class Style extends Object
    {
        public function Style()
        {
            super();
            return;
        }

        public static const inputFilter:flash.filters.DropShadowFilter=new flash.filters.DropShadowFilter(2, 45, 10066329, 1, 2, 2, 1, 3, true);

        public static const btnFilter:flash.filters.BevelFilter=new flash.filters.BevelFilter(20, 90, 16777215, 1, 0, 1, 0, 15, 1, 2);

        public static const btnOverFilter:flash.filters.BevelFilter=new flash.filters.BevelFilter(20, 90, 16777215, 1, 2908811, 1, 0, 15, 1, 2);

        public static const btnDownFilter:flash.filters.BevelFilter=new flash.filters.BevelFilter(0, 90, 0, 1, 0, 1, 0, 2, 1, 2);

        public static const glowOverFilter:flash.filters.GlowFilter=new flash.filters.GlowFilter(16776960, 1, 3, 3, 1, 3);

        public static const glowDownFIlter:flash.filters.GlowFilter=new flash.filters.GlowFilter(10066176, 1, 2, 2, 1, 3);

        public static const shadow:flash.filters.DropShadowFilter=new flash.filters.DropShadowFilter(2, 45, 10066329, 1, 4, 4, 1, 3);

        public static const gary:flash.filters.ColorMatrixFilter=new flash.filters.ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);

        public static const btnTfm:flash.text.TextFormat=new flash.text.TextFormat("宋体", null, null, false);

        public static const boldTfm:flash.text.TextFormat=new flash.text.TextFormat("宋体", null, null, true);
    }
}


