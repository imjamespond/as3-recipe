/*
 * hexagon framework - Multi-Purpose ActionScript 3 Framework.
 * Copyright (C) 2007 Hexagon Star Softworks
 *       __    __
 *    __/  \__/  \__    __
 *   /  \__/HEXAGON \__/  \
 *   \__/  \__/ FRAMEWORK_/
 *            \__/  \__/
 *
 * ``The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 */
package com.hexagonstar.display.bitmaps
{
	import com.hexagonstar.display.FrameRateTimer;
	import com.hexagonstar.display.IAnimatedDisplayObject;
	import com.hexagonstar.env.event.FrameEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * An AnimatedBitmap is a bitmap object that uses a sequence of images
	 * from a provided bitmap to play an animation.
	 * 
	 * @author Sascha Balkau
	 * @version 1.1.0
	 */
	public class AnimatedBitmap extends Bitmap implements IAnimatedDisplayObject
	{
		// Properties /////////////////////////////////////////////////////////////////
		
		/**
		 * The buffer to store the whole bitmap.
		 * @private
		 */
		private var _buffer:BitmapData;
		
		/**
		 * Timer used for frame animation.
		 * @private
		 */
		private var _timer:FrameRateTimer;
		
		/**
		 * The number of frames that the animated bitmap has.
		 * @private
		 */
		private var _frameAmount:int;
		
		/**
		 * Used for the onTimer function to count loops.
		 * @private
		 */
		private var _frameNr:int;
		
		/**
		 * Used for the width of each frame.
		 * @private
		 */
		private var _frameW:int;
		
		/**
		 * Used for the height of each frame.
		 * @private
		 */
		private var _frameH:int;
		
		/**
		 * Determines if the animTile is already playing or not.
		 * @private
		 */
		private var _isPlaying:Boolean = false;
		
		/**
		 * Point object used for copyPixels operation.
		 * @private
		 */
		private var _point:Point;
		
		/**
		 * Rectangle object used for copyPixels operation.
		 * @private
		 */
		private var _rect:Rectangle;
		
		private var _angle:uint;
		private var _angleNum:uint;
		
		private var _lastUpdate:uint = 0;
		private var _onComplete:Function;
		private var _foward:Boolean = true;
		//private static var FRAMERATE:uint = 1;
		private var frameRate_:uint = 1;
		//private static var FRAMES_MILLI:Number = FRAMERATE/1000;
		private var frameMillis_:Number = frameRate_/1000;
		// Constructor ////////////////////////////////////////////////////////////////
		
		/**
		 * Creates a new AnimatedBitmap instance.
		 * 
		 * @param bitmap The bitmapData object that contains the image sequence
		 *         for the animated bitmap.
		 * @param w The width of the animated bitmap.
		 * @param h The height of the animated bitmap.
		 * @param timer The frame rate timer used for the animated bitmap.
		 */
		public function AnimatedBitmap(bitmap:BitmapData,
									   frameW:int,
									   frameH:int,
									   timer:FrameRateTimer = null,
									   transparent:Boolean = true,
									   pixelSnapping:String = "auto",
									   smoothing:Boolean = false)
		{
			super(new BitmapData(frameW, frameH, transparent, 0x00000000),pixelSnapping, smoothing);
			_buffer = bitmap;//.clone();
			_frameW = frameW;
			_frameH = frameH;
			_frameAmount = _buffer.width / _frameW;
			_frameNr = 1;
			_isPlaying = false;
			_timer = timer;
			_point = new Point(0, 0);
			_rect = new Rectangle(0, 0, frameW, frameH);
			
			//trace(_buffer.width," ",_buffer.height);
		}
		
		// Public Methods /////////////////////////////////////////////////////////////
		public function get buffer():BitmapData
		{
			return _buffer;
		}
		public function set angle(angle:int):void
		{
			angle = angle%360;
			_angle = angle/(360/_angleNum);trace(_angle);
		}
		public function set angleNum(num:uint):void
		{
			_angleNum = num;
		}
		/**
		 * Sets the frame rate timer object used for the animated
		 * bitmap. This method is useful when it is desired to change
		 * the framerate at a later timer.
		 * 
		 * @param timer The frame rate timer used for the animated bitmap.
		 */
		public function setFrameRateTimer(timer:FrameRateTimer):void
		{
			if (_isPlaying)
			{
				stop();
				_timer = timer;
				play();
			}
			else
			{
				_timer = timer;
			}
		}
		
		/**
		 * Returns the frame rate with that the animated bitmap is playing.
		 * 
		 * @return The fps value of the animated bitmap.
		 */
		public function getFrameRate():int
		{
			return _timer.getFrameRate();
		}
		
		/**
		 * Returns the current frame position of the animated bitmap.
		 * 
		 * @return The current frame position.
		 */
		public function getCurrentFrame():int
		{
			return _frameNr;
		}
		
		/**
		 * Returns the total amount of frames that the animated bitmap has.
		 * 
		 * @return The total frame amount.
		 */
		public function getTotalFrames():int
		{
			return _frameAmount;
		}
		
		/**
		 * Returns whether the animated bitmap is playing or not.
		 * 
		 * @return true if the animated bitmap is playing, else false.
		 */
		public function isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function lastUpdate():uint
		{
			return _lastUpdate;
		}
		
		/**
		 * Starts the playback of the animated bitmap. If the animated
		 * bitmap is already playing while calling this method, it calls
		 * stop() and then play again instantly to allow for framerate
		 * changes during playback.
		 */
		public function play():void
		{
			if (!_isPlaying)
			{
				_isPlaying = true;
				_timer.addEventListener(TimerEvent.TIMER, playForward);
				_timer.start();
			}
			else
			{
				stop();
				play();
			}
		}
		
		/**
		 * Stops the playback of the animated bitmap.
		 */
		public function stop():void
		{
			if (_isPlaying)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, playForward);
				_isPlaying = false;
			}
		}
		
		/**
		 * Jumps to the specified frameNr and plays the animated
		 * bitmap from that position. Note that the frames of an
		 * animated bitmap start at 1.
		 * 
		 * @param frameNr The frame number to which to jump.
		 */
		public function gotoAndPlay(frameNr:int):void
		{
			_frameNr = frameNr - 1;
			play();
		}
		
		/**
		 * Jumps to the specified frameNr and stops the animated
		 * bitmap at that position. Note that the frames of an
		 * animated bitmap start at 1.
		 * 
		 * @param frameNr The frame number to which to jump.
		 */
		public function gotoAndStop(frameNr:int):void
		{
			if (frameNr >= _frameNr)
			{
				_frameNr = frameNr - 1;
				nextFrame();
			}
			else
			{
				_frameNr = frameNr + 1;
				prevFrame();
			}
		}
		
		/**
		 * Moves the animation to the next of the current frame.
		 * If the animated bitmap is playing, the playback is
		 * stopped by this operation.
		 */
		public function nextFrame():void
		{
			if (_isPlaying) stop();
			_frameNr++;
			if (_frameNr > _frameAmount) _frameNr = _frameAmount;
			draw();
		}
		
		/**
		 * Moves the animation to the previous of the current frame.
		 * If the animated bitmap is playing, the playback is
		 * stopped by this operation.
		 */
		public function prevFrame():void
		{
			if (_isPlaying) stop();
			_frameNr--;
			if (_frameNr < 1) _frameNr = 1;
			draw();
		}
		
		// Private Methods ////////////////////////////////////////////////////////////
		
		/**
		 * Plays the animation forward by one frame.
		 * @private
		 */
		public function playForward(event:TimerEvent = null):void
		{
			_frameNr++;
			if (_frameNr > _frameAmount) _frameNr = 1;
			else if (_frameNr < 1) _frameNr = _frameAmount;
			draw();
		}
		
		/**
		 * Plays the animation backwards by one frame.
		 * @private
		 */
		//private function playBackward():void
		//{
		//	_frameNr--;
		//	if (_frameNr < 1) _frameNr = _frameAmount;
		//	draw();
		//}
		
		/**
		 * Draws the next bitmap frame from the buffer to the animated bitmap.
		 * @private
		 */
		private function draw():void
		{
			dispatchEvent(new FrameEvent(FrameEvent.ENTER));
			//_rect = new Rectangle((_frameNr - 1) * width, 0, width, height);
			_rect = new Rectangle((_frameNr - 1) * _frameW, 0, _frameW, _frameH);
			bitmapData.copyPixels(_buffer, _rect, _point);
		}
		
		/**
		 * 帧动画
		 * @param frameRate帧每秒
		 * @param foward是否向前播放
		 * @param onComplete播完回调
		 * 
		 */
		public function playOnFrameUpdate2(frameRate:uint,foward:Boolean, onComplete:Function):void{
			frameRate_ = frameRate;
			frameMillis_ = frameRate_/1000;
			_foward = foward;
			playOnFrameUpdate(onComplete);
		}
		
		/**
		 *重复播放 帧动画 
		 * @param frameRate
		 * @param foward
		 * 
		 */
		public function playOnFrameUpdate3(frameRate:uint,foward:Boolean):void{
			frameRate_ = frameRate;
			frameMillis_ = frameRate_/1000;
			_foward = foward;
			_onComplete = function(bitmap:Bitmap):void{
				playOnFrameUpdate(_onComplete);
			};
			playOnFrameUpdate(_onComplete);
		}
		
		public function playOnFrameUpdate(onComplete:Function):void{
			_lastUpdate = flash.utils.getTimer();
			_onComplete = onComplete;
			_frameNr = 0;
			_isPlaying = true;
		}
		public function onFrameUpdate():void
		{
			if(_isPlaying){
				var now:uint = flash.utils.getTimer();
				var numFrame:uint = (now - _lastUpdate)*frameMillis_;
				if(numFrame>0){
					_lastUpdate = now;
					if(_foward){
						addFrameNPlay(numFrame);
					}else{
						decFrameNPlay(numFrame);	
					}
				}
			}
		}
		public function addFrameNPlay(num:uint):void
		{
			_frameNr = _frameNr%_frameAmount;//trace(_frameNr);
			_rect.x = _frameNr * _frameW;
			_rect.y = _angle * _frameH;
			bitmapData.copyPixels(_buffer, _rect, _point);
			_frameNr+=num;			
			if (_frameNr >= _frameAmount){
				if(_onComplete!=null){
					playDone();
					_onComplete(this);
					return;
				}
			}

		}
		public function decFrameNPlay(num:uint):void
		{		
			_frameNr = _frameNr%_frameAmount;//trace(_frameNr);
			_rect.x = (_frameAmount - _frameNr -1) * _frameW;
			_rect.y = _angle * _frameH;
			bitmapData.copyPixels(_buffer, _rect, _point);
			_frameNr+=num;			
			if (_frameNr >= _frameAmount){
				if(_onComplete!=null){
					playDone();
					_onComplete(this);
					return;
				}
			}
		}
		private function playDone():void
		{
			_isPlaying = false;
		}
		public function scaleDownForward(scale:Number, rotate:Number):void
		{
			var buffer:BitmapData = new BitmapData(_buffer.width, _buffer.height, true, 0x000000);
			
			var scaleVal:Number = scale;
			for(var i:uint;i<_frameAmount;i++){
				this.scale(i,scaleVal,rotate,buffer);
				scaleVal = scaleVal*scale;
			}
			
			_buffer = buffer;
		}
		public function scaleDownBackward(scale:Number, rotate:Number):void
		{
			var buffer:BitmapData = new BitmapData(_buffer.width, _buffer.height, true, 0x000000);
			
			var scaleVal:Number = scale;
			for(var i:uint = _frameAmount;i>0;i--){
				this.scale(i,scaleVal,rotate,buffer);
				scaleVal = scaleVal*scale;
			}
			
			_buffer = buffer;
		}

		/**
		 * 
		 * @param step
		 * @param scaleVal
		 * @param rotate in radian
		 * @param buffer
		 * 
		 */
		private function scale(step:uint, scaleVal:Number, rotate:Number, buffer:BitmapData):void{
			var point:Point = new Point(0, 0);
			
			var offset:uint = 0;
			_rect = new Rectangle(step * _frameW, 0, _frameW, _frameH);
			var temp1:BitmapData = new BitmapData(_frameW, _frameH, true, 0x000000);
			var temp2:BitmapData = new BitmapData(_frameW, _frameH, true, 0x000000);
			temp1.copyPixels(_buffer, _rect, _point);
			var matrix:Matrix = new Matrix();
			scaleVal = scaleVal>1?1:scaleVal;
			matrix.translate(-_frameW * .5, -_frameH * .5);
			matrix.rotate(rotate);
			matrix.translate(_frameW * .5, _frameH * .5);
			matrix.scale(scaleVal, scaleVal);
			offset = _frameW * (1 - scaleVal) * .5;
			point.x = step * _frameW + offset;
			offset = _frameH * (1 - scaleVal) * .5;
			point.y = offset;
			temp2.draw(temp1, matrix, null, BlendMode.LAYER, null, false);
			buffer.copyPixels(temp2,new Rectangle(0,0,width,height),point);
		}
		
		public function rotateSequence(n:uint):void{
			var buffer:BitmapData = new BitmapData(_buffer.width, _buffer.height*n, true, 0x000000);
			
			var point:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0, _frameW, _frameH);
			var temp1:BitmapData = new BitmapData(_frameW, _frameH, true, 0x000000);
			var temp2:BitmapData = new BitmapData(_frameW, _frameH, true, 0x000000);
			//逐帧
			for(var i:uint = 0;i<_frameAmount;i++){
				//每个angle
				for(var j:uint = 0; j<n; j++){
					var offset:uint = 0;
					//清理
					temp1.fillRect(temp1.rect, 0); 
					temp2.fillRect(temp1.rect, 0); 
					//原帧
					rect.x = i*_frameW;
					temp1.copyPixels(_buffer, rect, _point);
					//旋转
					var matrix:Matrix = new Matrix();
					matrix.translate(-_frameW * .5, -_frameH * .5);
					matrix.rotate(j*2*Math.PI/n);
					matrix.translate(_frameW * .5, _frameH * .5);
					temp2.draw(temp1, matrix, null, BlendMode.LAYER, null, false);
					//写入新帧
					point.x = i * _frameW;
					point.y = j * _frameH;
					buffer.copyPixels(temp2,new Rectangle(0,0,width,height),point);
				}
			}
			_angleNum = n;
			_buffer = buffer;
		}
	}
}
