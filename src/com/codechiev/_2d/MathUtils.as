package com.codechiev._2d
{
	public class MathUtils
	{
		public function MathUtils()
		{
		}
		
		/**
		 * Parallel Angle
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */
		public static function getAngle(x1:int,y1:int,x2:int,y2:int):Number
		{
			var xDiff:int = x1 - x2;
			var yDiff:int = y1 - y2;
			return 360 - Math.atan2(-yDiff, xDiff)/Math.PI*180;
		}
		
		/**
		 * Normal  
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */
		public static function getAngle2(x1:int,y1:int,x2:int,y2:int):Number
		{
			var xDiff:int = x1 - x2;
			var yDiff:int = y1 - y2;
			return 360 - Math.atan2(xDiff, yDiff)/Math.PI*180;
		}
	}
}