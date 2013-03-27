# Store is embedded on a publisher's site and loads our latest front

front = document.createElement 'script'
front.async = true
# TODO: update path based on env
# TODO: update rev path on deploy (/v0/{{build}}/front.js)
# TODO: allow to be loaded over HTTPS
front.src = 'http://whitelabel.buyads.com/v0/1/front.js'

whitelabel = document.getElementById 'buyads-whitelabel'
whitelabel.parentNode.insertBefore front, whitelabel.nextSibling

# xhr request for API v0 assuming this is /v0/store.js
# figure out who is making the request
#   by domain?
#   by token?
