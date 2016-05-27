package com.codechiev.car
{
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import fr.digitas.flowearth.command.*;
    import fr.digitas.flowearth.event.*;

    public class BinaryResources extends Object
    {
        private static var _bins:Dictionary = new Dictionary();

        public function BinaryResources()
        {
            return;
        }// end function

        public static function getResource(param1:String) : ByteArray
        {
            var _loc_2:* = _bins[param1];
            if (_loc_2 == null)
            {
                throw new Error("fr.digitas.jexplorer.resources.BinaryResources - getResource : ");
            }
            return _bins[param1];
        }// end function

        public static function getLoadables(param1:XML) : IBatchable
        {
            var _loc_4:CustomItem = null;
            var _loc_5:XML = null;
            var _loc_2:* = new Batcher();
            var _loc_3:* = param1.file;
            for each (_loc_5 in _loc_3)
            {
                
                _loc_4 = new CustomItem(new URLRequest(_loc_5.text()), String(_loc_5.@id));
                _loc_4.dataFormat = URLLoaderDataFormat.BINARY;
                _loc_2.addItem(_loc_4);
            }
            _loc_2.addEventListener(BatchEvent.ITEM_COMPLETE, onItemComplete);
            _loc_2.addEventListener(Event.COMPLETE, onBatchComplete);
            return _loc_2;
        }// end function

        private static function onBatchComplete(event:Event) : void
        {
            var _loc_2:* = event.currentTarget as Batcher;
            _loc_2.removeEventListener(Event.COMPLETE, onBatchComplete);
            _loc_2.removeEventListener(BatchEvent.ITEM_COMPLETE, onItemComplete);
            return;
        }// end function

        private static function onItemComplete(event:BatchEvent) : void
        {
            var _loc_2:* = event.item as CustomItem;
            var _loc_3:* = _loc_2.params as String;
            _bins[_loc_3] = _loc_2.data;
            return;
        }// end function

    }
}
import flash.net.URLRequest;
import com.codechiev.car.BatchURLLoaderItem;
import flash.events.ProgressEvent;

class CustomItem extends BatchURLLoaderItem
{

    function CustomItem(param1:URLRequest, param2:Object = null, param3:String = null, param4:Boolean = false)
    {
        super(param1, param2, param3, param4);
        return;
    }// end function

    override public function sendProgress(event:ProgressEvent) : void
    {
        if (event.bytesTotal == 0)
        {
            event = new ProgressEvent(ProgressEvent.PROGRESS, false, false, 0.5, 1);
        }
        super.sendProgress(event);
        return;
    }// end function

}

