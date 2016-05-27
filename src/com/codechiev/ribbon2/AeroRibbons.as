package com.codechiev.ribbon2
{
    import away3d.bounds.*;
    import away3d.containers.*;
    import away3d.core.base.*;
    import away3d.core.partition.*;
    import away3d.entities.*;
    import away3d.materials.*;
    import away3d.primitives.*;
    import away3d.utils.Cast;
    
    import caurina.transitions.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class AeroRibbons extends Mesh
    {
        private var _alphaMap:Vector.<Number>;
        private var _gmat:ColorMaterial;
        private var _groundpass:AeroLighteningPass;
        private var rMesh:RibbonMesh;
        private var psize:int = 1200;
        private var _percentBitmap:BitmapData;
        private var _flooding:Boolean;
        private var _maskMat:ColorMaterial;
        private var _scene2:Scene3D;
        private var ptest:Mesh;
        private var _precompleteted:Boolean;
        private var _geoms:Vector.<RibbonGeometry>;
        private var _ground:Mesh;
        private var _mask:Mesh;
        private var _lastProgressUpdate:int = -1000;
        //private var _pcentTemplate:MovieClip;

        public function AeroRibbons(scene:Scene3D)
        {
            _scene2 = scene;
            super(null);
            _build();
            //_bounds = new NullBounds(true);
            return;
        }// end function

       /* override public function dispose(param1:Boolean) : void
        {
            super.dispose(param1);
            _mask.dispose(true);
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function*/

        override protected function updateBounds() : void
        {
            return;
        }// end function

        public function step() : void
        {
            var _loc_1:int = 0;
            rMesh.step(_flooding ? (32) : (26));
            if (_flooding)
            {
                _mask.z = _mask.z - 32;
                if (_mask.z < -850 && !_precompleteted)
                {
                    _precompleteted = true;
                    dispatchEvent(new Event(Event.CONNECT));
                    _scene2.removeChild(_mask);
                }
                if (_mask.z < -1600)
                {
                    dispose();
                }
            }
            if (_flooding)
            {
                return;
            }
            _loc_1 = Math.random() * _geoms.length;
            rMesh.geometry.addSubGeometry(_geoms[_loc_1]);
            return;
        }// end function

        public function flood() : void
        {
            var _loc_1:SubGeometry = null;
            _flooding = true;
            rMesh.decay = 0.006;
            for each (_loc_1 in _geoms)
            {
                
                rMesh.geometry.addSubGeometry(_loc_1);
            }
            _mask.y = 0;
            _scene2.addChild(_mask);
            return;
        }// end function

        private function _build() : void
        {
            var pointIdx:int = 0;
            var ribbonGeom:RibbonGeometry = null;
            //_pcentTemplate = new PcentTemplate();
            _generateAlphaMap();
            rMesh = new RibbonMesh();
            var partition3D:Partition3D = new Partition3D(new NodeBase());
            //partition3D.priority = 200;
            rMesh.partition = partition3D;
            rMesh.scene = _scene2;
            _maskMat = new ColorMaterial(0, 0.99);
            _mask = new Mesh(new CubeGeometry(500, 700, 1400), _maskMat );
            var _loc_2:Partition3D = new Partition3D(new NodeBase());
            //_loc_2.priority = 100;
            _mask.partition = _loc_2;
            _mask.scene = _scene2;
            _mask.y = -800;
            var passes:Vector.<AeroLighteningPass> = new Vector.<AeroLighteningPass>;
            _groundpass = getLighteningPrepass();
            passes[0] = _groundpass;
            rMesh.material = new AeroRibbonMaterial(passes);
            //var ribbonData:* = new Assets.Ribbons_dat() as ByteArray;
			var ribbonData:Geometry = new CubeGeometry(100,100,100,1,1);
            var ribbonNum:int = 1;//(new Assets.Ribbons_dat() as ByteArray).readInt();
            _geoms = new Vector.<RibbonGeometry>(ribbonNum, true);
            var vertex:Vector3D = new Vector3D();
            var count:int = 0;
			var pointNum:int = 0;
            while (count < ribbonNum)
            {
				trace(ribbonData.subGeometries[0].numVertices);
                /*pointNum = ribbonData.readInt();//point num
                ribbonGeom = new RibbonGeometry();
                pointIdx = 0;
                while (--pointNum > -1)
                {
                    vertex.setTo(ribbonData.readFloat(), 10, 0);
                    ribbonGeom.addPoint(vertex, _alphaMap[pointIdx]);
                    pointIdx++;
                }
                _geoms[count] = ribbonGeom;*/
                count++;
            }
            _gmat = new ColorMaterial(12303291, 1);
            _gmat.name = "toto";
            _gmat.mipmap = true;
            _gmat.smooth = true;
            _percentBitmap = new BitmapData(512, 512, false, 11184810);
            _gmat.diffuseMethod.texture = Cast.bitmapTexture( _percentBitmap);
            _updateLoading(61);
            //_gmat.addMethod(new WallLighteningMethod(_groundpass, "ground"));
            _ground = new Mesh( new PlaneGeometry(psize, psize, 1, 2), _gmat);
            _corner(_ground.geometry.subGeometries[0]);
            _ground.rotationY = -90;
            _ground.x = 250;
            var ptMaterial:ColorMaterial = new ColorMaterial(16711680, 1);
			//ptMaterial.addMethod(new WallLighteningMethod(_groundpass, "test", false));
            ptest = new Mesh( new PlaneGeometry(200, 200, 1, 1), ptMaterial);
            ptest.y = -20;
            addChild(ptest);
            _scene2.addChild(rMesh);
            addChild(_ground);
            return;
        }// end function

        private function _updateLoading(param1:int) : void
        {
            /*_pcentTemplate.tf.htmlText = "<font size=\'120\'>" + param1 + "</font><font size=\'90\'>%</font>";
            var _loc_2:* = new Matrix();
            _loc_2.rotate(Math.PI);
            _loc_2.translate(512, 512);
            _percentBitmap.draw(_pcentTemplate, _loc_2);
            if (_gmat.diffuseMethod.bitmapData)
            {
                _gmat.diffuseMethod.invalidateBitmapData();
            }*/
            return;
        }// end function

        private function _corner(subGeom:ISubGeometry) : void
        {
            var vertexData:Vector.<Number> = subGeom.vertexData;
            vertexData[1] = -vertexData[2];
            vertexData[4] = -vertexData[5];
            vertexData[2] = 0;
            vertexData[5] = 0;
            subGeom.autoDeriveVertexNormals = false;
            //subGeom.updateVertexData(vertexData);
            return;
        }// end function

        private function getLighteningPrepass() : AeroLighteningPass
        {
            var config:OrthConfig = null;
            var pass:AeroLighteningPass = new AeroLighteningPass();
            config = new OrthConfig();
            config.orthlens.maxX = psize / 2;
            config.orthlens.minX = (-psize) / 2;
            config.orthlens.maxY = psize / 2;
            config.orthlens.minY = (-psize) / 2;
            config.cam.position = new Vector3D(-0, 250, 0);
            config.cam.lookAt(new Vector3D(-1000, 250, 0));
            config.campos.copyFrom(new Vector3D(2000, 250, 0));
            pass.addConfig(config);
            config = new OrthConfig();
            config.orthlens.maxX = psize / 2;
            config.orthlens.minX = (-psize) / 2;
            config.orthlens.maxY = psize / 2;
            config.orthlens.minY = (-psize) / 2;
            config.cam.position = new Vector3D(250, 100, 0);
            config.cam.lookAt(new Vector3D(250, 0, 0), new Vector3D(-1, 0, 0));
            config.campos.copyFrom(new Vector3D(250, 2000, 0));
            pass.addConfig(config);
            return pass;
        }// end function

        public function hideProgress() : void
        {
            var _loc_1:* = _groundpass.getConfig(0);
            Tweener.addTween(_loc_1.cam, {x:-200, time:2, transition:"linear"});
            _loc_1 = _groundpass.getConfig(1);
            Tweener.addTween(_loc_1.cam, {y:-20, time:2, transition:"linear", onComplete:removeProgress});
            return;
        }// end function

        private function removeProgress() : void
        {
            removeChild(_ground);
            removeChild(ptest);
            return;
        }// end function

        private function _generateAlphaMap() : void
        {
            var _loc_3:Number = NaN;
            var _loc_1:int = 15;
            var _loc_2:int = 20;
            _alphaMap = new Vector.<Number>(41, true);
            var _loc_4:int = 0;
            while (_loc_4 < 41)
            {
                
                _loc_3 = _loc_4 < _loc_1 ? (_loc_4 / _loc_1 - 0.3) : (_loc_4 > 41 - _loc_2 ? ((41 - _loc_4) / _loc_2 - 0.1) : (1));
                _alphaMap[_loc_4] = _loc_3;
                _loc_4++;
            }
            return;
        }// end function

        public function get lpass() : AeroLighteningPass
        {
            return _groundpass;
        }// end function

        public function setProgress(param1:Number) : void
        {
            if (getTimer() - _lastProgressUpdate < 60 && param1 < 99)
            {
                return;
            }
            _lastProgressUpdate = getTimer();
            _updateLoading(param1);
            return;
        }// end function

    }
}
