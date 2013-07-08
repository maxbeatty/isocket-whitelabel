describe 'Store', ->
  it 'should setup shop', ->
    src = document.getElementById 'buyads-whitelabel'
    expect(src).not.toBe(null)

    shop = document.getElementsByClassName 'buyads-whitelabel-container'
    expect(shop.length).toBe(1)

