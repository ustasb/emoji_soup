class Ball

  @ATTRACT_DISTANCE: 90
  @ATTRACT_STRENGTH: 0.0003
  @BOUNCE_FRICTION: -0.9

  constructor: (@x, @y, @vx, @vy, @radius = 10) ->
    @mass = @radius / 10

  move: ->
    @x += @vx
    @y += @vy

  checkBoundary: (farX, farY) ->
    if @x - @radius < 0
      @x = @radius
      @vx *= Ball.BOUNCE_FRICTION
    else if @x + @radius > farX
      @x = farX - @radius
      @vx *= Ball.BOUNCE_FRICTION

    if @y - @radius < 0
      @y = @radius
      @vy *= Ball.BOUNCE_FRICTION
    else if @y + @radius >= farY
      @y = farY - @radius
      @vy *= Ball.BOUNCE_FRICTION

  rotate: (x, y, cos, sin, reverse) ->
    x: if reverse then (x * cos + y * sin) else (x * cos - y * sin)
    y: if reverse then (y * cos - x * sin) else (y * cos + x * sin)

  # HTML5 Animation with JavaScript
  checkCollision: (other) ->
    dx = other.x - @x
    dy = other.y - @y
    dist = Math.sqrt(dx * dx + dy * dy)
    return false if dist > @radius + other.radius

    angle = Math.atan2(dy, dx)
    sin = Math.sin(angle)
    cos = Math.cos(angle)

    # Rotate positions
    p0 = x: 0, y: 0
    p1 = @rotate(dx, dy, cos, sin, true)

    # Rotate velocities
    v0 = @rotate(@vx, @vy, cos, sin, true)
    v1 = @rotate(other.vx, other.vy, cos, sin, true)

    # Conservation of momentum
    vxReaction = v0.x - v1.x
    v0.x = ((@mass - other.mass) * v0.x + 2 * other.mass * v1.x) / (@mass + other.mass)
    v1.x = vxReaction + v0.x

    # Prevent Emoji from sticking together
    absV = Math.abs(v0.x) + Math.abs(v1.x)
    overlap = (@radius + other.radius) - Math.abs(p0.x - p1.x)
    p0.x += v0.x / absV * overlap
    p1.x += v1.x / absV * overlap

    # Rotate positions back
    p0F = @rotate(p0.x, p0.y, cos, sin, false)
    p1F = @rotate(p1.x, p1.y, cos, sin, false)
    other.x = @x + p1F.x
    other.y = @y + p1F.y
    @x = @x + p0F.x
    @y = @y + p0F.y

    # Rotate velocities back
    v0F = @rotate(v0.x, v0.y, cos, sin, false)
    v1F = @rotate(v1.x, v1.y, cos, sin, false)
    @vx = v0F.x
    @vy = v0F.y
    other.vx = v1F.x
    other.vy = v1F.y

    true

  checkAttraction: (other) ->
    dx = other.x - @x
    dy = other.y - @y
    dist = Math.sqrt(dx * dx + dy * dy)
    return false if dist > Ball.ATTRACT_DISTANCE

    ax = dx * Ball.ATTRACT_STRENGTH
    ay = dy * Ball.ATTRACT_STRENGTH
    other.vx -= ax / other.mass
    other.vy -= ay / other.mass
    @vx += ax / @mass
    @vy += ay / @mass

    alpha = 1 - dist / Ball.ATTRACT_DISTANCE
