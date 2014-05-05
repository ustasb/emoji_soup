window.requestAnimationFrame = window.requestAnimationFrame ||
                               window.mozRequestAnimationFrame ||
                               window.webkitRequestAnimationFrame ||
                               window.msRequestAnimationFrame

class window.App

  ATTRACT_EFFECT = 0.05
  BUMP_EFFECT = -0.5

  constructor: ->
    @lightBox = new LightBox('main-menu')

    @canvas = new Canvas('canvas')
    @emoji = []
    @mouse =
      isDown: false
      x: null
      y: null

    @_initEvents()
    Emoji.loadSpriteSheet => @run()

  _initEvents: ->
    w = $(window)

    w.resize =>
      @canvas.el.width = w.width()
      @canvas.el.height = w.height()
    w.resize()

    $(@canvas.el).mousedown => @mouse.isDown = true
    w.mouseup => @mouse.isDown = false

    w.mousemove (e) =>
      @mouse.x = e.pageX
      @mouse.y = e.pageY

    $('#okay').click =>
      @lightBox.hide()
      @_enableSettings()

  _enableSettings: ->
    $('#settings').show()

    $('#attract-distance .slider').slider(
      value: Ball.ATTRACT_DISTANCE
      min: 0
      max: 400
      slide: (e, ui) -> Ball.ATTRACT_DISTANCE = ui.value
    )

    $('#attract-strength .slider').slider(
      value: Ball.ATTRACT_STRENGTH
      min: 0
      step: 0.00001
      max: 0.001
      slide: (e, ui) -> Ball.ATTRACT_STRENGTH = ui.value
    )

    $('#attract-effect-emotion .slider').slider(
      value: ATTRACT_EFFECT
      min: 0
      step: 0.05
      max: 0.3
      slide: (e, ui) -> ATTRACT_EFFECT = ui.value
    )

    $('#bump-effect-emotion .slider').slider(
      value: Math.abs(BUMP_EFFECT)
      min: 0
      step: 0.02
      max: 2
      slide: (e, ui) -> BUMP_EFFECT = -ui.value
    )

  createEmojiAt: (x, y) ->
    maxVelocity = 4
    @emoji.push new Emoji(
      x, y,
      Math.random() * maxVelocity - (maxVelocity / 2),
      Math.random() * maxVelocity - (maxVelocity / 2)
    )

  drawLineBetweenEmoji: (a, b, alpha) ->
    @canvas.ctx.strokeStyle = "rgba(1, 1, 1, #{alpha})"
    @canvas.ctx.beginPath()
    @canvas.ctx.moveTo(a.x, a.y)
    @canvas.ctx.lineTo(b.x, b.y)
    @canvas.ctx.stroke()
    @canvas.ctx.closePath()

  run: ->
    @canvas.clear()

    @createEmojiAt(@mouse.x, @mouse.y) if @mouse.isDown

    i = 0
    len = @emoji.length
    lenMinus1 = len - 1

    if len > 0 then loop
      a = @emoji[i]
      a.emotion.neutralize()
      a.move()

      j = i + 1
      while j < len
        b = @emoji[j]

        if a.checkCollision(b)
          a.emotion.update(BUMP_EFFECT)
          b.emotion.update(BUMP_EFFECT)
        else
          unless a.emotion.isUnhappy() or b.emotion.isUnhappy()
            if alpha = a.checkAttraction(b)
              @drawLineBetweenEmoji(a, b, alpha)
              a.emotion.update(ATTRACT_EFFECT)
              b.emotion.update(ATTRACT_EFFECT)

        j += 1

      a.checkBoundary(@canvas.el.width, @canvas.el.height)
      a.render(@canvas.ctx)

      i += 1
      break if i > lenMinus1

    requestAnimationFrame => @run()
