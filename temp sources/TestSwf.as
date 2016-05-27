package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	[SWF(backgroundColor="#000000", frameRate="20", width="400", height="300")]
	public class TestSwf extends Sprite
	{
		[Embed(source='/assets/donkey.swf')]
		public var Swf:Class;
		public var mc:MovieClip = new Swf as MovieClip;
		public function TestSwf()
		{
			trace(mc.totalFrames);
			mc.width = 800;
			mc.height = 600;
			mc.y = 100;
			stage.addChild(mc);
		}
	}
}