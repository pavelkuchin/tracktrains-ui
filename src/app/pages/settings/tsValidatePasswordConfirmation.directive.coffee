###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  @desc Validate a confirm password field
  @example
  <input ts-validate-password-confirmation="password">

  The directive requires the password variable

  The $error object will have an additional 'confirmed' field.
###
tsValidatePasswordConfirmation = () ->
  restrict: 'A'
  require: 'ngModel'
  scope:
    tsValidatePasswordConfirmation: '='
  link: tsValidatePasswordConfirmationLink
# XXX Needs refactoring because this function is in the global scope
tsValidatePasswordConfirmationLink = (scope, element, attrs, ctrl) ->
  ctrl.$validators.confirmed = (modelValue, viewValue) ->
    if ctrl.$isEmpty(modelValue)
      true
    else if modelValue == scope.tsValidatePasswordConfirmation
      true
    else
      false


angular
  .module('trackSeatsApp')
  .directive('tsValidatePasswordConfirmation', tsValidatePasswordConfirmation)
