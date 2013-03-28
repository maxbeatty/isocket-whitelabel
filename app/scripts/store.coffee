# Store is embedded on a publisher's site and loads our latest front
(() ->
  httpRequest = null

  @BuyAdsWhiteLabel =
    populate: (el) ->
      url = 'https://@@API_HOST/@@VERSION/api.php/inventory/' +
        el.getAttribute('data-property')

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

      httpRequest.onreadystatechange = BuyAdsWhiteLabel.render
      httpRequest.withCredentials = true
      httpRequest.open 'GET', url, true, 'token', el.getAttribute('data-key')
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
