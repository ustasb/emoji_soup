class LightBox
  $backdrop = $('<div class="light-box-bg"></div>')

  @showBackdrop: ->
    $(document.body).append($backdrop)

  @hideBackdrop: ->
    $backdrop.remove()

  constructor: (containerID) ->
    @el = $('#' + containerID)

    @_centerInWindow()
    @show()
    @_bindEvents()

  _bindEvents: ->
    $(window).resize => @_centerInWindow()

  _centerInWindow: ->
    w = $(window)

    verticalOffset = 35  # Looks better a bit higher up...

    @el.css
      left: (w.width() - @el.width()) / 2
      top: (w.height() - @el.height()) / 2 - verticalOffset

  hide: ->
    LightBox.hideBackdrop()
    @el.hide()

  show: ->
    LightBox.showBackdrop()
    @el.show()
