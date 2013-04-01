# Store is embedded on a publisher's site and loads our latest front
(() ->
  httpRequest = null

  @BuyAdsWhiteLabel =
    populate: (el) ->
      property = el.getAttribute('data-property')
      apiKey   = el.getAttribute('data-key')
      data =
        token: apiKey
        endpoint: 'inventory/' + property
      url = '@@API_HOST' + '?data=' + encodeURIComponent(JSON.stringify(data))

      if window.XMLHttpRequest # Mozilla, Safari, ...
        httpRequest = new XMLHttpRequest()
      else if window.ActiveXObject # IE
        try
          httpRequest = new ActiveXObject "Msxml2.XMLHTTP"
        catch e
          try
            httpRequest = new ActiveXObject "Microsoft.XMLHTTP"
          catch e

      return false if !httpRequest

      httpRequest.open 'GET', url, true
      httpRequest.onreadystatechange = BuyAdsWhiteLabel.render
      httpRequest.send()


    render: () ->
      if httpRequest.readyState is 4
        if httpRequest.status is 200
          console.log httpRequest.responseText
        else
          console.log 'There was a problem with the request.', httpRequest

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
