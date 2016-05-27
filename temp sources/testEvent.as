package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class testEvent extends Sprite
	{
		public function testEvent()
		{
			var myEventDispatcher:myEventDispatcher_=new myEventDispatcher_();
			myEventDispatcher.addEventListener(myEventDispatcher_.TRIGGER1,myEventHandle);
			
			myEventDispatcher.trigger();
		}
		
		private function myEventHandle(e:myEvent_):void
		{
			trace(e);
			trace(e.mySth);
		}
	}
}
import flash.events.Event;
import flash.events.EventDispatcher;
class myEventDispatcher_ extends EventDispatcher 
{
	public static const TRIGGER1:String	= "hehe";
	public function myEventDispatcher_()
	{
	}
	
	public function trigger():void
	{
		//this.dispatchEvent(new Event(myEventDispatcher_.TRIGGER));
		var myEvent:myEvent_	= new myEvent_(myEventDispatcher_.TRIGGER1);
		myEvent.mySth			= "i gonna say something but wont do any thing!";
		this.dispatchEvent(myEvent);
	}
}

class myEvent_ extends Event
{
	private var sthStr:String;
	
	public function myEvent_(trigger:String)
	{
		super(trigger);
	}
	
	public function set mySth(str:String):void
	{
		this.sthStr		= str;
	}
	
	public function get mySth():String
	{
		return 	sthStr;
	}
}