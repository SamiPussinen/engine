jQuery = require('jquery')
$ = jQuery
bootstrap = require('bootstrap-jquery')
THREE = require('three')
OrbitControls = require('three-orbit-controls')(THREE)

global.engine = {
    camera : undefined
    controls : undefined
    renderer : undefined
    scene : undefined
    viewportElement : $('#viewport-element')
    lightAnchor : undefined
    
    init : () ->
        that = this
        @renderer = new THREE.WebGLRenderer()
        #renderer.setPixelRatio( window.devicePixelRatio )
        @renderer.setSize( @viewportElement.width(), @viewportElement.height() )
        @viewportElement.append( @renderer.domElement )
        @camera = new THREE.PerspectiveCamera( 70, @viewportElement.width() / @viewportElement.height(), 1, 100000)
        @camera.position.z = 500
        @camera.aspect = @viewportElement.width() / @viewportElement.height()
        @camera.updateProjectionMatrix()
        @camera.lookAt(new THREE.Vector3())
        @controls = new OrbitControls(@camera)
        @scene = new THREE.Scene()
        loader = new THREE.JSONLoader();
        loader.load( "./OikeaKuutio.js", ( geometry, material ) ->
            console.log(material)
            that.assignUVs(geometry) if (geometry.faceVertexUvs[0].length == 0 && material[0].map != undefined)
            materials = new THREE.MeshFaceMaterial(material);
            mesh = new THREE.Mesh( geometry, new THREE.MeshFaceMaterial( material ) )
            mesh.scale.set( 10, 10, 10 )
            that.scene.add( mesh )
        )
        ambientLight = new THREE.AmbientLight( 0x404040 )
        @scene.add( ambientLight )
    
        @lightAnchor = new THREE.Object3D()
        @scene.add(@lightAnchor)
    
        pointLightRedContainer = new THREE.Mesh(new THREE.SphereGeometry( 5, 32, 32 ), new THREE.MeshBasicMaterial( {color:0xff0000} ))
        pointLightRedContainer.position.set( 500, 500, 500 );
        @lightAnchor.add(pointLightRedContainer)
    
        pointLightGreenContainer = new THREE.Mesh(new THREE.SphereGeometry( 5, 32, 32 ), new THREE.MeshBasicMaterial( {color:0x00ff00} ))
        pointLightGreenContainer.position.set( -500, -500, -500 );
        @lightAnchor.add(pointLightGreenContainer)
    
        pointLightRed = new THREE.PointLight( 0xff0000, 1, 0 )
        pointLightRedContainer.add(pointLightRed)
    
        pointLightGreen = new THREE.PointLight( 0x00ff00, 1, 1000 )
        pointLightGreenContainer.add(pointLightGreen)
    
        window.addEventListener( 'resize', -> global.engine.onWindowResize.apply(that) )
        @animate()
        @initialized()

    onWindowResize : () ->
        @camera.aspect = @viewportElement.width() / @viewportElement.height()
        @camera.updateProjectionMatrix()
        @renderer.setSize(@viewportElement.width(), @viewportElement.height())

    animate : () ->
        that = this
        requestAnimationFrame( -> global.engine.animate.apply(that) )
        @lightAnchor.rotation.y += 0.01
        @renderer.render( @scene, @camera )
    
    initialized : () ->
        return "Engine Initialized."
    
    assignUVs : ( geometry ) ->
        geometry.computeBoundingBox()
        max = geometry.boundingBox.max
        min = geometry.boundingBox.min
        offset = new THREE.Vector2(0 - min.x, 0 - min.y)
        range = new THREE.Vector2(max.x - min.x, max.y - min.y)
        geometry.faceVertexUvs[0] = []
        faces = geometry.faces
        for element in geometry.faces
            v1 = geometry.vertices[element.a]
            v2 = geometry.vertices[element.b]
            v3 = geometry.vertices[element.c]
            geometry.faceVertexUvs[0].push([
                new THREE.Vector2( ( v1.x + offset.x ) / range.x , ( v1.y + offset.y ) / range.y ),
                new THREE.Vector2( ( v2.x + offset.x ) / range.x , ( v2.y + offset.y ) / range.y ),
                new THREE.Vector2( ( v3.x + offset.x ) / range.x , ( v3.y + offset.y ) / range.y )
            ])
        geometry.uvsNeedUpdate = true
}

global.engine.init()