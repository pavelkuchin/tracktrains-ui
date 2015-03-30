describe 'LayoutAlertsCtrl', () ->
  beforeEach(module('trackSeatsApp'))

  describe 'controller.alerts', () ->
    beforeEach(inject(($rootScope, $controller) =>
      alertsService =
        alerts:
          messages:[
              type: 'type1'
              msg: 'msg1'
            ,
              type: 'type2'
              msg: 'msg2'
            ,
              type: 'type3'
              msg: 'msg3'
          ]

      @scope = $rootScope.$new()
      @controller = $controller('LayoutAlertsCtrl',
        $scope: @scope
        AlertsService: alertsService
      )
    ))

    it 'returns alerts list', () =>
      expect(@controller.alerts.messages[0].type).toEqual('type1')
      expect(@controller.alerts.messages[0].msg).toEqual('msg1')

    it 'closes the first alert', () =>
      expect(@controller.alerts.messages.length).toEqual(3)
      @controller.closeAlert(0)
      expect(@controller.alerts.messages[0].type).toEqual('type2')
      expect(@controller.alerts.messages[0].msg).toEqual('msg2')
