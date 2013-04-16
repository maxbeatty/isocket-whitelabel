define [
  'ui/placements',
  'ui/cart'
], (Placements, Cart) ->
  initialize = ->
    Placements.attachTo '.buyads-whitelabel-container' # created by store
    Cart.attachTo '.buyads-whitelabel-container'
    return

  initialize: initialize
