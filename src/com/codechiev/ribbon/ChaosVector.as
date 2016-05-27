package com.codechiev.ribbon
{
    import flash.geom.*;

    public class ChaosVector extends Object
    {
        public var vector:Vector3D;//方向
        private var f:Vector3D;
        private var v:Vector3D;
        private var chaos:Number = 0.01;
        private var damp:Number = 0.8;
        private var gravity:Number = 0.001;

        public function ChaosVector()
        {
            vector = new Vector3D();
            f = new Vector3D();
            v = new Vector3D();
            return;
        }// end function

        public function step() : void
        {
			//初始各方向随机速度
            f.x = f.x + chaos * (Math.random() - 0.5);
            f.y = f.y + chaos * (Math.random() - 0.5);
            f.z = f.z + chaos * (Math.random() - 0.5);
			//抵消重力
            var magnitude:Number = gravity * vector.length;//重力的加速度
            f.x = f.x - vector.x * magnitude;
            f.y = f.y - vector.y * magnitude;
            f.z = f.z - vector.z * magnitude;
            f.x = f.x - v.x * 0.02;
            f.y = f.y - v.y * 0.02;
            f.z = f.z - v.z * 0.02;
            v.x = v.x + f.x;
            v.y = v.y + f.y;
            v.z = v.z + f.z;
            v.scaleBy(damp);
			//最终速度
            vector.x = vector.x + v.x;
            vector.y = vector.y + v.y;
            vector.z = vector.z + v.z;
        }// end function

    }
}
