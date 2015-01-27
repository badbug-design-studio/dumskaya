define([
    'require',
    '_'
    'f7'
    'app',
    'routes',
    'layout'
    'sync'
    'helpers'
    'cache'
],  (require,_, f7, app,routes,layout,SyncServices,Helpers,Cache)->
    'use strict';
  #  document.addEventListener('deviceready', onDeviceReady);
    onDeviceReady =  ()->
      window.baseApplication = {
            f7app: app,
            mainLayout: layout
            router: routes,
            sync: new SyncServices
            helpers: new Helpers
            cache: new Cache(()->
              routes.loadPage('list')
              routes.loadPage('menu')
              app.hideIndicator();
            )
      }


#    @todo ondeviceready in cordova
    setTimeout(()->
        onDeviceReady()
    ,300)


)
