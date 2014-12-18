define([
    'f7',
],  (F7) ->
    'use strict';
    app=new F7(
            modalTitle: 'Dumskaya',
#            swipePanel: 'left',
            animateNavBackIcon: true
            pushState: false
            fastClicks: false
#            ajaxLinks: "ajax"
            #     Hide and show indicator during ajax requests
            onAjaxStart: (xhr) ->
              app.showIndicator();
            onAjaxComplete:  (xhr)->
              app.hideIndicator();

    )
    return app
);