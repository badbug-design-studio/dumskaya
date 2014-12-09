define([
        'app',
        'appStateProvider'
],  (app)->
  'use strict';

  return app.config(($stateProvider,$urlRouterProvider,appStateProvider)->

        states=appStateProvider.getAllStates()
        keys=Object.keys(states)
        for key in keys
          state=states[key]
          $stateProvider.state(key, {
                  url: state.url
                  views: state.views

                })
          if(state.default)
            $urlRouterProvider.otherwise(state.url);
  );

);