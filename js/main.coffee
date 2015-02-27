require.config({
    urlArgs : 'antichache'
    baseUrl:"./js/"
# alias libraries paths
    paths:
        domReady: './libs/domReady'
        f7: './libs/framework7'
        hammer:"./libs/hammer"
        _: './libs/underscore'
        imgCache: './libs/imgCache'
        xml2json: './libs/xml2json'

        app:'./common/app'
        layout:'./common/layout'
        routes:"./common/routes"
        baseView:"./common/baseView"
        categoryView:"./common/categoryView"
        sync:"./common/sync"
        mainTabs:"./common/tabs"
        helpers:"./common/helpers"
        cache:"./common/cache"

#     angular does not support AMD out of the box, put it in a shim
    shim:
       f7:
         exports: 'Framework7'
       _:
         exports: '_'

       imgCache:
         exports: 'ImgCache'

       routes:
        deps:["f7","_"]

       app:
         deps:["f7","_", "hammer","mainTabs"]

       sync:
         deps:["f7","_",'xml2json']

       baseView:
         deps:["f7"]

       categoryView:
         deps:["f7"]

       layout:
        deps:["app","baseView","categoryView"]





#       categoryView:
#        deps:["baseView"]





#    kick start application
    deps: ['bootstrap']
});