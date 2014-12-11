define([
    'f7',
],  (F7) ->
    'use strict';
    app=new F7(
            modalTitle: 'City',
#            swipePanel: 'left',
            animateNavBackIcon: true
            pushState: true
            #     Hide and show indicator during ajax requests
            onAjaxStart: (xhr) ->
              app.showIndicator();
            onAjaxComplete:  (xhr)->
              app.hideIndicator();

    )
    app.hideIndicator();
    return app
);