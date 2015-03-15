angular.module 'trackSeatsApp', [
    'angular-loading-bar'
    'ui.bootstrap'
    'ui.router'
  ]
.config ($httpProvider, $stateProvider, $urlRouterProvider, AUTH_EVENTS) ->
  $httpProvider.interceptors.push ($q, $rootScope) ->
    'responseError': (rejection) ->
      if rejection.status == 401
        $rootScope.$emit(AUTH_EVENTS.UNAUTHENTICATED)
      $q.reject(rejection)
  $httpProvider.defaults.xsrfCookieName = 'csrftoken'
  $httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken'

  $urlRouterProvider.otherwise("/")

  $stateProvider
    .state("root",
      url: ""
      template: "<ui-view/>"
      abstract: true
      resolve:
        session: (AuthService) -> AuthService.checkAuthentication()
    )
    .state("landing",
      parent: "root"
      url: "/"
      templateUrl: "app/pages/landing/landing.html"
      controller: "PagesLandingCtrl as landing"
    )
    .state("tasks",
      parent: "root"
      url: "/tasks"
      templateUrl: "app/pages/tasks/tasks.html"
      controller: "PagesTasksCtrl as tasks"
    )
.run (AUTH_EVENTS, NAVIGATION, $rootScope, $state, AuthService, AlertsService) ->
  $rootScope.$on(AUTH_EVENTS.UNAUTHENTICATED, () ->
    AuthService.resetSession()
    $state.go(NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE)
  )
  $rootScope.$on(AUTH_EVENTS.AUTHENTICATED, () ->
    $state.go(NAVIGATION.AUTHENTICATED_DEFAULT_STATE)
  )
  AuthService.checkAuthentication().then (session) ->
    $rootScope.$on('$stateChangeStart',
      (event, toState, toParams, fromState, fromParams) ->
        AlertsService.clearAlerts()
        if session.authenticated and
            toState.name == NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE
          event.preventDefault()
        if not session.authenticated and
            toState.name != NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE
          event.preventDefault()
  )
