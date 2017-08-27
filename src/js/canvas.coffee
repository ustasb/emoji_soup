class Canvas

  constructor: (@id) ->
    @el = document.getElementById(@id)
    @_getContext()

  _getContext: ->
    unless @ctx = @el.getContext('2d')
      alert('2D canvas context could not be made!')

  clear: ->
    @ctx.clearRect(0, 0, @el.width, @el.height)
