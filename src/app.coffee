
angular.module 'trackSeatsApp', [
    'angular-loading-bar'
    'ui.bootstrap'
    'ui.router'
  ]
.config ($httpProvider, $stateProvider, $urlRouterProvider, AUTH_EVENTS) ->
  $httpProvider.interceptors.push ($q, $rootScope) ->
    'responseError': (rejection) ->
      if rejection.status == 401
        $rootScope.$emit(AUTH_EVENTS.UNAUTHORIZED)
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
        session: (AuthService) -> AuthService.checkAuthorization()
      onEnter: (session, $state) ->
        if not session.authorized
          $state.go('landing')
    )
    .state("landing",
      url: "/"
      templateUrl: "app/pages/landing/landing.html"
      controller: "PagesLandingCtrl as landing"
      resolve:
        session: (AuthService) -> AuthService.checkAuthorization()
      onEnter: (session, $state) ->
        if session.authorized
          $state.go('tasks')
    )

    .state("tasks",
      parent: "root"
      url: "/tasks"
      templateUrl: "app/pages/tasks/tasks.html"
      controller: "PagesTasksCtrl as tasks"
    )
.run (AUTH_EVENTS, $rootScope, $state, SessionService, AuthService) ->
  $rootScope.$on(AUTH_EVENTS.UNAUTHORIZED, () ->
    SessionService.reset()
    $state.go('landing')
  )
  $rootScope.$on(AUTH_EVENTS.AUTHORIZED, () ->
    $state.go('tasks')
  )
