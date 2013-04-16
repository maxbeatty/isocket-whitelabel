define [
  'data/cart',
  'data/placements',
  'ui/placements',
  'ui/cart'
], (CartData, PlacementsData, PlacementsUI, CartUI) ->
  initialize = ->
    # .buyads-whitelabel-container created by store
    CartData.attachTo '.buyads-whitelabel-container'
    PlacementsData.attachTo '.buyads-whitelabel-container'
    PlacementsUI.attachTo '.buyads-whitelabel-container'
    CartUI.attachTo '.buyads-whitelabel-container'

    return

  initialize: initialize
