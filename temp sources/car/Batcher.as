package com.codechiev.car
{
    import flash.errors.*;
    import flash.events.*;
    import fr.digitas.flowearth.command.*;
    import fr.digitas.flowearth.command.traverser.*;
    import fr.digitas.flowearth.core.*;
    import fr.digitas.flowearth.event.*;

    public class Batcher extends EventDispatcher implements IProgressor, IBatchable
    {
        public var failOnError:Boolean = false;
        private var _traverser:IBatchTraverser;
        private var _statusMessage:String;
        private var _batch:Batch;
        private var _item:IBatchable;
        private var _isRunning:Boolean = false;
        private var _run:Boolean = false;
        private var _startLen:Number = -1;

        public function Batcher()
        {
            this._traverser = nullTraverser;
            this._batch = new Batch();
            return;
        }// end function

        public function set type(param1:Number) : void
        {
            this._batch.type = param1;
            return;
        }// end function

        public function get type() : Number
        {
            return this._batch.type;
        }// end function

        public function set traverser(param1:IBatchTraverser) : void
        {
            if (param1 == null)
            {
                throw new Error("fr.digitas.flowearth.command.Batcher - traverser cannot be set to \'null\'");
            }
            this._traverser = param1;
            return;
        }// end function

        public function get traverser() : IBatchTraverser
        {
            return this._traverser;
        }// end function

        public function getCurrentItem() : IBatchable
        {
            return this._item;
        }// end function

        public function addItem(param1:IBatchable) : void
        {
            if (this._batch.addItem(param1) > -1)
            {
                this.itemAddingIn(param1);
            }
            this.next();
            return;
        }// end function

        public function addItemAt(param1:IBatchable, param2:uint) : void
        {
            var _loc_3:* = this._batch.indexOf(param1) == -1;
            this._batch.addItemAt(param1, param2);
            if (_loc_3)
            {
                this.itemAddingIn(param1);
            }
            this.next();
            return;
        }// end function

        public function removeItem(param1:IBatchable) : int
        {
            var _loc_2:* = this._batch.removeItem(param1);
            if (_loc_2 > -1)
            {
                this.itemRemoving(param1);
            }
            return _loc_2;
        }// end function

        public function removeItemAt(param1:uint) : IBatchable
        {
            var _loc_2:* = this._batch.removeItemAt(param1);
            if (_loc_2)
            {
                this.itemRemoving(_loc_2);
            }
            return _loc_2;
        }// end function

        public function setItemIndex(param1:IBatchable, param2:uint) : void
        {
            this._batch.setItemIndex(param1, param2);
            return;
        }// end function

        public function swapItems(param1:IBatchable, param2:IBatchable) : void
        {
            this._batch.swapItems(param1, param2);
            return;
        }// end function

        public function swapItemsAt(param1:uint, param2:uint) : void
        {
            this._batch.swapItemsAt(param1, param2);
            return;
        }// end function

        public function indexOf(param1:IBatchable, param2:int = 0) : int
        {
            return this._batch.indexOf(param1, param2);
        }// end function

        public function getItemAt(param1:uint) : IBatchable
        {
            return this._batch.getItemAt(param1);
        }// end function

        public function replaceItem(param1:IBatchable, param2:IBatchable) : void
        {
            if (param2 == null)
            {
                this.removeItem(param1);
            }
            else if (this._batch.replaceItem(param1, param2))
            {
                this.itemAddingIn(param2);
                this.itemRemoving(param1);
            }
            return;
        }// end function

        public function getIterator() : IIterator
        {
            return new Iterator(this._batch.array());
        }// end function

        public function get statusMessage() : String
        {
            return this._statusMessage;
        }// end function

        public function set statusMessage(param1:String) : void
        {
            this._statusMessage = param1;
            return;
        }// end function

        public function start() : void
        {
            this._startLen = this._getChildsLenght();
            if (this._run)
            {
                return;
            }
            addEventListener(BatchEvent.START, this.onDispatchStart, false, int.MAX_VALUE);
            this._run = true;
            this.sendOpen(new Event(Event.OPEN));
            this.next();
            return;
        }// end function

        public function stop() : void
        {
            var _loc_1:* = this._run;
            this._run = false;
            removeEventListener(BatchEvent.START, this.onDispatchStart);
            if (_loc_1)
            {
                dispatchEvent(new BatchEvent(BatchEvent.STOP, this, this));
            }
            return;
        }// end function

        public function get run() : Boolean
        {
            return this._run;
        }// end function

        public function dispose() : void
        {
            while (this._batch.hasNext())
            {
                
                this._batch.next();
            }
            if (this._item != null)
            {
                this.unregisterItem(this._item);
                this._item.dispose();
            }
            dispatchEvent(new BatchEvent(BatchEvent.DISPOSED, this));
            return;
        }// end function

        public function get weight() : Number
        {
            if (this._startLen < 0)
            {
                this._startLen = this._getChildsLenght();
            }
            return this._startLen;
        }// end function

        public function scan(param1:IBatchTraverser) : IBatchable
        {
            var _loc_3:IBatchable = null;
            var _loc_2:* = param1.enter(this);
            if (this._item is Batcher)
            {
                (this._item as Batcher).scan(param1);
            }
            else if (this._item)
            {
                param1.item(this._item);
            }
            var _loc_4:* = this._batch.array();
            var _loc_5:Number = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                _loc_3 = _loc_4[_loc_5];
                if (_loc_3 is Batcher)
                {
                    this.replaceItem(_loc_3, (_loc_3 as Batcher).scan(param1));
                }
                else
                {
                    this.replaceItem(_loc_3, param1.item(_loc_3));
                }
                _loc_5 = _loc_5 + 1;
            }
            param1.leave(this);
            return _loc_2;
        }// end function

        function _getChildsLenght() : uint
        {
            var _loc_1:uint = 0;
            var _loc_2:Number = 0;
            while (_loc_2 < this._batch.length)
            {
                
                _loc_1 = _loc_1 + this._batch.getItemAt(_loc_2).weight;
                _loc_2 = _loc_2 + 1;
            }
            if (this._item)
            {
                _loc_1 = _loc_1 + this._item.weight;
            }
            return _loc_1;
        }// end function

        private function next() : void
        {
            if (this._isRunning || !this._run)
            {
                return;
            }
            var _loc_1:* = this._batch.hasNext();
            this._isRunning = this._batch.hasNext();
            if (_loc_1)
            {
                this._item = IBatchable(this._batch.next());
                this._item = this.integrateTraverser(this._item);
                if (!this._item)
                {
                    this.next();
                }
                this.registerItem(this._item);
                this._executeItem(this._item);
            }
            else
            {
                this._item = null;
                this.sendComplete(new Event(Event.COMPLETE));
            }
            return;
        }// end function

        private function _executeItem(param1:IBatchable) : void
        {
            if (!param1.dispatchEvent(new BatchEvent(BatchEvent.START, param1, param1, false, true)))
            {
                param1.dispose();
            }
            else
            {
                param1.execute();
            }
            return;
        }// end function

        private function registerItem(param1:IBatchable) : void
        {
            param1.addEventListener(Event.COMPLETE, this.onItemComplete);
            param1.addEventListener(BatchEvent.START, this.onItemStart);
            param1.addEventListener(BatchEvent.ITEM_COMPLETE, this.onSubComplete);
            param1.addEventListener(BatchEvent.ITEM_START, this.onSubItemStart);
            param1.addEventListener(BatchEvent.DISPOSED, this.onCurrentItemDisposed);
            param1.addEventListener(BatchEvent.ITEM_ADDED, this.onSubAdded);
            param1.addEventListener(BatchEvent.ITEM_REMOVED, this.onSubRemoved);
            param1.addEventListener(StatusEvent.STATUS, this.onItemStatus);
            param1.addEventListener(BatchErrorEvent.ERROR, this.onItemError);
            param1.addEventListener(ProgressEvent.PROGRESS, this.onItemProgress);
            return;
        }// end function

        private function unregisterItem(param1:IBatchable) : void
        {
            param1.removeEventListener(Event.COMPLETE, this.onItemComplete);
            param1.removeEventListener(BatchEvent.START, this.onItemStart);
            param1.removeEventListener(BatchEvent.ITEM_COMPLETE, this.onSubComplete);
            param1.removeEventListener(BatchEvent.ITEM_START, this.onSubItemStart);
            param1.removeEventListener(BatchEvent.DISPOSED, this.onCurrentItemDisposed);
            param1.removeEventListener(BatchEvent.ITEM_ADDED, this.onSubAdded);
            param1.removeEventListener(BatchEvent.ITEM_REMOVED, this.onSubRemoved);
            param1.removeEventListener(StatusEvent.STATUS, this.onItemStatus);
            param1.removeEventListener(BatchErrorEvent.ERROR, this.onItemError);
            param1.removeEventListener(ProgressEvent.PROGRESS, this.onItemProgress);
            return;
        }// end function

        private function itemAddingIn(param1:IBatchable) : void
        {
            if (this._startLen > 0)
            {
                this._startLen = this._startLen + param1.weight;
            }
            param1.dispatchEvent(new BatchEvent(BatchEvent.ADDED, this, param1));
            param1.addEventListener(BatchEvent.ADDED, this.itemAddingOut);
            param1.addEventListener(BatchEvent.DISPOSED, this.onItemDisposed);
            dispatchEvent(new BatchEvent(BatchEvent.ITEM_ADDED, param1, this));
            return;
        }// end function

        private function itemAddingOut(event:BatchEvent) : void
        {
            var _loc_2:* = event.target as IBatchable;
            if (_loc_2 == this._item)
            {
                throw new IllegalOperationError("Batcher try to remove the currently running IBatchable.");
            }
            this.removeItem(_loc_2);
            return;
        }// end function

        private function itemRemoving(param1:IBatchable) : void
        {
            if (this._item != param1 && this._startLen > 0)
            {
                this._startLen = this._startLen - param1.weight;
            }
            param1.dispatchEvent(new BatchEvent(BatchEvent.REMOVED, this, param1));
            param1.removeEventListener(BatchEvent.ADDED, this.itemAddingOut);
            param1.removeEventListener(BatchEvent.DISPOSED, this.onItemDisposed);
            dispatchEvent(new BatchEvent(BatchEvent.ITEM_REMOVED, param1, this));
            return;
        }// end function

        private function onDispatchStart(event:BatchEvent) : void
        {
            event.stopImmediatePropagation();
            return;
        }// end function

        private function integrateTraverser(param1:IBatchable) : IBatchable
        {
            var _loc_2:Batcher = null;
            if (param1 is Batcher)
            {
                _loc_2 = param1 as Batcher;
                _loc_2.traverser = _loc_2.traverser.add(this.traverser);
                return this.traverser.enter(_loc_2);
            }
            return this.traverser.item(this._item);
        }// end function

        protected function flushItem() : void
        {
            if (this.traverser && this._item is Batcher)
            {
                this.traverser.leave(this._item as Batcher);
            }
            if (this._item)
            {
                this.unregisterItem(this._item);
                this.itemRemoving(this._item);
            }
            this._isRunning = false;
            this.next();
            return;
        }// end function

        protected function onItemComplete(event:Event) : void
        {
            dispatchEvent(new BatchEvent(BatchEvent.ITEM_COMPLETE, this._item, this, true));
            this.flushItem();
            return;
        }// end function

        protected function onItemDisposed(event:BatchEvent) : void
        {
            var _loc_2:* = event.currentTarget as IBatchable;
            this.removeItem(_loc_2);
            return;
        }// end function

        protected function onCurrentItemDisposed(event:BatchEvent) : void
        {
            this.flushItem();
            return;
        }// end function

        protected function onItemStart(event:BatchEvent) : void
        {
            if (!dispatchEvent(new BatchEvent(BatchEvent.ITEM_START, this._item, this, true, true)))
            {
                event.preventDefault();
            }
            return;
        }// end function

        protected function onItemProgress(event:ProgressEvent) : void
        {
            var _loc_2:* = event.currentTarget as IBatchable;
            var _loc_3:* = this.weight;
            var _loc_4:* = event.bytesLoaded / event.bytesTotal * (_loc_2.weight / _loc_3) + 1 - this._getChildsLenght() / _loc_3;
            this.sendProgress(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _loc_4 * 10000, 10000));
            return;
        }// end function

        protected function onItemError(event:ErrorEvent) : void
        {
            var _loc_2:* = BatchErrorEvent.getAdapter(event);
            if (_loc_2.failOnError || this.failOnError)
            {
                this.stop();
            }
            this.sendError(new BatchErrorEvent(ErrorEvent.ERROR, _loc_2.item, _loc_2.text, _loc_2.failOnError || this.failOnError));
            if (!(this._item is Batcher))
            {
                if (hasEventListener(BatchErrorEvent.ITEM_ERROR))
                {
                    this.sendError(new BatchErrorEvent(BatchErrorEvent.ITEM_ERROR, this._item, _loc_2.text, _loc_2.failOnError, false));
                }
                this.flushItem();
            }
            return;
        }// end function

        protected function onItemStatus(event:StatusEvent) : void
        {
            this.sendStatus(new BatchStatusEvent(StatusEvent.STATUS, event.target as IBatchable, this._statusMessage, event.code));
            return;
        }// end function

        protected function onSubItemStart(event:BatchEvent) : void
        {
            if (!dispatchEvent(event))
            {
                event.preventDefault();
            }
            return;
        }// end function

        protected function onSubComplete(event:BatchEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        protected function onSubAdded(event:BatchEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        protected function onSubRemoved(event:BatchEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendStatus(event:StatusEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendProgress(event:ProgressEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendError(event:ErrorEvent) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendOpen(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function sendComplete(event:Event) : void
        {
            dispatchEvent(event);
            return;
        }// end function

        public function execute() : void
        {
            this.start();
            return;
        }// end function

    }
}
