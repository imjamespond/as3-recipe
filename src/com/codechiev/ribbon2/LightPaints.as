package com.codechiev.ribbon2
{
    import away3d.containers.*;
    import away3d.core.partition.*;
    import away3d.entities.*;
    import away3d.materials.ColorMaterial;
    
    import caurina.transitions.*;
    
    import flash.geom.*;
    
    public class LightPaints extends Object
    {
        private var lstopRibbon:Ribbon;
        private var rstopRibbon:Ribbon;
        private var _lightPartition:Partition3D;
        //private var _scene:Scene3D;
        //private var _car:Car;
		public var lgtGroup:Mesh;
        private var material:LightPaintMaterial;
        public var power:Number = 0;
        private var _dezoom:Number = 0;
        public var powerdecay:Number = -0.005;

        public function LightPaints()
        {
            //his._scene = param1;
            _build();
            return;
        }// end function

        public function clearAll() : void
        {
            lstopRibbon.clearAll();
            rstopRibbon.clearAll();
            return;
        }// end function

        public function get dezoom() : Number
        {
            return _dezoom;
        }// end function

        public function set dezoom(dz:Number) : void
        {
            _dezoom = dz;
            material.dezoom = dz;
            lstopRibbon.setMiplevel(Math.floor(dz * 3.9));
            rstopRibbon.setMiplevel(Math.floor(dz * 3.9));
            return;
        }// end function

        /*public function setCar(param1:Car) : void
        {
            _car = param1;
            return;
        }// end function*/

        public function play() : void
        {
            Tweener.removeTweens(material);
            Tweener.addTween(material, {opening:1, time:1, delay:1});
            lgtGroup.addChild(lstopRibbon);
            lgtGroup.addChild(rstopRibbon);
            return;
        }// end function

        public function stop() : void
        {
            Tweener.removeTweens(material);
            Tweener.addTween(material, {opening:0, time:0.3, onComplete:stopComplete, transition:Equations.easeInQuad});
            return;
        }// end function

        private function stopComplete() : void
        {
            lgtGroup.removeChild(lstopRibbon);
            lgtGroup.removeChild(rstopRibbon);
            return;
        }// end function

        private function _build() : void
        {
            material = new LightPaintMaterial();
            lstopRibbon = new Ribbon();
            rstopRibbon = new Ribbon();
            rstopRibbon.material = material;
            lstopRibbon.material = material;
            lgtGroup = new Mesh(null);
            _lightPartition = new Partition3D(new NodeBase());
            //_lightPartition.priority = 20;
            lgtGroup.partition = _lightPartition;
            //lgtGroup.scene = _scene;
            //_scene.addChild(lgtGroup);
            lgtGroup.addChild(lstopRibbon);
            lgtGroup.addChild(rstopRibbon);
            return;
        }// end function

        public function step(pos:Vector3D) : void
        {
            /*var _loc_1:* = _car.leftStopLight.position;
            _loc_1 = _car.trunk.sceneTransform.transformVector(_loc_1);*/
            updateRibbon(lstopRibbon, pos);
           /* _loc_1 = _car.rightStopLight.position;
            _loc_1 = _car.trunk.sceneTransform.transformVector(_loc_1);*/
           // updateRibbon(rstopRibbon, pos);
            return;
        }// end function

        private function updateRibbon(ribbon:Ribbon, pos:Vector3D) : void
        {
			pos.y-=10;
            ribbon.power = power;
            var lastPoint:Vector3D = ribbon.ribbonGeom.getPositionAt(-2);
            var distance:Number = 0;
            if (lastPoint)
            {
                distance = lastPoint.subtract( pos).length / 2;//distance control origin 120
                if (distance > 1)
                {
					distance=0;
                    ribbon.addPoint(pos);
                    power = power + powerdecay;
                }
                else
                {
                    //ribbon.ribbonGeom.updatePointAt(pos, power);
                }
            }
            else
            {
                ribbon.addPoint(pos);
                power = power + powerdecay;
            }
			
			//update power
            if (power < 10)
            {
                power = 10;
            }
            if (power > 15)
            {
                powerdecay = -0.005;
            }
            ribbon.stepProgress = distance;
            return;
        }// end function

    }
}
