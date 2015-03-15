#
# @desc Task representation support of edit/enable/disable/delete
# @example <tt-task-representation save="save()" delete="delete()" task="task">
#
tsTaskRepresentation = () ->
  templateUrl: 'app/pages/tasks/tsTaskRepresentation.html'
  restrict: 'EA'
  scope:
    task: '='
    save: '&'
    delete: '&'
  link: link
# XXX Refactor because this function is in global scope
link = (scope, element, attrs) ->
  task = scope.task
  if task
    if task.is_active and not task.is_successful
      scope.backgroundColor = 'ts-task-active-searching'
    else if task.is_active and task.is_successful
      scope.backgroundColor = 'ts-task-active-found'
    else if not task.is_active
      scope.backgroundColor = 'ts-task-inactive'

angular
  .module('trackSeatsApp')
  .directive('tsTaskRepresentation', tsTaskRepresentation)
