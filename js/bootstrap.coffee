define([
    'require',
    'f7'
    'app',
    'routes',
    'layout'
],  (require, f7, app,Routes,layout)->
    'use strict';
  #  document.addEventListener('deviceready', onDeviceReady);
    onDevieReady =  (document)->
      window.baseApplication = {
            f7app: app,
            mainLayout: layout
            router: new Routes,
      }

      baseApplication.router.loadPage('index', {model:{},viewParams:{swipeBackPage:false}})


    require(['domReady!'],
      console.log('dom ready!')
      onDevieReady(document)
    );

)
