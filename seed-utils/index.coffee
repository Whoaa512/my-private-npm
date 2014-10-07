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
bs = {}

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

# generate the column helpers
_.each [1..12], (num)->
  bs["md#{num}Xs12"] = mdColXs12(num)
  bs["md#{num}Xs6"] = mdColXs6(num)

label = (attrs)->
  { staticCss, content } = attrs
  staticCss ?= ''
  delete attrs.staticCss
  delete attrs.content
  m "label#{staticCss}", attrs, content

input = (attrs)->
  { tag, staticCss} = attrs
  tag ?= 'input'
  staticCss ?= ''
  delete attrs.tag
  delete attrs.staticCss
  m "#{tag}.form-control#{staticCss}", attrs

formGroup = (opts)->
  opts = _.clone opts
  m '.form-group',
    label(opts.label),
    input(opts.input)

# add to bootstrap namespace
_.extend bs, {
  row
  formGroup
  input
  label
}

# mithril suggested helper
layout = (nav, body, attrs = {})->
  m '.layout.container-fluid', attrs,
    m '.row', [
      m 'header', nav
      m 'main', body
    ]


module.exports = {
  storeLocally
  getLocally
  layout
  bs
  passThru
  cycleTabs
}
