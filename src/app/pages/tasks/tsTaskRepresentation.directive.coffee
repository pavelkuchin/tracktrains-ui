###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  @desc Task representation (action enable/disable/delete)
  @example
  <ts-task-edit
    task="task"
    edit-mode="editEnabled"
    enable="enableTask(task)"
    disable="disableTask(task)"
    delete="deleteTask(task)">

  task - the new or existing task
  edit-mode - the flag that provides information about state change
              (usually it is used on page layer in order to hide component)
  enable - the reference to the controller function for disabling task
  disable - the reference to the controller function for enabling task
  delete - the reference to the controller function for deleting task
###
tsTaskRepresentation = () ->
  templateUrl: 'app/pages/tasks/tsTaskRepresentation.directive.html'
  restrict: 'EA'
  scope:
    task: '='
    editMode: '='
    enable: '&'
    disable: '&'
    delete: '&'
  link: tsTaskRepresentationLink
# XXX Needs refactoring because this function is in the global scope
tsTaskRepresentationLink = (scope, element, attrs) ->
  task = scope.task

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
    scope.editMode = true

  scope.tsTaskEnable = () ->
    scope.enable({task: task}).then () ->
      __calculateBackgroundColor(task)

  scope.tsTaskDisable = () ->
    scope.disable({task: task}).then () ->
      __calculateBackgroundColor(task)

  scope.tsTaskDelete = () ->
    scope.delete({task: task})

angular
  .module('trackSeatsApp')
  .directive('tsTaskRepresentation', tsTaskRepresentation)
