#
# @desc task edit directive
# @example <ts-task-edit save="save()" task="task">
#
tsTaskEdit = () ->
  templateUrl: 'app/pages/tasks/tsTaskEdit.html'
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
