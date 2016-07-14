package com.codechiev.ribbon
{
    import flash.geom.*;

    public class Chaos extends Object
    {
        public var vector:Vector3D;//方向
        private var f:Vector3D;
        private var v:Vector3D;
        private var chaos:Number = 0.01;
        private var damp:Number = 0.8;
        private var gravity:Number = 0.001;

        public function Chaos()
        {
            vector = new Vector3D();
            f = new Vector3D();
            v = new Vector3D();
            return;
        }// end function

        public function step() : void
        {
			//
			//f(step) = f(step-1) + chaos
			//f(step) = f(step-1) + chaos - vector(step-1) * mag(step) 			
			//f(step) = f(step-1) + chaos - vector(step-1) * mag(step) - v(step-1) * 0.02
			//v(step) = v(step-1) + f(step-1) + chaos - vector(step-1) * mag(step) - v(step-1) * 0.02
			//vector(step)=vector(step-1) + (v(step-1) + f(step-1) + chaos - vector(step-1) * mag(step) - v(step-1) * 0.02)*.8
			//f(1) = chaos; v(1) = chaos; vector(1) = chaos;
			//vector(2)  = chaos1 + chaos1 + chaos1 + chaos2 - chaos1*mag(step) - chaos1*0.02
			//初始各方向随机速度
            f.x += chaos * (Math.random() - 0.5);
            f.y += chaos * (Math.random() - 0.5);
            f.z += chaos * (Math.random() - 0.5);
			//抵消重力
            var magnitude:Number = gravity * vector.length;//通过length渐增或渐弱
			/*
            f.x -= vector.x * magnitude;
            f.y -= vector.y * magnitude;
            f.z -= vector.z * magnitude;
			*/
            f.x -= v.x * 0.02;
            f.y -= v.y * 0.02;
            f.z -= v.z * 0.02;
            v.x += f.x;
            v.y += f.y;
            v.z += f.z;
            v.scaleBy(damp);//ribbon scale
			//最终速度
            vector.x += v.x;
            vector.y += v.y;
            vector.z += v.z;
        }// end function

    }
}
