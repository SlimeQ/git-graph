{$} = require 'atom-space-pen-views'
React = require 'react-atom-fork'
Reactionary = require 'reactionary-atom-fork'
{div, span, a} = Reactionary
RP = React.PropTypes
moment = require 'moment'
errorController = require '../controllers/errorController'

HASH_LENGTH = 7  # github uses this length
BLANK_HASH = '-'.repeat(HASH_LENGTH)

_defaultDate = null
getDefaultDate = ->
  _defaultDate ?= "" # formatDate moment("2014-01-01T13:37:00 Z")


renderLoading = ->
  div className: 'graph-line loading',
    span className: 'graph', ""
    span className: 'hash', ""
    span className: 'summary', ""

GraphLineComponent = React.createClass
  propTypes:
    graph: RP.string.isRequired
    hash: RP.string.isRequired
    summary: RP.string.isRequired
    backgroundClass: RP.string
    noCommit: RP.bool

  render: ->
    if @props.noCommit
      div className: 'graph-line no-commit text-subtle',
        span className: 'graph', @props.graph
    else
      div className: 'graph-line ' + @props.backgroundClass,
        span className: 'graph', @props.graph
        span className: 'hash', @props.hash
        span className: 'summary', @props.summary

  componentDidMount: ->
    $el = $(@getDOMNode())
    if @props.summary
      atom.tooltips.add($el,
        title: @props.summary
        placement: "auto left"
      )


  componentWillUnmount: ->
    $(@getDOMNode()).tooltip "destroy"

  shouldComponentUpdate: ({hash}) ->
    hash isnt @props.hash

  didClickHashWithoutUrl: (event, element) ->
    errorController.showError 'error-no-custom-url-specified'

module.exports = {GraphLineComponent, renderLoading}
