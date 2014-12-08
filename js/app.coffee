'use strict';

/* App Module */

app = angular.module('app', [
  'ngRoute',
  'ngAnimate',
  'ngTouch',
  'ngResource'
]);

app.config(['$routeProvider', ($routeProvider) ->

  $routeProvider.when('/news', {
    templateUrl: 'news/newsView.html',
    controller: 'newsCtrl'
  }).when('/', {
    templateUrl: '',
    controller: ''
  }).otherwise({
    redirectTo: '/'
  });
]);