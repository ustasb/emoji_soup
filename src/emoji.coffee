class Emoji extends Ball

  # Angry -> Neutral -> Happy
  # Numbers represent Emoji positions in the sprite sheet.
  EMOTION_CONTINUUM = [49, 48, 41, 35, 29, 58, 28, 26, 17, 5, 3]

  @spriteSheet:
    imgObj: null
    src: 'imgs/apple_emoji.png'
    spriteDelta: 32
    spritePaddingX: 5
    spriteSize: 22
    spriteCount: 867

  @loadSpriteSheet: (onDone) ->
    @spriteSheet.imgObj = new Image()
    @spriteSheet.imgObj.onload = -> onDone()
    @spriteSheet.imgObj.src = @spriteSheet.src

  constructor: (x, y, vx, vy) ->
    @emotion = new Emotion()
    super(x, y, vx, vy)

  _getEmojiSpriteIndex: ->
    EMOTION_CONTINUUM[ Math.round (EMOTION_CONTINUUM.length - 1) * @emotion.ratio() ]

  _getEmojiFaceOffset: ->
    Emoji.spriteSheet.spriteDelta *
    @_getEmojiSpriteIndex() +
    Emoji.spriteSheet.spritePaddingX

  render: (ctx) ->
    ctx.drawImage(
      Emoji.spriteSheet.imgObj,
      @_getEmojiFaceOffset(), 0,
      Emoji.spriteSheet.spriteSize,
      Emoji.spriteSheet.spriteSize,
      @x - @radius,
      @y - @radius,
      @radius * 2, @radius * 2
    )
