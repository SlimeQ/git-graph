{View} = require 'atom-space-pen-views'

module.exports =
class GraphErrorView extends View

  @content: (params) ->
    @div class: 'overlay from-top', =>
      @div class: 'block text-highlight', 'Git Graph Error:'
      @div class: 'error-message block', params.message
      @div class: 'block', =>
        @button class: 'btn', click: 'onOk', 'Ok'

  onOk: (event, element) =>
    this.remove();

  attach: ->
    atom.workspace.addTopPanel(item: this)
