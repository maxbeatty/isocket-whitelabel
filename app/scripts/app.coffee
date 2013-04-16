define [
  'data/cart',
  'ui/placements',
  'ui/cart'
], (CartData, Placements, CartUI) ->
  initialize = ->
    # .buyads-whitelabel-container created by store
    CartData.attachTo '.buyads-whitelabel-container'
    Placements.attachTo '.buyads-whitelabel-container'
    CartUI.attachTo '.buyads-whitelabel-container'
    return

  initialize: initialize
