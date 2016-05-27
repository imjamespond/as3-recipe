package
{
	import com.codechiev._2d.MovieClipController;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	[SWF(width='1024', height='768', frameRate='24', backgroundColor='#000000')]
	public class BirdsTest extends Sprite
	{
		private var mcControl:MovieClipController;
		public function BirdsTest()
		{
			var myLoader:Loader = new Loader();  
			var url:URLRequest = new URLRequest("bird.swf"); 
			var wait:int = 0;
			var waitTime:int = 0;
			
			myLoader.load(url); 
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(evt:Event):void{
				var birds:MovieClip = MovieClip(myLoader.content);
				var birdsFlying:MovieClip = birds.birdsFlying;
				birdsFlying.x=0;
				var randomY:Number = Math.random()*100+200;
				var randomX:Number = Math.random()*100+700;
				birdsFlying.y=Math.random()*100+randomY;
				var tl:* = new TimelineMax({repeat:2, repeatDelay:1});
				tl.add(TweenMax.fromTo(birdsFlying, 10, {scaleX:.4,scaleY:.4}, {scaleX:.7,scaleY:.7, bezier:{timeResolution:1, values:[{x:Math.random()*100+100, y:Math.random()*100+randomY}, {x:randomX, y:randomY}, {x:Math.random()*100+1100, y:0}]}}));
				
				tl.add(TweenMax.fromTo(birdsFlying, 20, {scaleX:-.3}, {alpha:1, scaleX:-.8,scaleY:.8,bezier:{type:"soft", timeResolution:1, values:[{x:Math.random()*500, y:200+randomY},{x:0, y:200+randomY}]}}));
				addChild(birdsFlying);
				
				mcControl = new MovieClipController(birdsFlying);
				mcControl.play(3);
			});
			
			addEventListener(Event.ENTER_FRAME,function():void{
				var t:int = flash.utils.getTimer();
				if(mcControl){
					mcControl.stepForwardEvery(t,2000);
				}
			});
		}
	}
}