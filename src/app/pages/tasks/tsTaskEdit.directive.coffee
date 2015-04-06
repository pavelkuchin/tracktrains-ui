###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  @desc The directive that represent the task edit form
  @example
  <ts-task-edit
    save="save()"
    task="task"
    edit-mode="editEnabled"
    get-cities="getCities(city)"
    get-trains="getTrains(train)">

  save - the reference to the controller's save() method
  task - the new or existing task
  edit-mode - the flag that provides information about state change
              (usually it is used on page layer in order to hide component)
  get-cities - the reference to controller method that will be used to filter cities
  get-trains - the reference to controller method that will be used to filter trains
###
tsTaskEdit = () ->
  templateUrl: 'app/pages/tasks/tsTaskEdit.directive.html'
  restrict: 'EA'
  scope:
    task: '='
    editMode: '='
    save: '&'
    getCities: '&'
    getTrains: '&'
  link: tsTaskEditLink
# XXX Needs refactoring because this function is in the global scope
tsTaskEditLink = (scope, element, attrs) ->
  scope.opened = false
  scope.dateOptions =
    startingDay: 1
  scope.minDate = new Date()

  scope.toggleDatepicker = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()

    scope.opened = !scope.opened

  scope.saveEditing = () ->
    copyScopeToTask()
    scope.save({task: scope.task})
    scope.editMode = false

  scope.cancelEditing = () ->
    copyTaskToScope()
    scope.editMode = false

  copyTaskToScope = () ->
    task = scope.task
    scope.departure_date = task.departure_date
    scope.departure_point = task.departure_point
    scope.destination_point = task.destination_point
    scope.train = task.train
    scope.car = task.car
    scope.seat = task.seat

  copyScopeToTask = () ->
    task = scope.task
    task.departure_date = scope.departure_date
    task.departure_point = scope.departure_point
    task.destination_point = scope.destination_point
    task.train = scope.train
    task.car = scope.car
    task.seat = scope.seat
  # XXX Require refactoring
  copyTaskToScope()

angular
  .module('trackSeatsApp')
  .directive('tsTaskEdit', tsTaskEdit)
