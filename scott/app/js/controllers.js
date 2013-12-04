'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
  controller('MyCtrl1', [function() {

  }])
  .controller('MyCtrl2', [function() {

  }])
  .controller('Aanvragen', [ '$scope', '$http',
    function($scope, $http) {
      $scope.aanvraag = { 'woot':'woot' };
      $scope.submitaanvraag = function() {
        $http({
          method : 'POST',
          url : 'http://127.0.0.1:9292/jobs/order',
          data : $scope.aanvraag
        })
      }
    }
  ]);
