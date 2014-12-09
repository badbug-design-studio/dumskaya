define([
    'angular'
    'app',
],  (angular,app) ->

    app.provider('appState', () ->
      states=
          listsPage:
             default:true
             url:'/'
             views:
                 'news':
                   templateUrl:  './js/templates/newsList.html'
                   controller:($scope,$ionicSlideBoxDelegate) ->
                        $ionicSlideBoxDelegate.show-pager=false
                  'blogs':
                   templateUrl:  './js/templates/blogList.html'
                   controller:($scope,$ionicSlideBoxDelegate) ->
                        $ionicSlideBoxDelegate.show-pager=false
          newsItem:
             url:'/news/:id'
             templateUrl: "./js/templates/newsItemTemplate.html"




      return {
         getAllStates:()->
             return states

         $get: (stateName) ->
              if angular.isDefined(states[stateName])
                return states[stateName]
              else return false
      };
 );
)