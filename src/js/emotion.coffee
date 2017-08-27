class Emotion

  MIN_EMOTION = 0
  MAX_EMOTION = 10
  NEUTRAL_EMOTION = MAX_EMOTION / 2

  constructor: (@value = NEUTRAL_EMOTION) ->

  # Higher is happier
  update: (amount) ->
    @value += amount

    if @value < MIN_EMOTION
      @value = MIN_EMOTION
    else if @value > MAX_EMOTION
      @value = MAX_EMOTION

  isUnhappy: -> Math.round(@value) < NEUTRAL_EMOTION

  ratio: -> @value / MAX_EMOTION

  neutralize: (rate = 0.005) ->
    delta = NEUTRAL_EMOTION - @value
    @value += delta * rate
