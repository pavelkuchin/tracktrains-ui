class DataService
  constructor: (@http) ->

  signIn: (email, password) ->
    @http.post('/v1/user/login/',{
      login: email
      password: password
    })

  signOut: () ->
    @http.post('/v1/user/logout/', {})

  getSession: () ->
    @http.get('/v1/user/session/')

angular
  .module('trackSeatsApp')
  .service('DataService', DataService)

DataService.$inject = ['$http']
