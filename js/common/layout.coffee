define([
    'app',
],  (app) ->
    'use strict';
    console.log app
    return  app.addView('.view-main', {
          dynamicNavbar: true,
    #      animatePages:false
        })

);