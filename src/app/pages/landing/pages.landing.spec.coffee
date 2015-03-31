describe 'PagesLandingCtrl', () ->
  beforeEach(module('trackSeatsApp'))

  it 'Do not redirect if user does not authenticated',
    inject ($rootScope, $controller, NAVIGATION) ->
      stubState = jasmine.createSpyObj('$state', ['go'])

      scope = $rootScope.$new()
      controller = $controller('PagesLandingCtrl',
        $scope: scope
        $state: stubState
        session:
          $state: stubState
          authenticated: false
          user: {}
      )

      expect(stubState.go)
        .not.toHaveBeenCalled()

  it 'Redirect to NAVIGATION.AUTHENTICATED_DEFAULT_STATE if authenticated',
    inject ($rootScope, $controller, NAVIGATION) ->
      stubState = jasmine.createSpyObj('$state', ['go'])

      scope = $rootScope.$new()
      controller = $controller('PagesLandingCtrl',
        $scope: scope
        $state: stubState
        session:
          authenticated: true
          user: {}
      )

      expect(stubState.go)
        .toHaveBeenCalledWith(NAVIGATION.AUTHENTICATED_DEFAULT_STATE)
