package {
	import com.hexagonstar.display.bitmaps.AnimatedBitmap;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import com.bit101.components.PushButton;
	
	[SWF(width="1024", height="768", backgroundColor="#111111")]
	public class BitmapTest extends Sprite {

		private var bitmap_:Bitmap;
		private var viewPoint_:Rectangle;
		private var loadFile_:FileReference;
		
		public function BitmapTest()
		{
			viewPoint_ = new Rectangle(10, 10, stage.stageWidth-20, stage.stageHeight-20);
			var btn1:PushButton = new PushButton(this, 0, 0, "open", startLoadingFile);
		}
		
		/**
		 *开启选择文件
		 * @param e
		 * 
		 */
		private function startLoadingFile(e:Event):void
		{
			loadFile_ = new FileReference();
			loadFile_.addEventListener(Event.SELECT, selectHandler);
			var fileFilter:FileFilter = new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png");
			loadFile_.browse([fileFilter]);
		}
		
		/**
		 * 选中文件事件
		 * @param event
		 * 
		 */
		private function selectHandler(event:Event):void
		{
			loadFile_.removeEventListener(Event.SELECT, selectHandler);
			loadFile_.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loadFile_.load();

		}
		
		/**
		 *文件载入完毕 
		 * @param event
		 * 
		 */
		private function loadCompleteHandler(event:Event):void
		{
			var file:FileReference = FileReference(event.target);
			file.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);
			loader.loadBytes(file.data);
		}
		
		/**
		 * 载入文件数据完毕
		 * @param event
		 * 
		 */
		private function loadBytesHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
			
			showAnimation(loaderInfo.content);
		}
		
		private function showAnimation(bitmap:DisplayObject):void{
			var bitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x000000);
			bitmapData.draw(bitmap);
			var anim:AnimatedBitmap = new AnimatedBitmap(bitmapData,67, 74);
			anim.scaleDownForward(.95,Math.PI*.5);
			anim.playOnFrameUpdate3(1,true);
			//			animExplode.playOnFrameUpdate2(2,false,function(b:Bitmap):void{
			//				b.parent.removeChild(b);
			//			});
			anim.x = 100;
			anim.y = 100;
			stage.addChild(anim);
			stage.addEventListener(Event.ENTER_FRAME, function():void{
			anim.onFrameUpdate();
			//animExplode.decFrameNPlay(1);/
			});
		}

	}
}