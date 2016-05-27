package com.codechiev.juke
{
    import flash.display.*;
    import flash.geom.*;
    import flash.ui.*;

    public class Cursors extends Object
    {
        private static var _cursors:BitmapData;
        public static const FINGER:String = "finger";
        public static const OPEN_HAND:String = "openhand";
        public static const CLOSED_HAND:String = "closedhand";
        public static const COLOR:String = "custom_colorpicker";
        private static const NULLPOINT:Point = new Point();

        public function Cursors()
        {
            return;
        }// end function

        public static function getOpenHand() : MouseCursorData
        {
            var _loc_1:* = new MouseCursorData();
            var _loc_2:* = new BitmapData(32, 32, true, 0);
            _loc_2.copyPixels(_cursors, new Rectangle(0, 32, 32, 32), NULLPOINT);
            _loc_1.data = new Vector.<BitmapData>(1, true);
            _loc_1.data[0] = _loc_2;
            _loc_1.hotSpot = new Point(14, 16);
            return _loc_1;
        }// end function

        public static function getClosedHand() : MouseCursorData
        {
            var _loc_1:* = new MouseCursorData();
            var _loc_2:* = new BitmapData(32, 32, true, 0);
            _loc_2.copyPixels(_cursors, new Rectangle(32, 32, 32, 32), NULLPOINT);
            _loc_1.data = new Vector.<BitmapData>(1, true);
            _loc_1.data[0] = _loc_2;
            _loc_1.hotSpot = new Point(14, 16);
            return _loc_1;
        }// end function

        public static function getColorpickCursor() : MouseCursorData
        {
            var _loc_1:* = new MouseCursorData();
            var _loc_2:* = new BitmapData(32, 32, true, 0);
            _loc_2.copyPixels(_cursors, new Rectangle(0, 0, 32, 32), NULLPOINT);
            _loc_1.data = new Vector.<BitmapData>(1, true);
            _loc_1.data[0] = _loc_2;
            _loc_1.hotSpot = new Point(2, 2);
            return _loc_1;
        }// end function

        public static function getFinger() : MouseCursorData
        {
            var _loc_1:* = new MouseCursorData();
            var _loc_2:* = new BitmapData(32, 32, true, 0);
            _loc_2.copyPixels(_cursors, new Rectangle(32, 0, 32, 32), NULLPOINT);
            _loc_1.data = new Vector.<BitmapData>(1, true);
            _loc_1.data[0] = _loc_2;
            _loc_1.hotSpot = new Point(14, 17);
            return _loc_1;
        }// end function

        public static function getWheel() : MouseCursorData
        {
            var _loc_1:* = new MouseCursorData();
            var _loc_2:* = new BitmapData(32, 32, true, 0);
            _loc_2.copyPixels(_cursors, new Rectangle(64, 0, 32, 32), NULLPOINT);
            _loc_1.data = new Vector.<BitmapData>(1, true);
            _loc_1.data[0] = _loc_2;
            _loc_1.hotSpot = new Point(14, 17);
            return _loc_1;
        }// end function

        public static function init() : void
        {
            //FIXME _cursors = new Assets.Icons().bitmapData;
            Mouse.registerCursor(OPEN_HAND, getOpenHand());
            Mouse.registerCursor(CLOSED_HAND, getClosedHand());
            Mouse.registerCursor(FINGER, getFinger());
            Mouse.registerCursor(COLOR, getColorpickCursor());
            return;
        }// end function

    }
}
