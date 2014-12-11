define([
    'app',
],  (app) ->
    'use strict';
    selector='.view-main'
    console.log
    return  app.addView(selector, {
          dynamicNavbar: true,
    #      animatePages:false
        })

);