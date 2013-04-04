# Store is embedded on a publisher's site and loads our latest front
(() ->
  @BuyAdsWhiteLabel =
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

    populate: (el) ->
      property = el.getAttribute('data-property')
      apiKey   = el.getAttribute('data-key')
      data =
        token: apiKey
        endpoint: 'inventory/' + property
      url = '//@@API_HOST' + '?data=' + encodeURIComponent(JSON.stringify(data))

      httpRequest = BuyAdsWhiteLabel.createCORSRequest 'GET', url

      if httpRequest
        httpRequest.onload = ->
          console.log httpRequest.responseText

        httpRequest.send()

).call(@)

(() ->
  fpath = '/@@VERSION/@@BUILD/front.js'
  fhost = if 'https:' is document.location.protocol
    's://@@CDN_SSL'
  else
    '://@@CDN'

  front = document.createElement 'script'
  front.async = true
  front.src = 'http' + fhost + fpath

  whitelabel = document.getElementById 'buyads-whitelabel'
  whitelabel.parentNode.insertBefore front, whitelabel.nextSibling

  BuyAdsWhiteLabel.populate whitelabel

).call(@)
