define [
  'ui/placements',
  'ui/cart'
], (Placements, Cart) ->
  initialize = ->
    Placements.attachTo '.buyads-whitelabel-container'
    Cart.attachTo ''
    return

  initialize: initialize
