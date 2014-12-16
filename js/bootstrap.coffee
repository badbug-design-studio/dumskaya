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
],  (require,_, f7, app,Routes,layout,SyncServices,Helpers,Cache)->
    'use strict';
  #  document.addEventListener('deviceready', onDeviceReady);
    onDevieReady =  (document)->
      window.baseApplication = {
            f7app: app,
            mainLayout: layout
            router: new Routes,
            sync: new SyncServices
            helpers: new Helpers
            cache: new Cache
      }
      #now in template use {{variable}}
#      _.templateSettings = {
#        interpolate: /\{\{(.+?)\}\}/g
#      };
#      what view render by default
      baseApplication.router.loadPage('list')
      baseApplication.router.loadPage('menu')

#      baseApplication.sync.request('http://dumskaya.net/rsstv/').then(
#        (result)->
#          console.log result
#      )


    require(['domReady!'],()->
      onDevieReady(document)
    );

)
