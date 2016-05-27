package com.codechiev.car
{
    import __AS3__.vec.*;
    import away3d.containers.*;
    import away3d.core.base.*;
    import away3d.entities.*;
    import away3d.events.*;
    import away3d.loaders.*;
    import away3d.loaders.misc.*;
    import away3d.loaders.parsers.*;
    import away3d.materials.*;
    import away3d.materials.methods.*;
    import away3d.primitives.*;
    import away3d.tools.*;
    import caurina.transitions.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Car extends ObjectContainer3D
    {
        private var _loader:Loader3D;
        private var _trunk:Mesh;
        private var _flDoor:Mesh;
        private var _frDoor:Mesh;
        private var _rlDoor:Mesh;
        private var _rrDoor:Mesh;/*
        private var _flWheel:CarWheel;
        private var _frWheel:CarWheel;
        private var _rlWheel:CarWheel;
        private var _rrWheel:CarWheel;*/
        private var _steerFL:ObjectContainer3D;
        private var _steerFR:ObjectContainer3D;/*
        public var flareGroup:FlareGroup;
        public var brakeGroup:FlareGroup;
        public var rearGroup:FlareGroup;*/
        private var flareSubGroup:Mesh;
        //private var _tips:CarTips;
        private var _camPath:CarCameras;
        private var _tree:Object3DTree;
        private var _haillon:Mesh;
        private var _rStpLgt:Mesh;
        private var _lStpLgt:Mesh;
        private var _rStpLgt2:Mesh;
        private var _lStpLgt2:Mesh;
        private var _rStpLgt3:Mesh;
        private var _lStpLgt3:Mesh;
        private var _rLgt1:Mesh;
        private var _rLgt2:Mesh;
        private var _rLgt3:Mesh;
        private var _lLgt1:Mesh;
        private var _lLgt2:Mesh;
        private var _lLgt3:Mesh;
        private var _ground:Mesh;
        //private var _interior:Interior;
       // private var _scene:Scene3D;
        //private var _elements:CarElements;
        private var _kar:Mesh;
        private var _int:Mesh;
        //private var _lods:Vector.<LodSubGeometry>;
        private var _driveSpotPosition:Vector3D;
        private var _brake:Boolean;
        //public var alloySelector:AlloySelector;
        private var _backward:Boolean;
        private var _lightsOn:Boolean;
        private var _objs:Array;
        //private var _wheels:Vector.<CarWheel>;
        //private var _planeTest:Plane;
        public static const SWITCH_LIGHT:String = "SWITCH_LIGHT";
        public static const SCALE:Number = 3;

        public function Car(carBytes:ByteArray, param2:AssetLoaderContext, scene:Scene3D)
        {
            this._objs = [];
            this._scene = scene;
            this._build(carBytes, param2);
        }// end function
/*
        public function get brake() : Boolean
        {
            return this._brake;
        }// end function

        public function set brake(param1:Boolean) : void
        {
            if (this._brake == param1)
            {
                return;
            }
            this._brake = param1;
            this.brakeGroup.globalIntensity = this._brake ? (1) : (0);
            return;
        }// end function

        public function get backward() : Boolean
        {
            return this._backward;
        }// end function

        public function set backward(param1:Boolean) : void
        {
            if (this._backward == param1)
            {
                return;
            }
            this._backward = param1;
            Tweener.addTween(this.rearGroup, {globalIntensity:this._backward ? (1) : (0), time:0.1, transition:"linear"});
            return;
        }// end function

        public function get planeTest() : Plane
        {
            return this._planeTest;
        }// end function
*/
        public function get camPath() : CarCameras
        {
            return this._camPath;
        }// end function
/*
        public function getDriveSpotPosition() : Vector3D
        {
            return this._driveSpotPosition;
        }// end function

        public function setWheelsActive(param1:Boolean) : void
        {
            var _loc_2:CarWheel = null;
            for each (_loc_2 in this._wheels)
            {
                
                _loc_2.enabled = param1;
            }
            return;
        }// end function

        public function addGroundShadow() : void
        {
            var _loc_1:BitmapMaterial = null;
            var _loc_2:BasicDiffuseMethod = null;
            if (this._ground == null)
            {
                _loc_1 = new BitmapMaterial();
                _loc_1.mipmap = false;
                _loc_1.smooth = true;
                _loc_1.blendMode = BlendMode.MULTIPLY;
                _loc_2 = _loc_1.diffuseMethod;
                _loc_2.compressedTexture = TexturesResources.getResource("ground_shadow");
                this._ground = new Plane(_loc_1, 500, 500, 1, 1, false);
            }
            this.trunk.addChild(this._ground);
            return;
        }// end function

        public function removeGroundShadow() : void
        {
            this.trunk.removeChild(this._ground);
            return;
        }// end function

        public function switchLights() : void
        {
            var _loc_1:* = materials.get(Mat.CAR_CBS) as CarCBSMaterial;
            _loc_1.lighting = !_loc_1.lighting;
            var _loc_2:* = _loc_1.lighting;
            this.flareGroup.on = _loc_1.lighting;
            this._lightsOn = _loc_2;
            dispatchEvent(new Event(SWITCH_LIGHT));
            soundManager.playSound("switch_lights");
            return;
        }// end function
*/
        private function _build(data:ByteArray, loadContext:AssetLoaderContext) : void
        {
            Loader3D.enableParser(Max3DSParser);
            this._loader = new Loader3D(false);
            //this._loader.parseData(data, null, param2);
            this._tree = new Object3DTree(this._loader);
            var load3d:* = new Loader3D(false);
			//load3d.parseData(BinaryResources.getResource("juke_lod"), null, loadContext);
            //this._lods = LodProcessor.run(this._tree, new Object3DTree(load3d));
            //this.onResourceComplete(null);
            return;
        }// end function
/*
        public function setLowGeom() : void
        {
            var _loc_1:LodSubGeometry = null;
            for each (_loc_1 in this._lods)
            {
                
                _loc_1.level = 1;
            }
            return;
        }// end function

        public function setHighGeom() : void
        {
            var _loc_1:LodSubGeometry = null;
            for each (_loc_1 in this._lods)
            {
                
                _loc_1.level = 0;
            }
            return;
        }// end function

        private function onResourceComplete(event:LoaderEvent) : void
        {
            var _loc_7:Mesh = null;
            var _loc_2:* = new Object3DTraverser();
            _loc_2.enter(this._loader, this.enterObject);
            this._elements = new CarElements(this._tree.elements);
            SelectionRect.cornerGeom = this._elements.getSelectionCornerGeom();
            this._trunk = this._tree.trunk;
            var _loc_9:* = SCALE;
            this._trunk.scaleZ = SCALE;
            var _loc_9:* = _loc_9;
            this._trunk.scaleY = _loc_9;
            this._trunk.scaleX = _loc_9;
            this._flDoor = this._tree..pag as Mesh;
            this._rlDoor = this._tree..prg as Mesh;
            this._frDoor = this._tree..pad as Mesh;
            this._rrDoor = this._tree..prd as Mesh;
            this._kar = this._tree..Kar as Mesh;
            this._int = this._tree..interior as Mesh;
            var _loc_3:* = this._tree..wag as Mesh;
            var _loc_4:* = this._tree..wad as Mesh;
            var _loc_5:* = this._tree..wrg as Mesh;
            var _loc_6:* = this._tree..wrd as Mesh;
            this._flWheel = new CarWheel(this._elements);
            this._flWheel.position = _loc_3.position.clone();
            _loc_3.parent.addChild(this._flWheel);
            _loc_3.parent.removeChild(_loc_3);
            this._frWheel = new CarWheel(this._elements);
            this._frWheel.reverseway = true;
            this._frWheel.position = _loc_4.position.clone();
            _loc_4.parent.addChild(this._frWheel);
            _loc_4.parent.removeChild(_loc_4);
            this._rlWheel = new CarWheel(this._elements);
            this._rlWheel.reverseway = true;
            this._rlWheel.position = _loc_5.position.clone();
            _loc_5.parent.addChild(this._rlWheel);
            _loc_5.parent.removeChild(_loc_5);
            this._rrWheel = new CarWheel(this._elements);
            this._rrWheel.position = _loc_6.position.clone();
            _loc_6.parent.addChild(this._rrWheel);
            _loc_6.parent.removeChild(_loc_6);
            this._wheels = new Vector.<CarWheel>(4, true);
            this._wheels[0] = this._flWheel;
            this._wheels[1] = this._frWheel;
            this._wheels[2] = this._rlWheel;
            this._wheels[3] = this._rrWheel;
            this._lStpLgt = this._tree..G_lgtrl as Mesh;
            this._rStpLgt = this._tree..G_lgtrr as Mesh;
            this._lStpLgt2 = this._tree..G_lgtsrl as Mesh;
            this._rStpLgt2 = this._tree..G_lgtsrr as Mesh;
            this._lStpLgt3 = this._tree..G_lgtbrl as Mesh;
            this._rStpLgt3 = this._tree..G_lgtbrr as Mesh;
            this._rLgt1 = this._tree..G_lgtar1 as Mesh;
            this._rLgt2 = this._tree..G_lgtar2 as Mesh;
            this._rLgt3 = this._tree..G_lgtar3 as Mesh;
            this._lLgt1 = this._tree..G_lgtal1 as Mesh;
            this._lLgt2 = this._tree..G_lgtal2 as Mesh;
            this._lLgt3 = this._tree..G_lgtal3 as Mesh;
            _loc_7 = this._tree..G_HS_drv as Mesh;
            this._driveSpotPosition = _loc_7.position;
            _loc_7.parent.removeChild(_loc_7);
            this._camPath = new CarCameras(this._tree..CamsGroup);
            this._flWheel.transform.prependRotation(180, Vector3D.Y_AXIS);
            this._rlWheel.transform.prependRotation(180, Vector3D.Y_AXIS);
            this.handleWheel(this._flWheel, -90);
            this.handleWheel(this._frWheel, 90);
            this.handleWheel(this._rlWheel, -90);
            this.handleWheel(this._rrWheel, 90);
            this._steerFL = new ObjectContainer3D();
            this._steerFL.name = "steerFL";
            this._steerFL.position = this._flWheel.position.clone();
            this._steerFR = new ObjectContainer3D();
            this._steerFR.name = "steerFR";
            this._steerFR.position = this._frWheel.position.clone();
            this._flWheel.position = new Vector3D();
            this._frWheel.position = new Vector3D();
            this.trunk.removeChild(this._flWheel);
            this.trunk.removeChild(this._frWheel);
            this.trunk.addChild(this._steerFR);
            this.trunk.addChild(this._steerFL);
            this._steerFL.addChild(this._flWheel);
            this._steerFR.addChild(this._frWheel);
            this.flareGroup = FlareGroup.getLightsGroup(this, this.scene);
            this.brakeGroup = FlareGroup.getBrakeGroup(this, this.scene);
            this.rearGroup = FlareGroup.getRearGroup(this, this.scene);
            var _loc_9:int = 0;
            this.rearGroup.globalIntensity = 0;
            var _loc_9:* = _loc_9;
            this.brakeGroup.globalIntensity = _loc_9;
            this.flareGroup.globalIntensity = _loc_9;
            this._kar.removeChild(this._tree..iac_lak);
            var _loc_8:* = new Flat();
            new Flat().apply(this._kar);
            _loc_8.apply(this._int);
            _loc_8.apply(this.tree..pag_int);
            _loc_8.apply(this.tree..prg_int);
            _loc_8.apply(this.tree..pad_int);
            _loc_8.apply(this.tree..prd_int);
            this._trunk.addChild(this._tree..iac_lak);
            this._interior = new Interior(this);
            this._tips = new CarTips();
            this._tips.init(this, this._trunk);
            dispatchEvent(new Event(Event.COMPLETE));
            return;
        }// end function

        private function enterObject(param1:ObjectContainer3D, param2:int) : void
        {
            var _loc_3:Mesh = null;
            if (param1 is Mesh)
            {
                _loc_3 = param1 as Mesh;
                if (_loc_3.extra && _loc_3.extra.materialName != undefined)
                {
                    _loc_3.material = materials.get(_loc_3.extra.materialName);
                }
                if (_loc_3.name.indexOf("iac") == 0)
                {
                    _loc_3.lpMouse = true;
                    _loc_3.bothsideMouse = _loc_3.name.indexOf("ds") > -1;
                    _loc_3.material = null;
                }
            }
            this._objs.push([param1, param2]);
            return;
        }// end function

        private function _applyLakMaterial(param1:Mesh) : void
        {
            var _loc_2:* = param1.name.substr(0, 3);
            var _loc_3:* = materials.get(_loc_2 + "_CAR_PAINT") || materials.get(Mat.CAR_PAINT);
            param1.material = _loc_3;
            return;
        }// end function

        public function get haillon() : Mesh
        {
            return this._haillon;
        }// end function

        public function get flDoor() : Mesh
        {
            return this._flDoor;
        }// end function

        public function get frDoor() : Mesh
        {
            return this._frDoor;
        }// end function

        public function get rlDoor() : Mesh
        {
            return this._rlDoor;
        }// end function

        public function get rrDoor() : Mesh
        {
            return this._rrDoor;
        }// end function

        public function get flWheel() : CarWheel
        {
            return this._flWheel;
        }// end function

        public function get frWheel() : CarWheel
        {
            return this._frWheel;
        }// end function

        public function get rlWheel() : CarWheel
        {
            return this._rlWheel;
        }// end function

        public function get rrWheel() : CarWheel
        {
            return this._rrWheel;
        }// end function

        private function handleWheel(param1:CarWheel, param2:Number) : void
        {
            param1.setType(3);
            param1.addEventListener(MouseEvent.CLICK, this.clickWheel);
            param1.addRollOver();
            return;
        }// end function

        private function clickWheel(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as CarWheel;
            if (this.alloySelector.currentWheel == _loc_2 || model.exploMode != ExploMode.STUDIO)
            {
                return;
            }
            this.alloySelector.addEventListener(Event.COMPLETE, this.onAlloyChange);
            this.alloySelector.transform = _loc_2.transform;
            _loc_2.parent.addChild(this.alloySelector);
            this.alloySelector.show(_loc_2);
            return;
        }// end function

        private function onAlloyChange(event:Event) : void
        {
            var _loc_2:* = this.alloySelector.currentWheel;
            if (this._flWheel != _loc_2)
            {
                this._flWheel.setType(this.alloySelector.type);
            }
            if (this._frWheel != _loc_2)
            {
                this._frWheel.setType(this.alloySelector.type);
            }
            if (this._rlWheel != _loc_2)
            {
                this._rlWheel.setType(this.alloySelector.type);
            }
            if (this._rrWheel != _loc_2)
            {
                this._rrWheel.setType(this.alloySelector.type);
            }
            this.alloySelector.removeEventListener(Event.COMPLETE, this.onAlloyChange);
            return;
        }// end function
*/
        public function get trunk() : Mesh
        {
            return this._trunk;
        }// end function
/*
        public function get rightStopLight() : Mesh
        {
            return this._rStpLgt;
        }// end function

        public function get leftStopLight() : Mesh
        {
            return this._lStpLgt;
        }// end function

        public function get rightStopLight2() : Mesh
        {
            return this._rStpLgt2;
        }// end function

        public function get leftStopLight2() : Mesh
        {
            return this._lStpLgt2;
        }// end function

        public function get rightStopLight3() : Mesh
        {
            return this._rStpLgt3;
        }// end function

        public function get leftStopLight3() : Mesh
        {
            return this._lStpLgt3;
        }// end function

        private function _createPlaneTest() : void
        {
            this._planeTest = new Plane(null, 500, 500, 1, 1, false);
            this._planeTest.y = 500;
            this._trunk.addChild(this._planeTest);
            return;
        }// end function

        public function get tree() : Object3DTree
        {
            return this._tree;
        }// end function

        public function get rLgt1() : Mesh
        {
            return this._rLgt1;
        }// end function

        public function get rLgt2() : Mesh
        {
            return this._rLgt2;
        }// end function

        public function get rLgt3() : Mesh
        {
            return this._rLgt3;
        }// end function

        public function get lLgt1() : Mesh
        {
            return this._lLgt1;
        }// end function

        public function get lLgt2() : Mesh
        {
            return this._lLgt2;
        }// end function

        public function get lLgt3() : Mesh
        {
            return this._lLgt3;
        }// end function

        public function get steerFL() : ObjectContainer3D
        {
            return this._steerFL;
        }// end function

        public function get steerFR() : ObjectContainer3D
        {
            return this._steerFR;
        }// end function

        public function get interior() : Interior
        {
            return this._interior;
        }// end function

        public function getElements() : CarElements
        {
            return this._elements;
        }// end function

        public function get tips() : CarTips
        {
            return this._tips;
        }// end function

        public function get lightsOn() : Boolean
        {
            return this._lightsOn;
        }// end function
*/
    }
}
