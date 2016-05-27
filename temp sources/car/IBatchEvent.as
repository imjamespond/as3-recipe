package fr.digitas.flowearth.event
{
    import fr.digitas.flowearth.command.*;
    import fr.digitas.flowearth.event.*;

    public interface IBatchEvent extends IEvent
    {

        public function IBatchEvent();

        function get item() : IBatchable;

    }
}
