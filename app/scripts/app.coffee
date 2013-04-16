define [
  'data/cart',
  'data/placements',
  'ui/placements',
  'ui/cart'
], (CartData, PlacementsData, PlacementsUI, CartUI) ->
  initialize = ->
    # .buyads-whitelabel-container created by store
    PlacementsUI.attachTo '.buyads-whitelabel-container'
    CartUI.attachTo '.buyads-whitelabel-container'
    CartData.attachTo '.buyads-whitelabel-container'
    PlacementsData.attachTo '.buyads-whitelabel-container'

    return

  initialize: initialize
