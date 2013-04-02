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
      url = '@@API_HOST' + '?data=' + encodeURIComponent(JSON.stringify(data))

      httpRequest = BuyAdsWhiteLabel.createCORSRequest 'GET', url

      if httpRequest
        httpRequest.onload = ->
          console.log httpRequest.responseText

        httpRequest.send()

).call(@)

(() ->
  front = document.createElement 'script'
  front.async = true
  # TODO: allow to be loaded over HTTPS
  front.src = 'http://@@CDN/@@VERSION/@@BUILD/front.js'

  whitelabel = document.getElementById 'buyads-whitelabel'
  whitelabel.parentNode.insertBefore front, whitelabel.nextSibling

  BuyAdsWhiteLabel.populate whitelabel

).call(@)
