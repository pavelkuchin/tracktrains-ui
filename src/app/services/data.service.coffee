###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  The data service intended to request and send data to server.

  The simpliest http calls wrapper with basic logic

  Methods:
    signIn(email, password) - the user authentication call
    signOut() - the call for close user session
    getSession() - return the current user
    getTasks() - return the tasks list
    disableTask(task) - disable task (it will not be executed)
    enableTask(task) - enable task
    deleteTask(task) - delete task
    saveTask(task) - create a new task if task.resource_uri is undefined
                     update an existing task if task.resource_uri is defined
###
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

  saveTask: (task) ->
    if task.resource_uri
      @$http.put(task.resource_uri, task)
    else
      @$http.post('/v1/byrwtask/', task)

angular
  .module('trackSeatsApp')
  .service('DataService', DataService)

DataService.$inject = ['$http']
