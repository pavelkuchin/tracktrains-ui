class DataService
  constructor: (@$http) ->

  signIn: (email, password) ->
    @$http.post('/v1/user/login/',{
      login: email
      password: password
    })

  signOut: () ->
    @$http.post('/v1/user/logout/', {})

  getSession: () ->
    @$http.get('/v1/user/session/')

  getTasks: () ->
    @$http.get('/v1/byrwtask/')

  disableTask: (task) ->
    @$http.patch(task.resource_uri, {is_active: false})

  enableTask: (task) ->
    @$http.patch(task.resource_uri, {is_active: true})

  deleteTask: (task) ->
    @$http.delete(task.resource_uri)

angular
  .module('trackSeatsApp')
  .service('DataService', DataService)

DataService.$inject = ['$http']
