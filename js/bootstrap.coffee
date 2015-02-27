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
              setTimeout(()->
                routes.loadPage('menu')
              ,1000)
              app.hideIndicator();
            )
      }

    if(typeof window.cordova=="undefined")
      setTimeout(()->
          onDeviceReady()
      ,300)
    else
      document.addEventListener("deviceready", onDeviceReady, false);


)
