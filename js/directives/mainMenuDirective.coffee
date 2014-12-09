define([
    'angular',
    'app'
],  (angular,app)->

      return app.directive('mainMenu',()->
          console.log 111
          return    {
              restrict : 'E'
              replace : true
              templateUrl : './js/templates/headerDirectiveTemplate.html'
          }
      )

);