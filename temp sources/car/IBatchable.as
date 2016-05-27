package com.codechiev.car
{
    import flash.events.*;

    public interface IBatchable extends IEventDispatcher, IDisposable
    {

        public function IBatchable();

        function execute() : void;

        function get weight() : Number;

    }
}
