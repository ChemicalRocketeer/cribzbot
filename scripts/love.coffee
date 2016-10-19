module.exports = (robot) ->
  robot.respond /i love you/i, (res) ->
    love = [
      'MALFUNCTION',
      'Cribzbot is incapable of emotion.'
    ]
    return res.send res.random love
