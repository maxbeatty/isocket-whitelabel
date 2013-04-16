define [
  'ui/placements',
  'ui/cart'
], (Placements, Cart) ->
  initialize = ->
    # .buyads-whitelabel-container created by store
    Placements.attachTo '.buyads-whitelabel-container'
    Cart.attachTo '.buyads-whitelabel-container'
    return

  initialize: initialize
