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
  link: tsTaskEditLink
# XXX Needs refactoring because this function is in the global scope
tsTaskEditLink = (scope, element, attrs) ->
  task = scope.task
  scope.dt = null
  scope.opened = false
  scope.dateOptions =
    startingDay: 1
  scope.minDate = new Date()

  scope.cities = [
    'Minsk',
    'Gomel',
    'Brest',
    'Mogilev',
    'Vitebsk',
    'Grodno'
  ]
  scope.trains = [
    'T345 Gomel - Minsk (14:33)',
    'T564 Odessa - Minsk (15:42)',
    'B493 Kiev - Minsk (12:34)'
  ]

  if task
    scope.dt = task.departure_date
    scope.departure = task.departure_point
    scope.destination = task.destination_point

  scope.toggleDatepicker = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()

    scope.opened = !scope.opened

  scope.saveEditing = () ->
    scope.save({task: task})
    scope.editMode = false

  scope.cancelEditing = () ->
    scope.editMode = false

angular
  .module('trackSeatsApp')
  .directive('tsTaskEdit', tsTaskEdit)
