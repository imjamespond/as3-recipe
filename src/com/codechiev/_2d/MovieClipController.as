package com.codechiev._2d
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class MovieClipController
	{
		private var _mc:MovieClip;
		private var _playing:Boolean;
		private var _step:Number;
		private var _currentFrame:Number;
		
		private var _updateTime:int = 0;
		private var _updateInterval:int = 100;
		private var _waitTime:int = 0;
		private var _wait:int = 0;
		
		public function MovieClipController( mc:MovieClip ) 
		{
			_mc = mc;
			_mc.stop();
			_currentFrame = _mc.currentFrame;
		}

		public function play(frameRate:Number, step:Number = 1 ):void 
		{
			//if(!_playing) _mc.addEventListener(Event.ENTER_FRAME, handleEnterFrame );
			_playing = true;
			_step = step;
			_updateInterval = 1000/frameRate;
		}
		
		public function stop():void 
		{
			//if(_playing) _mc.removeEventListener(Event.ENTER_FRAME, handleEnterFrame );
			_playing = false;           
			_mc.stop();
			_currentFrame = _mc.currentFrame;
		}
		
		public function get step():Number 
		{
			return _step;
		}
		
		public function stepLoop(time:int):void 
		{
			if (_playing&&time -_updateTime > _updateInterval)
			{
				_currentFrame += _step;
				_mc.gotoAndStop( _currentFrame % _mc.totalFrames );  
				_updateTime = time;
			}
		}
		
		public function stepForward(time:int):void 
		{
			if (_playing&&time -_updateTime > _updateInterval)
			{
				_currentFrame += _step;
				if(_currentFrame>_mc.totalFrames){
					stop();
					return;
				}
				_mc.gotoAndStop( _currentFrame % _mc.totalFrames );  
				_updateTime = time;
			}
			
		}
		
		public function stepForwardEvery(time:int,wait:int):void 
		{
			stepForward(time);
			if(!_playing){
				_waitTime+=time-_updateTime;		
				if(_waitTime>wait){
					_playing = true;
					_waitTime=0;
				}
				_updateTime = time;
			}
		}
	}
}