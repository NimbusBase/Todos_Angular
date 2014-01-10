/*global todomvc, angular */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the todoStorage service
 * - exposes the model to the template and provides event handlers
 */
todomvc.controller('TodoCtrl', function TodoCtrl($scope, $routeParams, todoStorage, filterFilter) {
	var todos = $scope.todos = todoStorage.get();

	$scope.newTodo = '';
	$scope.editedTodo = null;


 

	Nimbus.Auth.app_ready_func = function(){
		if(Nimbus.Auth.authorized()){
			$('div.cover').fadeOut();

			$scope.Todos = Nimbus.Model.setup("Todos",['title', 'completed']);
			
			$scope.Todos.sync_all(function(){
				var data = $scope.Todos.all();
				for (var i = 0; i < data.length; i++) {
					todos.push(data[i]);
				};
				window.TO = $scope.Todos;
				$scope.$apply();
			});
			
		}
	}

	$scope.$watch('todos', function (newValue, oldValue) {
		$scope.remainingCount = filterFilter(todos, { completed: false }).length;
		$scope.completedCount = todos.length - $scope.remainingCount;
		$scope.allChecked = !$scope.remainingCount;
		if (newValue !== oldValue) { // This prevents unneeded calls to the local storage
			//todoStorage.put(todos);
		}
	}, true);

	// Monitor the current route for changes and adjust the filter accordingly.
	$scope.$on('$routeChangeSuccess', function () {
		var status = $scope.status = $routeParams.status || '';

		$scope.statusFilter = (status === 'active') ?
			{ completed: false } : (status === 'completed') ?
			{ completed: true } : null;
	});

	$scope.addTodo = function () {
		var newTodo = $scope.newTodo.trim();
		if (!newTodo.length) {
			return;
		}; 
		todos.push($scope.Todos.create({"title":newTodo,"completed":false}));
		//$scope.Todos.create({"title":newTodo,"completed":false});
		$scope.newTodo = '';
	};

	$scope.editTodo = function (todo) {
		$scope.editedTodo = todo;
		// Clone the original todo to restore it on demand.
		$scope.originalTodo = angular.extend({}, todo);
	};

	$scope.doneEditing = function (todo) {
		$scope.editedTodo = null;
		todo.title = todo.title.trim();
		var ob = $scope.Todos.find(todo.id);
		ob.title = todo.title;
		ob.save();
		if (!todo.title) {
			$scope.removeTodo(todo);
		}
	};

	$scope.revertEditing = function (todo) {
		todos[todos.indexOf(todo)] = $scope.originalTodo;
		$scope.doneEditing($scope.originalTodo);
	};

	$scope.removeTodo = function (todo) { 
		$scope.Todos.find(todo.id).destroy();
		todos.splice(todos.indexOf(todo), 1);
	};

	$scope.clearCompletedTodos = function () {
		$scope.todos = todos = todos.filter(function (val) {
			return !val.completed;
		});
	};

	$scope.markAll = function (completed) {
		todos.forEach(function (todo) {
			var ob = $scope.Todos.find(todo.id);
			ob.completed = !completed;
			ob.save();
			todo.completed = !completed;
		});
	};
	
	$scope.logout = function(){
		Nimbus.Auth.logout();
		window.location.reload();
	}

});
