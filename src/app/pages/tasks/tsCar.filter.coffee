###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  The Train Car types filter

  This filter convert car type short code to user-friendly string representation

  Example: {{ shortCode | tsCar }}
###
tsCarFilter = () ->
  (input) ->
    switch input
      when 'ANY' then 'Any type of car'
      when 'VIP' then 'VIP car'
      when 'SLE' then 'Sleeping car'
      when 'COM' then 'Compartment car'
      when 'RB' then 'Reserved-berths car'
      when 'RS' then 'Car with regular seats'
      when 'TC' then 'Third-class car'


angular
  .module('trackSeatsApp')
  .filter('tsCar', tsCarFilter)
