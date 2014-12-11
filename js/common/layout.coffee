define([
    'app',
],  (app) ->
    'use strict';
    selector='.view-main'
    return  app.addView(selector, {
          dynamicNavbar: true,
    #      animatePages:false
        })

);