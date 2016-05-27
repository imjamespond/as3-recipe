package com.codechiev.car
{
    import __AS3__.vec.*;
    
    import away3d.containers.*;
    
    import flash.utils.*;

    dynamic public class Object3DTree extends Proxy
    {
        private var _chain:Array;
        private var _root:Node;
        private var _flat:Dictionary;
        private var _bypath:Dictionary;
        private var _paths:Vector.<String>;

        public function Object3DTree(obj:ObjectContainer3D)
        {
            this._chain = [];
            this._root = new Node(obj);
            this._flat = new Dictionary();
            this._bypath = new Dictionary();
            this._paths = new Vector.<String>;
            this._scanObj(this._root);
            return;
        }// end function

        private function _scanObj(node:Node) : void
        {
            var obj3d:ObjectContainer3D = null;
            var node3d:Node = null;
            this._chain.push(node.object.name);
            var nameChain:* = this._chain.join("/");
            var indexChildren:int = 0;
            while (indexChildren < node.object.numChildren)
            {
                
                obj3d = node.object.getChildAt(indexChildren);
                if (obj3d.name != "")
                {
					node3d = new Node(obj3d);
                    node.childsByName[obj3d.name] = node3d;
                    this._flat[obj3d.name] = node3d;
                    this._bypath[nameChain + "/" + obj3d.name] = node3d;
                    this._paths.push(nameChain + "/" + obj3d.name);
                    this._scanObj(node3d);
                }
                indexChildren++;
            }
            this._chain.pop();
            return;
        }// end function

        public function getAllPaths() : Vector.<String>
        {
            return this._paths;
        }// end function

        public function getChildFromPath(param1:String) : ObjectContainer3D
        {
            return this._bypath[param1].obj;
        }// end function

        /*override */private function getProperty(name:String):Node
        {
            if (this._root.childsByName[name] == undefined)
            {
                throw new Error("fr.digitas.jexplorer.d3.utils.Object3DTree - no child : " + name);
            }
            return this._root.childsByName[name].obj;
        }// end function

        /*override */private function getDescendants(name:String):Node
        {
            if (this._flat[name] == undefined)
            {
                throw new Error("fr.digitas.jexplorer.d3.utils.Object3DTree - no child : " + name);
            }
            return this._flat[name].obj;
        }// end function

    }
}
import com.codechiev.pathanimator.TransformAnimationSequence;
import away3d.containers.ObjectContainer3D;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.utils.Dictionary;

class Node extends Object
{
    private var mtxs:Vector.<Matrix3D>;
    private var animation:TransformAnimationSequence;
    public var ID:int;
    public var parent:int;
    public var object:ObjectContainer3D;
    public var translate:Vector.<Vector3D>;
    public var rotations:Vector.<Number>;
    public var rotationAxe:Vector.<Vector3D>;
    public var scale:Vector.<Vector3D>;
    public var pivotx:Number = 0;
    public var pivoty:Number = 0;
    public var pivotz:Number = 0;
    public var rf:Vector.<uint>;
    public var tf:Vector.<uint>;
    public var sf:Vector.<uint>;
	
	public var childsByName:Dictionary = new Dictionary();

    function Node(obj:ObjectContainer3D)
    {
        this.translate = new Vector.<Vector3D>;
        this.rotations = new Vector.<Number>;
        this.rotationAxe = new Vector.<Vector3D>;
        this.scale = new Vector.<Vector3D>;
        this.tf = new Vector.<uint>;
        this.rf = new Vector.<uint>;
        this.sf = new Vector.<uint>;
		this.object = obj;
    }// end function

    public function getTransforms() : Vector.<Matrix3D>
    {
        var _loc_1:int = 0;
        if (this.mtxs == null)
        {
            this.mtxs = new Vector.<Matrix3D>(this.translate.length, true);
            _loc_1 = 0;
            while (_loc_1 < this.translate.length)
            {
                
                this.mtxs[_loc_1] = new Matrix3D();
                this.mtxs[_loc_1].appendTranslation(-this.pivotx, -this.pivoty, -this.pivotz);
                if (_loc_1 < this.scale.length)
                {
                    this.mtxs[_loc_1].appendScale(this.scale[_loc_1].x, this.scale[_loc_1].y, this.scale[_loc_1].z);
                }
                if (_loc_1 < this.rotations.length)
                {
                    this.mtxs[_loc_1].appendRotation(this.rotations[_loc_1], this.rotationAxe[_loc_1]);
                }
                if (_loc_1 < this.translate.length)
                {
                    this.mtxs[_loc_1].appendTranslation(this.translate[_loc_1].x, this.translate[_loc_1].y, this.translate[_loc_1].z);
                }
                _loc_1++;
            }
            if (this.translate.length > 1)
            {
                this.animation = new TransformAnimationSequence(this.object.name + "_anim");
                _loc_1 = 0;
                while (_loc_1 < (this.translate.length - 1))
                {
                    
                    this.animation.addFrame(this.mtxs[_loc_1], (this.tf[(_loc_1 + 1)] - this.tf[_loc_1]) * (1000 / 30));
                    _loc_1++;
                }
                this.animation.addFrame(this.mtxs[_loc_1], 1);
                if (this.object.extra == null)
                {
                    this.object.extra = {};
                }
                this.object.extra.animation3DS = this.animation;
            }
        }
        return this.mtxs;
    }// end function

}

