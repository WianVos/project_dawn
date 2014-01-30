'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  controller('StatusPoller', [ '$scope', '$http', '$timeout',
    function($scope, $http, $timeout) {
      var poller = function() {
        $timeout(poller, 2000);
        $http({
          method : 'GET',
          url : 'http://127.0.0.1:9292/status',
        }).success(function(data, status, headers, config) {
          delete $scope.sbunreach;
          $scope.sbreach = "true";
        }).error(function(data, status, headers, config) {
          delete $scope.sbreach;
          $scope.sbunreach = "true";
        });
      } 
      poller();
    }
  ])

  .controller('MyCtrl2', [function() {

  }])
  .controller('Aanvragen', [ '$scope', '$http', '$window',
    function($scope, $http, $window) {
      $scope.aanvraag = { 'action':'create', 'middleware' : { 'db2' : { 'include':'false'}, 'mq': { 'include':'false'}, 'il': { 'include':'false' } } };
      $scope.submitaanvraag = function() {
        $http({
          method : 'POST',
          url : 'http://127.0.0.1:9292/jobs/order',
          data : $scope.aanvraag,
          headers : {'Content-Type': 'application/json'}
        }).success(function(data, status, headers, config) {
          $scope.data = data;
        }).error(function(data, status, headers, config) {
          $scope.status = status;
          alert(data);
        });
      }
      $scope.reload = function() {
        $window.location.reload();
      }
    }
  ])
  .controller('Hiera', [ '$scope', '$http',
    function($scope, $http) {
      $scope.getitems = function() {
        $http({
          method : 'GET',
          url : 'http://se94alm015.k94.kvk.nl:8082/query/puppet/hiera',
        }).success(function(data, status, headers, config) {
          $scope.data = data;
        }).error(function(data, status, headers, config) {
          $scope.data = headers;
        });
      }
    }
  ])
  .controller('Globalstatus', [ '$scope', '$http',
    function($scope, $http) {
      $scope.loading = true;
      $http({
        url: 'http://127.0.0.1:9292/jobs/status',
        method: "GET",
      }).success(function(data, status, headers, config) {
        $scope.data = data;
        $scope.loading = false;
      }); 
    }   
  ]); 
