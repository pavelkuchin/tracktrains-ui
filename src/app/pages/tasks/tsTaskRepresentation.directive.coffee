#
# @desc Task representation support of edit/enable/disable/delete
# @example <tt-task-representation save="save()" delete="delete()" task="task">
#
tsTaskRepresentation = () ->
  templateUrl: 'app/pages/tasks/tsTaskRepresentation.html'
  restrict: 'EA'
  scope:
    task: '='
    edit: '&'
    enable: '&'
    disable: '&'
    delete: '&'
  link: tsTaskRepresentationLink
# XXX Needs refactoring because this function is in the global scope
tsTaskRepresentationLink = (scope, element, attrs) ->
  task = scope.task
  scope.isEdit = false
  scope.dt = null
  scope.opened = false
  scope.dateOptions =
    startingDay: 1
  scope.minDate = new Date()

  __calculateBackgroundColor = (task) ->
    if task
      if task.is_active and not task.is_successful
        scope.backgroundColor = 'ts-task-active-searching'
      else if task.is_active and task.is_successful
        scope.backgroundColor = 'ts-task-active-found'
      else if not task.is_active
        scope.backgroundColor = 'ts-task-inactive'

  __calculateBackgroundColor(task)

  scope.tsTaskEdit = () ->
    #scope.edit({task: task})
    scope.isEdit = true

  scope.tsTaskEnable = () ->
    scope.enable({task: task}).then () ->
      __calculateBackgroundColor(task)

  scope.tsTaskDisable = () ->
    scope.disable({task: task}).then () ->
      __calculateBackgroundColor(task)

  scope.tsTaskDelete = () ->
    scope.delete({task: task})

  scope.toggleDatepicker = ($event) ->
    $event.preventDefault()
    $event.stopPropagation()

    scope.opened = !scope.opened

  scope.saveEditing = () ->
    scope.isEdit = false

  scope.cancelEditing = () ->
    scope.isEdit = false

angular
  .module('trackSeatsApp')
  .directive('tsTaskRepresentation', tsTaskRepresentation)
