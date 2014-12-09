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
          config=
                  url: state.url
          if state.views #if complex view (layout)
            config.views=state.views
          else config.templateUrl=state.templateUrl


          $stateProvider.state(key,config)
          if(state.default)
            $urlRouterProvider.otherwise(state.url);
  );

);