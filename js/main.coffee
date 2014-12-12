require.config({
    urlArgs : 'antichache'
# alias libraries paths
    paths:
        domReady: './libs/domReady'
        f7: './libs/framework7'
        hammer:"./libs/hammer"
        _: './libs/underscore'

        app:'./common/app'
        layout:'./common/layout'
        routes:"./common/routes"
        baseView:"./common/baseView"
        sync:"./common/sync"

#     angular does not support AMD out of the box, put it in a shim
    shim:
       f7:
         exports: 'Framework7'
       _:
         exports: '_'

       routes:
        deps:["f7","_"]

       app:
         deps:["f7","_"]

       sync:
         deps:["f7","_"]

       layout:
        deps:["app"]





#    kick start application
    deps: ['./bootstrap']
});