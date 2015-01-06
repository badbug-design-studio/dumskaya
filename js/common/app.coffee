define([
    'f7',
],  (F7) ->
    'use strict';
    debug=1
    app=new F7(
            modalTitle: 'Думская',
#            swipePanel: 'left',
            animateNavBackIcon: true
            pushState: false
#            fastClicks: false
            ajaxLinks: ".ajax"
            #     Hide and show indicator during ajax requests
            onAjaxStart: (xhr) ->
              app.showIndicator();
            onAjaxComplete:  (xhr)->
              app.hideIndicator();

    )
    if(!debug)
      console.log=()->
        return
    return app
);