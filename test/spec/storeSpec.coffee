describe 'Store', ->
  it 'should insert a container div to be populated later', ->
    shop = document.getElementsByClassName 'buyads-whitelabel-container'
    expect(shop).to.have.length(1)

  it 'should async load the front (flight app)', ->
    front = document.getElementById('buyads-whitelabel').nextElementSibling
    expect(front.src).to.match(/front.js/)

  it 'should populate the store with data from the API', ->
    expect('this').to.be.ok
    # TODO: not sure how to test this
    # expect(window.YourBuyAdsWhiteLabel.inventory).to.be.defined()


