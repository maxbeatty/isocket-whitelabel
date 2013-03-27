# Store is embedded on a publisher's site and loads our latest front

front = document.createElement 'script'
front.async = true
# TODO: allow to be loaded over HTTPS
front.src = 'http://@@CDN/@@VERSION/@@BUILD/front.js'

whitelabel = document.getElementById 'buyads-whitelabel'
whitelabel.parentNode.insertBefore front, whitelabel.nextSibling

# xhr request for API v0 assuming this is /v0/store.js
# figure out who is making the request
#   by domain?
#   by token?
