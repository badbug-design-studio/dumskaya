define([
    'require',
    'angular',
    'app',
    'routes',
    'mainMenuDirective'
],  (require, ng, app)->
    'use strict';
  #  document.addEventListener('deviceready', onDeviceReady);
    onDevieReady =  (document)->
        console.log document
        ng.bootstrap(document, ['iApp']);


    require(['domReady!'],
      console.log('dom ready!')
      onDevieReady(document)
    );

)
