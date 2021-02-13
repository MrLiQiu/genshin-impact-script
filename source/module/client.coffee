class ClientX extends EmitterX

  height: 0
  isSuspend: false
  width: 0

  constructor: ->
    super()
    @setSize()

  check: ->

    if !@isSuspend and !@checkActive()
      @setPriority 'low'
      @suspend true
      @emit 'leave'
      return

    if @isSuspend and @checkActive()
      @setPriority 'normal'
      @suspend false
      @emit 'enter'
      return

  checkActive: ->
    return WinActive "ahk_exe #{config.data.process}"

  reset: ->
    @setPriority 'normal'
    @resetTimer()
    @resetKey()

  resetKey: ->

    for key in ['middle', 'right']
      if $.getState key
        $.click "#{key}:up"

    for key in [
      'alt', 'ctrl'
      'e', 'esc', 'f', 'space', 'w', 'x'
    ]
      if $.getState key
        $.press "#{key}:up"

  resetTimer: -> for _timer of timer
    clearTimeout _timer

  setSize: ->

    name = "ahk_exe #{config.data.process}"
    `WinGetPos, __x__, __y__, __width__, __height__, % name`

    @width = __width__
    @height = __height__

  suspend: (isSuspend) ->

    if isSuspend
      if @isSuspend then return
      @isSuspend = true
      $.suspend true
      @resetTimer()
      @resetKey()
      return

    unless isSuspend
      unless @isSuspend then return
      @isSuspend = false
      $.suspend false
      return

  setPriority: (level) ->
    `Process, Priority, % config.data.process, % level`

  vh: (n) -> return Math.round @height * n * 0.01

  vw: (n) -> return Math.round @width * n * 0.01

# execute

client = new ClientX()

ticker.on 'change', (tick) ->
  if Mod tick, 200
    return
  client.check()