jQuery = require('jquery')
$ = jQuery
bootstrap = require('bootstrap-jquery')
THREE = require('three')

global.engine = {
    camera : undefined
    renderer : undefined
    mesh : undefined
    scene : undefined
    viewportElement : $('#viewport-element')
    last : 1.0
    
    init : () ->
        that = this
        @renderer = new THREE.WebGLRenderer()
        #renderer.setPixelRatio( window.devicePixelRatio )
        @renderer.setSize( @viewportElement.width(), @viewportElement.height() )
        @viewportElement.append( @renderer.domElement )
        @camera = new THREE.PerspectiveCamera( 70, @viewportElement.width(), @viewportElement.height(), 1, 1000)
        @camera.position.z = 400
        @camera.aspect = @viewportElement.width() / @viewportElement.height()
        @camera.updateProjectionMatrix()
        @scene = new THREE.Scene()
        @geometry = new THREE.BoxGeometry( 200, 200, 200)
        @material = new THREE.MeshBasicMaterial( {} )
        @mesh = new THREE.Mesh( @geometry, @material )
        @scene.add(@mesh)
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
        @mesh.rotation.x += @rotationFunction()
        @renderer.render( @scene, @camera )

    rotationFunction : () ->
        @last = Math.sin(@last)
    
    initialized : () ->
        return "Engine Initialized."
}

global.engine.init()