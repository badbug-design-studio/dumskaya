define([
    'require',
    '_'
    'f7'
    'app',
    'routes',
    'layout'
    'sync'
    'helpers'
],  (require,_, f7, app,Routes,layout,SyncServices,Helpers)->
    'use strict';
  #  document.addEventListener('deviceready', onDeviceReady);
    onDevieReady =  (document)->
      window.baseApplication = {
            f7app: app,
            mainLayout: layout
            router: new Routes,
            sync: new SyncServices
            helpers: new Helpers
      }
      #now in template use {{variable}}
#      _.templateSettings = {
#        interpolate: /\{\{(.+?)\}\}/g
#      };
#      what view render by default
      baseApplication.router.loadPage('list')
#      baseApplication.sync.request('http://dumskaya.net/rsstv/').then(
#        (result)->
#          console.log result
#      )


    require(['domReady!'],()->
      onDevieReady(document)
    );

)
