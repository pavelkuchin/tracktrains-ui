###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  The Train Seat types filter

  This filter convert seat/place type from short code to user-friendly string representation

  Example: {{ shortCode | tsSeat }}
###
tsSeatFilter = () ->
  (input) ->
    switch input
      when 'ANY' then 'Any type of seat'
      when 'B' then 'Bottom place'
      when 'T' then 'Top place'
      when 'BS' then 'Bottom place by side'
      when 'TS' then 'Top place by side'


angular
  .module('trackSeatsApp')
  .filter('tsSeat', tsSeatFilter)
