define [
  'data/cart',
  'data/placements',
  'ui/placements',
  'ui/cart',
  'ui/creative'
], (CartData, PlacementsData, PlacementsUI, CartUI, CreativeUI) ->
  initialize = ->
    # .buyads-whitelabel-container created by store
    PlacementsUI.attachTo '.buyads-whitelabel-container'
    CartUI.attachTo '.buyads-whitelabel-container'
    CartData.attachTo '.buyads-whitelabel-container'
    PlacementsData.attachTo '.buyads-whitelabel-container'

    # feel like this should be attached to the cart item... maybe that's the backbone in me
    CreativeUI.attachTo '.buyads-whitelabel-container'

    return

  initialize: initialize
