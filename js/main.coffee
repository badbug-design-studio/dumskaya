require.config({
    urlArgs : 'antichache'
# alias libraries paths
    paths:
        domReady: './libs/domReady'
        f7: './libs/framework7'
        _: './libs/underscore'
        app:'./common/app'
        layout:'./common/layout'
        routes:"./common/routes"
        baseController:"./common/baseController"

#     angular does not support AMD out of the box, put it in a shim
    shim:
       f7:
         exports: 'Framework7'
       underscore:
         exports: '_'

       routes:
        deps:["f7"]

       app:
        deps:["f7"]

       layout:
        deps:["app"]





#    kick start application
    deps: ['./bootstrap']
});