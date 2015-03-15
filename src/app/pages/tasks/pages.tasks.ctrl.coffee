class PagesTasksCtrl extends SecurePages
  constructor: (dataService) ->
    @tasksList = []

    dataService.getTasks().then ({data}) =>
      @tasksList = @__itemsToMatrix(data.objects)

  __itemsToMatrix: (items, itemsInRow = 4) ->
    result = []
    tmp = []
    for item, i in items
      if (i % itemsInRow) == 0 and tmp.length
        result.push tmp
        tmp = []
      tmp.push item
    if tmp.length
      result.push tmp
    result


angular
  .module('trackSeatsApp')
  .controller('PagesTasksCtrl', PagesTasksCtrl)

PagesTasksCtrl.$inject = ['DataService']
