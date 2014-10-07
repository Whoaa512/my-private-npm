# small set of utilities best paired with my mithril seed repo
_ = require 'lodash'
m = require 'mithril'

if not window?
  window =
    __not_browser: true
    localStorage: {}


storeLocally = (key, val) ->
  console.log "storing [#{key}]", val
  if window.__not_browser
    window.localStorage[key] = val
  else
    window.localStorage?[key] = JSON.stringify val

getLocally = (key) ->
  if window.__not_browser
    v = window.localStorage[key] ? null
  else
    v = JSON.parse window.localStorage?[key] ? null
  console.log "getting [#{key}]", v
  v

# mithril specific
passThru = (ctrlInstance)->
  ()-> ctrlInstance

cycleNextTab = (nextTab)->
  m.route(nextTab)

cycleTabs = (idList, wait)->
  idList = _.clone idList
  current = idList.shift()
  [ nextTab ] = idList
  idList.push(current)
  _.delay cycleNextTab, wait, "/#{nextTab}"
  _.delay cycleTabs, wait * 2, idList, wait


# Layout helpers (bootstrap specific)

row = (extras..., children) ->
  # allow staticCss and/or attrs
  if extras?.length is 2
    [staticCss, attrs] = extras
  if extras?.length < 2
    cssOrAttrs = extras.shift()
    if _.isString cssOrAttrs
      staticCss = cssOrAttrs
    if _.isPlainObject cssOrAttrs
      attrs = cssOrAttrs

  staticCss ?= ''
  attrs ?= {}
  m ".row#{staticCss}", attrs, children

col = _.curry (xs, md, staticCss, content) ->
  content = if _.isArray content then content else [content]
  m ".col-xs-#{xs}.col-md-#{md}#{staticCss}", content

mdColXs12 = col 12
mdColXs6 = col 6

md1Xs12 = mdColXs12 1
md2Xs12 = mdColXs12 2
md3Xs12 = mdColXs12 3
md4Xs12 = mdColXs12 4
md5Xs12 = mdColXs12 5
md6Xs12 = mdColXs12 6
md7Xs12 = mdColXs12 7
md8Xs12 = mdColXs12 8
md9Xs12 = mdColXs12 9
md12Xs12 = mdColXs12 12


# mithril suggested helper
layout = (nav, body, attrs = {})->
  m '.layout.container-fluid', attrs,
    m '.row', [
      m 'header', nav
      m 'main', body
    ]

# create bootstrap helpers namespace
bs = {
  row
  md1Xs12
  md2Xs12
  md3Xs12
  md4Xs12
  md5Xs12
  md6Xs12
  md7Xs12
  md8Xs12
  md9Xs12
  md12Xs12
}

module.exports = {
  storeLocally
  getLocally
  layout
  bs
  passThru
  cycleTabs
}
