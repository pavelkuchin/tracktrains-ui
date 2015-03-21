#
# @desc task edit directive
# @example <ts-task-edit save="save()" task="task">
#
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
