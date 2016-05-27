package com.codechiev.pathanimator
{
    import __AS3__.vec.*;

    public class TimelineUtil extends Object
    {
        private var _frame0:uint;
        private var _frame1:uint;
        private var _blendWeight:Number;

        public function TimelineUtil()
        {
            return;
        }// end function

        public function get frame0() : Number
        {
            return this._frame0;
        }// end function

        public function get frame1() : Number
        {
            return this._frame1;
        }// end function

        public function get blendWeight() : Number
        {
            return this._blendWeight;
        }// end function

        public function updateFrames(param1:Number, param2:AnimationSequenceBase, param3:Boolean = false) : void
        {
            var _loc_4:uint = 0;
            var _loc_5:uint = 0;
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_13:Number = NaN;
            var _loc_14:Number = NaN;
            var _loc_9:* = param2._durations;
            var _loc_10:* = param2._totalDuration;
            var _loc_11:* = param2.looping;
            var _loc_12:* = _loc_9.length;
            if ((param1 > _loc_10 || param1 < 0) && _loc_11)
            {
                param1 = param1 % _loc_10;
                if (param1 < 0)
                {
                    param1 = param1 + _loc_10;
                }
            }
            _loc_4 = _loc_12 - 1;
            if (!_loc_11 && param1 > _loc_10 - _loc_9[_loc_4] && !param3)
            {
                param2.notifyPlaybackComplete();
                _loc_5 = _loc_4;
                _loc_6 = _loc_4;
                _loc_13 = 0;
            }
            else if (!_loc_11 && param1 < 0 && param3)
            {
                param2.notifyPlaybackComplete();
                _loc_5 = 0;
                _loc_6 = 0;
                _loc_13 = 0;
            }
            else if (param2._fixedFrameRate)
            {
                _loc_14 = param1 / _loc_10 * _loc_12;
                _loc_5 = _loc_14;
                _loc_6 = _loc_5 + 1;
                _loc_13 = _loc_14 - _loc_5;
                if (_loc_5 == _loc_12)
                {
                    _loc_5 = 0;
                }
                if (_loc_6 >= _loc_12)
                {
                    _loc_6 = _loc_6 - _loc_12;
                }
            }
            else
            {
                _loc_7 = _loc_9[0];
                _loc_6 = 1;
                while (param1 > _loc_7)
                {
                    
                    _loc_8 = _loc_7;
                    _loc_5 = _loc_6;
                    _loc_7 = _loc_7 + _loc_9[_loc_5];
                    if (++_loc_6 == _loc_12)
                    {
						_loc_6 = 0;//++_loc_6 = 0;
                    }
                }
                _loc_13 = (param1 - _loc_8) / _loc_9[_loc_5];
            }
            this._frame0 = _loc_5;
            this._frame1 = _loc_6 + 1;
            this._blendWeight = _loc_13;
            return;
        }// end function

    }
}
