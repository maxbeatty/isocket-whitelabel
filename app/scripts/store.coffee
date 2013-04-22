# Store is embedded on a publisher's site and loads our latest front

class BuyAdsWhiteLabel
  constructor: ->
    @el = document.getElementById 'buyads-whitelabel'
    @secure = 'https:' is document.location.protocol
    @setupShop()
    @getFront()
    @populate @el.getAttribute('data-property'), @el.getAttribute('data-key')

  getFront: ->
    fpath = '/@@VERSION/@@BUILD/front.js'
    fhost = if @secure then '//@@CDN_SSL' else '//@@CDN'

    front = document.createElement 'script'
    front.async = true
    front.src = document.location.protocol + fhost + fpath

    @el.parentNode.insertBefore front, @el.nextSibling

  setupShop: ->
    store = document.createElement 'div'
    store.className = 'buyads-whitelabel-container'
    store.innerHTML = '<span class="buyads-loading">Loading inventory...</span>'
    @el.parentNode.insertBefore store, @el.nextSibling

  createCORSRequest: (method, url) ->
    xhr = new XMLHttpRequest()

    if xhr.withCredentials isnt undefined # Mozilla, Safari, ...
      xhr.open method, url, true
    else if typeof XDomainRequest != "undefined" # IE8-9
      xhr = new XDomainRequest()
      xhr.open method, url
    else
      xhr = null

    xhr

  populate: (property, apiKey) ->
    data =
      token: apiKey
      endpoint: 'inventory/' + property
    url = '//@@API_HOST' + '?data=' + encodeURIComponent(JSON.stringify(data))

    httpRequest = @createCORSRequest 'GET', url

    if httpRequest
      httpRequest.onload = =>
        @inventory = JSON.parse httpRequest.responseText

        if document.createEvent # !IE8
          evt = document.createEvent "CustomEvent"
          evt.initCustomEvent 'dataInventory', true, true, {}
          document.dispatchEvent evt

      httpRequest.send()

this.YourBuyAdsWhiteLabel = new BuyAdsWhiteLabel()
