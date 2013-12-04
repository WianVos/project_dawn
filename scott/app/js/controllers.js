'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  controller('MyCtrl1', [function() {

  }])
  .controller('MyCtrl2', [function() {

  }])
  .controller('Aanvragen', [ '$scope', '$http',
    function($scope, $http) {
      $scope.aanvraag = { 'action':'create' };
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
    }
  ]);
