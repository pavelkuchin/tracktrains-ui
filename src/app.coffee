configure = ($httpProvider, $stateProvider, $urlRouterProvider, $locationProvider, AUTH_EVENTS) ->
  $httpProvider.interceptors.push ($q, $rootScope, AlertsService) ->
    'responseError': (rejection) ->
      if rejection.status == 401
        $rootScope.$emit(AUTH_EVENTS.UNAUTHENTICATED)
      if rejection.status >= 500
        AlertsService.showAlert(
          'Something went wrong, we will try to fix it, please try later.',
          AlertsService.TYPE.ERROR
        )
      if rejection.status == 0
        AlertsService.showAlert(
          'Connection troubles, please try later.',
          AlertsService.TYPE.ERROR
        )
      $q.reject(rejection)

  $httpProvider.defaults.xsrfCookieName = 'csrftoken'
  $httpProvider.defaults.xsrfHeaderName = 'X-CSRFToken'

  $locationProvider.html5Mode(true)

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
      templateUrl: "app/pages/landing/pages.landing.template.html"
      controller: "PagesLandingCtrl as landing"
    )
    .state("tasks",
      parent: "root"
      url: "/tasks"
      templateUrl: "app/pages/tasks/pages.tasks.template.html"
      controller: "PagesTasksCtrl as tasks"
    )
    .state("settings",
      parent: "root"
      url: "/settings"
      templateUrl: "app/pages/settings/pages.settings.template.html"
      controller: "PagesSettingsCtrl as settings"
    )
    .state("signup",
      parent: "root"
      url: "/signup/:invite/"
      templateUrl: "app/pages/signup/pages.signup.template.html"
      controller: "PagesSignupCtrl as signup"
    )

initialization = (AUTH_EVENTS, NAVIGATION, $rootScope, $state, AuthService, AlertsService) ->
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
            toState.name != NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE and
            toState.parent != 'root'
          event.preventDefault()
  )

angular.module 'trackSeatsApp', [
    'angular-loading-bar'
    'ui.bootstrap'
    'ui.router',
    'ngMessages'
  ]
.config ['$httpProvider', '$stateProvider', '$urlRouterProvider',
         '$locationProvider', 'AUTH_EVENTS', configure]
.run ['AUTH_EVENTS' ,'NAVIGATION' ,'$rootScope' ,'$state',
      'AuthService', 'AlertsService', initialization]
