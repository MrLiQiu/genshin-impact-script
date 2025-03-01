class SkillTimerX

  listCountDown: {}
  listDuration: {}
  listQ: {}
  listRecord: {}

  constructor: ->
    @reset()
    member.on 'change', @reset

  check: ->

    if client.isSuspend
      return

    now = $.now()

    for n in [1, 2, 3, 4]

      unless @listCountDown[n] or @listDuration[n]
        continue

      if now >= @listCountDown[n]
        @listCountDown[n] = 0

      if now >= @listDuration[n]
        @listDuration[n] = 0

      listMessage = []

      if @listCountDown[n]
        diff = $.floor (now - @listCountDown[n]) * 0.001
        $.push listMessage, "#{diff}s"

      if @listDuration[n]
        diff = $.abs $.floor (now - @listDuration[n]) * 0.001
        $.push listMessage, "[#{diff}s]"

      unless $.length listMessage
        @hide n
        return

      @render n, $.join listMessage, ' '

  hide: (n) ->

    $$.vt 'skillTimer.hide', n, 'number'

    unless Config.data.easySkillTimer
      return

    hud.render n, ''

  record: (step) ->

    $$.vt 'skillTimer.record', step, 'string'

    {current, name} = player

    unless name
      return

    now = $.now()

    countdown = @listCountDown[current]
    if countdown and countdown - now > 1e3
      return

    if step == 'end'
      @recordEnd now
      return

    if step == 'start'
      @recordStart now
      return

  recordEnd: (now) ->

    $$.vt 'skillTimer.recordEnd', now, 'number'

    {current, name} = player
    {cd, duration, typeE} = Character.data[name]

    unless @listRecord[current]
      return

    if now - @listRecord[current] < 500 # tap
      @listCountDown[current] = @listRecord[current] + (cd[0] * 1e3) + 500
      if duration[0]
        @listDuration[current] = @listRecord[current] + (duration[0] * 1e3)
      @listRecord[current] = 0
      return

    # hold

    if typeE == 1
      @listCountDown[current] = now + (cd[1] * 1e3) + 500
      if duration[1]
        @listDuration[current] = now + (duration[1] * 1e3)
    else
      @listCountDown[current] = @listRecord[current] + (cd[1] * 1e3) + 500
      if duration[1]
        @listDuration[current] = @listRecord[current] + (duration[1] * 1e3)

    @listRecord[current] = 0

  recordStart: (now) ->

    $$.vt 'skillTimer.recordStart', now, 'number'

    {current, name} = player
    {cd} = Character.data[name]

    if @listRecord[current]
      return

    @listRecord[current] = now

  render: (n, message) ->

    $$.vt 'skillTimer.render', n, 'number'
    $$.vt 'skillTimer.render', message, 'string'

    unless Config.data.easySkillTimer
      return

    hud.render n, message

  reset: -> for n in [1, 2, 3, 4]
    @listCountDown[n] = 0
    @listDuration[n] = 0
    @listQ[n] = 0
    @listRecord[n] = 0

# execute

skillTimer = new SkillTimerX()

ticker.on 'change', (tick) ->

  unless $.mod tick, 200
    skillTimer.check()

  # unless $.mod tick, 1e3
  #   skillTimer.checkSkillStatus()