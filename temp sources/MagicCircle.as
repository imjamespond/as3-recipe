package testas
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.utils.*;
	
	public class MagicCircle extends Sprite
	{
		private var channel:SoundChannel;
		private var textFormat:TextFormat;
		private var posY:Number;
		private var level:Number;
		private var gradientMatrix:Matrix;
		private var posX:Number;
		private var sound:Sound;
		private var shaderJob:ShaderJob;
		private var volume:Number;
		private var loading:TextField;
		private var blurFilter:BlurFilter;
		private var offscreenSprite:Sprite;
		private var offscreenGraphics:Graphics;
		private var fadeTransform:ColorTransform;
		private var angle:Number;
		private var peak:Number;
		private var renderBitmap:Bitmap;
		private var targetX:Number;
		private var targetY:Number;
		private var renderColor:ColorTransform;
		private var shader:Shader;
		private var renderBuffer:BitmapData;
		private var renderMatrix:Matrix;
		
		private static const CENTER:Point = new Point(WIDTH * 0.5, HEIGHT * 0.5);
		private static const ZERO_POINT:Point = new Point();
		private static const HEX_RANGE:Number = 1.0472;
		private static const WIDTH:uint = 500;
		private static const HEIGHT:uint = 500;
		private static const LOUDNESS:Number = 0.1;
		private static const PEAK_FACTOR:Number = 2.5;
		private static const IHEX_RANGE:Number = 1;
		private static const TWO_PI:Number = 6.28319;
		private static const MUSIC_FILE:String = "http://doorknobdesign.com/wfl/tgm.mp3";
		private static const FADE_FACTOR:Number = -11.275;
		private static const PEAK_DECAY:Number = 0.98;
		
		public function MagicCircle() : void
		{
			if (this.stage)
			{
				this.init();
				this.start();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,this.init);
			}
			return;
		}// end function
		
		private function init(event:Event = null) : void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			this.contextMenu = new ContextMenu();
			this.contextMenu.hideBuiltInItems();
			this.textFormat = new TextFormat();
			this.textFormat.align = "center";
			this.textFormat.color = 16777215;
			this.textFormat.font = "_sans";
			this.textFormat.size = 12;
			this.loading = new TextField();
			this.loading.defaultTextFormat = this.textFormat;
			this.loading.autoSize = "center";
			this.loading.text = "loading";
			this.loading.x = CENTER.x;
			this.loading.y = CENTER.y;
			this.addChild(this.loading);
			this.sound = new Sound(new URLRequest(MUSIC_FILE));
			soundComplete();
			this.level = 0;
			this.peak = 0;
			this.volume = 0;
			return;
		}// end function
		
		private function tick(event:Event) : void
		{
			var _loc_3:Number = NaN;
			var _loc_4:Number = NaN;
			var _loc_5:Number = NaN;
			var _loc_6:Number = NaN;
			this.level = (this.channel.leftPeak + this.channel.rightPeak) * 0.4;
			this.peak = this.peak * PEAK_DECAY;
			if (this.level > this.peak)
			{
				this.peak = this.level;
				this.targetX = Math.random() * WIDTH;
				this.targetY = Math.random() * HEIGHT;
			}
			var _loc_2:* = this.peak * PEAK_FACTOR * 100;
			this.gradientMatrix.createGradientBox(_loc_2 * 2, _loc_2 * 2, 0, -_loc_2, -_loc_2);
			this.offscreenGraphics.clear();
			this.offscreenGraphics.beginGradientFill("radial", [16777215, 16777215], [1, 0], [0, 255], this.gradientMatrix);
			this.offscreenGraphics.drawCircle(0, 0, _loc_2);
			this.offscreenGraphics.endFill();
			this.renderMatrix.identity();
			var _loc_9:* = getTimer() * 0.001;
			this.angle = getTimer() * 0.001;
			this.renderMatrix.rotate(_loc_9);
			this.renderMatrix.translate(CENTER.x, CENTER.y);
			this.renderColor.alphaMultiplier = this.peak;
			this.renderBuffer.colorTransform(this.renderBuffer.rect, this.fadeTransform);
			this.renderBuffer.draw(this.offscreenSprite, this.renderMatrix, this.renderColor, "add");
			this.renderBuffer.applyFilter(this.renderBuffer, this.renderBuffer.rect, ZERO_POINT, this.blurFilter);
			_loc_6 = this.peak * TWO_PI;
			var _loc_7:* = int(_loc_6 * IHEX_RANGE);
			if (int(_loc_6 * IHEX_RANGE) == 0)
			{
				_loc_3 = 1;
				_loc_5 = 0;
			}
			if (_loc_7 == 1)
			{
				_loc_4 = 1;
				_loc_5 = 0;
			}
			if (_loc_7 == 2)
			{
				_loc_3 = 0;
				_loc_4 = 1;
			}
			if (_loc_7 == 3)
			{
				_loc_3 = 0;
				_loc_5 = 1;
			}
			if (_loc_7 == 4)
			{
				_loc_4 = 0;
				_loc_5 = 1;
			}
			if (_loc_7 == 5)
			{
				_loc_3 = 1;
				_loc_4 = 0;
			}
			if (isNaN(_loc_3))
			{
				_loc_6 = _loc_6 - _loc_7 * HEX_RANGE;
				if (_loc_7 % 2 != 0)
				{
					_loc_6 = HEX_RANGE - _loc_6;
				}
				_loc_3 = _loc_6 * IHEX_RANGE;
			}
			else if (isNaN(_loc_4))
			{
				_loc_6 = _loc_6 - _loc_7 * HEX_RANGE;
				if (_loc_7 % 2 != 0)
				{
					_loc_6 = HEX_RANGE - _loc_6;
				}
				_loc_4 = _loc_6 * IHEX_RANGE;
			}
			else if (isNaN(_loc_5))
			{
				_loc_6 = _loc_6 - _loc_7 * HEX_RANGE;
				if (_loc_7 % 2 != 0)
				{
					_loc_6 = HEX_RANGE - _loc_6;
				}
				_loc_5 = _loc_6 * IHEX_RANGE;
			}
			var _loc_8:* = (1 - this.peak) * FADE_FACTOR;
			this.fadeTransform.redOffset = _loc_8 - _loc_3 * 10;
			this.fadeTransform.greenOffset = _loc_8 - _loc_4 * 10;
			this.fadeTransform.blueOffset = _loc_8 - _loc_5 * 10;
			this.posX = this.posX + (this.targetX - this.posX) * 0.02 - 200;
			// this.posY = this.posY + (this.targetY - this.posY) * 0.02;
			return;
		}// end function
		
		private function soundProgress(event:ProgressEvent) : void
		{
			this.loading.text = String(int(100 * event.bytesLoaded / event.bytesTotal)) + "%";
			return;
		}// end function
		
		private function start() : void
		{
			this.channel = this.sound.play(0);
			this.addEventListener(Event.ENTER_FRAME, this.tick);
			return;
		}// end function
		
		private function soundComplete():void
		{
			this.removeChild(this.loading);
			this.gradientMatrix = new Matrix();
			this.offscreenSprite = new Sprite();
			this.offscreenGraphics = this.offscreenSprite.graphics;
			this.angle = 0;
			this.renderMatrix = new Matrix();
			this.renderBuffer = new BitmapData(WIDTH, HEIGHT, false, 0);
			this.renderBitmap = new Bitmap(this.renderBuffer);
			this.addChild(this.renderBitmap);
			this.renderColor = new ColorTransform();
			this.fadeTransform = new ColorTransform(1, 1, 1, 1, -8, -8, -8, 0);
			this.blurFilter = new BlurFilter(2, 2, 1);
			this.posX = 0;
			this.posY = 0;
			this.targetX = 0;
			this.targetY = 0;
			
		}// end function
		
	}
}
