define([
    'app',
],  (app) ->
    'use strict';
    selector='#view-main'
    return  app.addView(selector, {
          dynamicNavbar: true,
          domCache: true
          #fastClicks: false
          #animatePages:false
        })

);