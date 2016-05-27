package com.codechiev.car
{
	import away3d.core.base.SubGeometry;
    import away3d.animators.data.*;
    import flash.display3D.*;
    import flash.geom.*;
    

    final public class LodSubGeometry extends SubGeometry
    {
        private var _referee:SubGeometry;
        private var _levels:Vector.<SubGeometry>;
        private var _level:uint = 0;

        public function LodSubGeometry()
        {
            this._levels = new Vector.<SubGeometry>;
            return;
        }// end function

        override public function transform(param1:Matrix3D) : void
        {
            var _loc_2:SubGeometry = null;
            for each (_loc_2 in this._levels)
            {
                _loc_2.transform(param1);
            }
            return;
        }// end function

        public function get level() : uint
        {
            return this._level;
        }// end function

        public function set level(param1:uint) : void
        {
            this._level = param1;
            this._referee = this._levels[this._level];
            return;
        }// end function

        public function addLevel(param1:SubGeometry) : void
        {
            if (this._levels.push(param1) == 1)
            {
                this._referee = param1;
            }
            return;
        }// end function

        override public function get animation() : AnimationBase
        {
            return this._referee.animation;
        }// end function

        override public function get numVertices() : uint
        {
            return this._referee.numVertices;
        }// end function

        override public function get numTriangles() : uint
        {
            return this._referee.numTriangles;
        }// end function

        override public function get autoDeriveVertexNormals() : Boolean
        {
            return this._referee.autoDeriveVertexNormals;
        }// end function

        override public function set autoDeriveVertexNormals(param1:Boolean) : void
        {
            this._referee.autoDeriveVertexNormals = param1;
            return;
        }// end function

        override public function get useFaceWeights() : Boolean
        {
            return this._referee.useFaceWeights;
        }// end function

        override public function set useFaceWeights(param1:Boolean) : void
        {
            this._referee.useFaceWeights = param1;
            return;
        }// end function

        override public function get autoDeriveVertexTangents() : Boolean
        {
            return this._referee.autoDeriveVertexTangents;
        }// end function

        override public function set autoDeriveVertexTangents(param1:Boolean) : void
        {
            this._referee.autoDeriveVertexTangents = param1;
            return;
        }// end function

        override public function getVertexBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
        {
            return this._referee.getVertexBuffer(param1, param2);
        }// end function

        override public function getUVBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
        {
            return this._referee.getUVBuffer(param1, param2);
        }// end function

        override public function getSecondaryUVBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
        {
            return this._referee.getSecondaryUVBuffer(param1, param2);
        }// end function

        override public function getVertexNormalBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
        {
            return this._referee.getVertexNormalBuffer(param1, param2);
        }// end function

        override public function getVertexTangentBuffer(param1:Context3D, param2:uint) : VertexBuffer3D
        {
            return this._referee.getVertexTangentBuffer(param1, param2);
        }// end function

        override public function getIndexBuffer(param1:Context3D, param2:uint) : IndexBuffer3D
        {
            return this._referee.getIndexBuffer(param1, param2);
        }// end function

        override public function clone() : SubGeometry
        {
            throw new Error("away3d.core.base.LodSubGeometry - clone : not implemented");
        }// end function

        override public function scale(param1:Number) : void
        {
            var _loc_2:SubGeometry = null;
            for each (_loc_2 in this._levels)
            {
                
                _loc_2.scale(param1);
            }
            return;
        }// end function

        override public function scaleUV(param1:Number) : void
        {
            var _loc_2:SubGeometry = null;
            for each (_loc_2 in this._levels)
            {
                
                _loc_2.scaleUV(param1);
            }
            return;
        }// end function

        override public function dispose() : void
        {
            var _loc_1:SubGeometry = null;
            for each (_loc_1 in this._levels)
            {
                
                _loc_1.dispose();
            }
            return;
        }// end function

        override public function get vertexData() : Vector.<Number>
        {
            return this._referee.vertexData;
        }// end function

        override public function updateVertexData(param1:Vector.<Number>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - updateVertexData : can\'t be called on LodSG");
        }// end function

        override protected function invalidateBounds() : void
        {
            if (this._referee.parentGeometry)
            {
                this._referee.parentGeometry.invalidateBounds(this);
            }
            return;
        }// end function

        override public function get UVData() : Vector.<Number>
        {
            return this._referee.UVData;
        }// end function

        override public function get secondaryUVData() : Vector.<Number>
        {
            return this._referee.secondaryUVData;
        }// end function

        override public function updateUVData(param1:Vector.<Number>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - updateUVData : can\'t be called on LodSG");
        }// end function

        override public function updateSecondaryUVData(param1:Vector.<Number>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - updateSecondaryUVData : can\'t be called on LodSG");
        }// end function

        override public function get vertexNormalData() : Vector.<Number>
        {
            return this._referee.vertexNormalData;
        }// end function

        override public function updateVertexNormalData(param1:Vector.<Number>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - vertexNormalData : can\'t be called on LodSG");
        }// end function

        override public function get vertexTangentData() : Vector.<Number>
        {
            return this._referee.vertexTangentData;
        }// end function

        override public function updateVertexTangentData(param1:Vector.<Number>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - vertexNormalData : can\'t be called on LodSG");
        }// end function

        override public function get indexData() : Vector.<uint>
        {
            return this._referee.indexData;
        }// end function

        override public function updateIndexData(param1:Vector.<uint>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - vertexNormalData : can\'t be called on LodSG");
        }// end function

        override function get faceNormalsData() : Vector.<Number>
        {
            return this._referee.faceNormalsData;
        }// end function

        override function get parentGeometry() : Geometry
        {
            return this._referee.parentGeometry;
        }// end function

        override function set parentGeometry(param1:Geometry) : void
        {
            this._referee.parentGeometry = param1;
            return;
        }// end function

        override protected function invalidateBuffers(param1:Vector.<Boolean>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - invalidateBuffers : can\'t call on LodSG");
        }// end function

        override protected function disposeVertexBuffers(param1:Vector.<VertexBuffer3D>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - disposeVertexBuffers : can\'t call on LodSG");
        }// end function

        override protected function disposeIndexBuffers(param1:Vector.<IndexBuffer3D>) : void
        {
            throw new Error("away3d.core.base.LodSubGeometry - disposeIndexBuffers : can\'t call on LodSG");
        }// end function

    }
}
