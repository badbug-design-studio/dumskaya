define([
    'app',
],  (app) ->
    'use strict';
    selector='.view-main'
    console.log
    return  app.addView(selector, {
          dynamicNavbar: true,
          domCache: true
          #fastClicks: false
          #animatePages:false
        })

);