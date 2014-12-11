define([
    'require',
    '_'
    'f7'
    'app',
    'routes',
    'layout'
],  (require,_, f7, app,Routes,layout)->
    'use strict';
  #  document.addEventListener('deviceready', onDeviceReady);
    onDevieReady =  (document)->
      window.baseApplication = {
            f7app: app,
            mainLayout: layout
            router: new Routes,
      }
      #now in template use {{variable}}
      _.templateSettings = {
        interpolate: /\{\{(.+?)\}\}/g
      };
#      what view render by default
      baseApplication.router.loadPage('newsList', {model:{},viewParams:{swipeBackPage:false}})


    require(['domReady!'],()->
      onDevieReady(document)
    );

)
