# binding

player
  .on 'use-e:start', -> skillTimer.record 'start'
  .on 'use-e:end', -> skillTimer.record 'end'
  .on 'use-q:start', player.useQ

for n in [1, 2, 3, 4]
  $.on "alt + #{key}", ->
    player.useQ()