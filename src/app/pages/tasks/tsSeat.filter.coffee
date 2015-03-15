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
