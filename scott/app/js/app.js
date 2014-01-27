'use strict';


// Declare app level module which depends on filters, and services
angular.module('myApp', [
  'ngRoute',
  'myApp.filters',
  'myApp.services',
  'myApp.directives',
  'myApp.controllers'
]).
config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/', {templateUrl: 'partials/index.html', controller: 'StatusPoller'});
  $routeProvider.when('/view2', {templateUrl: 'partials/partial2.html', controller: 'MyCtrl2'});
  $routeProvider.when('/aanvraag', {templateUrl: 'partials/aanvraag.html', controller: 'Aanvragen'});
  $routeProvider.when('/hiera', {templateUrl: 'partials/hiera.html', controller: 'Hiera'});
  $routeProvider.when('/status', {templateUrl: 'partials/status.html', controller: 'Globalstatus'});
  $routeProvider.otherwise({redirectTo: '/'});
}]);
