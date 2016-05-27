package com.codechiev.car
{
    import flash.events.*;
    import fr.digitas.flowearth.command.*;
    import fr.digitas.flowearth.event.*;

    final public class BatchEvent extends Event implements IBatchEvent
    {
        private var _item:IBatchable;
        private var _target:IBatchable;
        public static const START:String = "fdf_bStart";
        public static const STOP:String = "fdf_bStop";
        public static const ITEM_START:String = "fdf_bitemStart";
        public static const ITEM_COMPLETE:String = "fdf_bitemComplete";
        public static const DISPOSED:String = "fdf_bdisposed";
        public static const ADDED:String = "fdf_baddedToBatch";
        public static const ITEM_ADDED:String = "fdf_bitemaddedToBatch";
        public static const REMOVED:String = "fdf_bremovedFromBatch";
        public static const ITEM_REMOVED:String = "fdf_bitemremovedFromBatch";
        public static const ADDED_TO_GROUP:String = "fdf_addedToGroup";
        public static const REMOVED_FROM_GROUP:String = "fdf_removedFromGroup";

        public function BatchEvent(param1:String, param2:IBatchable, param3:IBatchable = null, param4:Boolean = false, param5:Boolean = false)
        {
            this._target = param3;
            super(param1, param4, param5);
            this._item = param2;
            return;
        }// end function

        public function get item() : IBatchable
        {
            return this._item;
        }// end function

        override public function get target() : Object
        {
            if (this._target)
            {
                return this._target;
            }
            return super.target;
        }// end function

        override public function clone() : Event
        {
            return new BatchEvent(type, this._item, this.target as IBatchable, bubbles, cancelable);
        }// end function

    }
}
