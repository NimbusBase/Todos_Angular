/*global angular */
/*jshint unused:false */
'use strict';

/**
 * The main TodoMVC app module
 *
 * @type {angular.Module}
 */
var todomvc = angular.module('todomvc', ['ngRoute'])
	.config(function ($routeProvider) {
		$routeProvider.when('/', {
			controller: 'TodoCtrl',
			templateUrl: 'todomvc-index.html'
		}).when('/:status', {
			controller: 'TodoCtrl',
			templateUrl: 'todomvc-index.html'
		}).otherwise({
			redirectTo: '/'
		});
	});


var sync_object = {
	"GDrive": {
		"key": "988787464942-rg9g7tftmhj7f01ktb79ueqrg3uuiv7p.apps.googleusercontent.com",
		"scope": "https://www.googleapis.com/auth/drive",
		"app_name": "nimbus-todo-demo"
	},
	"Dropbox": {
		"key": "qzoixw7xmcn95kd",
		"secret": "vfme6di5iwslpep",
		"app_name": "nimbus-todo-demo"
	},
    "synchronous": true
};
Nimbus.Auth.setup(sync_object);


