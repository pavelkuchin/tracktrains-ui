class NavigationCtrl
  constructor: () ->
    @navCollapsed = true

  toggleNavCollapsed: () ->
    @navCollapsed = !@navCollapsed

angular.module('trackSeatsApp').controller('NavigationCtrl', NavigationCtrl)
