window.requestAnimationFrame = window.requestAnimationFrame ||
                               window.mozRequestAnimationFrame ||
                               window.webkitRequestAnimationFrame ||
                               window.msRequestAnimationFrame

class window.App

  ACTIVE_EMOJI_CLASS = null
  ACTIVE_CONTAINER = null

  ATTRACT_EFFECT = 0.05
  BUMP_EFFECT = -0.5
  GROWTH_RATE = 0.2
  HALT = false
  INIT_EMOJI_COUNT = 50

  constructor: ->
    @lightBox = new LightBox('main-menu')

    @canvas = new Canvas('canvas')
    @mouse =
      isDown: false
      x: null
      y: null

    @emotionals = []
    @food = []

    @_initEvents()
    Emoji.loadSpriteSheet =>
      @generateScene(INIT_EMOJI_COUNT)
      @run()

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

    $('#attract-distance .slider').slider
      value: Ball.ATTRACT_DISTANCE
      min: 0
      max: 400
      slide: (e, ui) ->
        Ball.ATTRACT_DISTANCE = ui.value
        Ball.ATTRACT_STRENGTH = 0.0003 * ui.value / 90

    $('#speed .slider').slider
      value: Ball.DAMPEN
      min: 0.95
      step: 0.01
      max: 1.05
      slide: (e, ui) -> Ball.DAMPEN = ui.value

    $('#halt input').click ->
      HALT = $(this).is(':checked')
      null

    toggleActive = do ->
      active = null
      (el) ->
        active.removeClass('active') if active?
        active = $(el).addClass('active')

    $('#emotional').click (e) =>
      toggleActive(e.currentTarget)
      ACTIVE_EMOJI_CLASS = Emotional
      ACTIVE_CONTAINER = @emotionals
    .click()

    $('#food').click (e) =>
      toggleActive(e.currentTarget)
      ACTIVE_EMOJI_CLASS = Food
      ACTIVE_CONTAINER = @food

  createEmojiAt: (emojiClass, container, x, y) ->
    maxVelocity = 4
    container.push new emojiClass(
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

  generateScene: (emoji_count) ->
    @createEmojiAt(
      Emotional,
      @emotionals,
      Math.random() * @canvas.el.width,
      Math.random() * @canvas.el.height,
    ) while emoji_count--

  updateEmotionals: ->
    i = 0
    len = @emotionals.length
    lenMinus1 = len - 1

    if len > 0 then loop
      a = @emotionals[i]
      a.emotion.neutralize()
      a.move() unless HALT

      j = i + 1
      while j < len
        b = @emotionals[j]

        if !HALT and a.checkCollision(b)
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

  updateFood: ->
    i = @food.length

    while i > 0
      i -= 1

      f = @food[i]
      f.move() unless HALT

      for e in @emotionals by 1
        if f.hasCollided(e)
          e.makeBigger(GROWTH_RATE)
          @food.splice(i, 1)

      f.checkBoundary(@canvas.el.width, @canvas.el.height)
      f.render(@canvas.ctx)

  run: ->
    @canvas.clear()

    if @mouse.isDown
      @createEmojiAt(ACTIVE_EMOJI_CLASS, ACTIVE_CONTAINER, @mouse.x, @mouse.y)

    @updateEmotionals()
    @updateFood()

    requestAnimationFrame => @run()
