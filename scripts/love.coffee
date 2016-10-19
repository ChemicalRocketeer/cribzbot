module.exports = (robot) ->
  robot.respond /i love you/i, (res) ->
    love = [
      'MALFUNCTION',
      'Cribzbot is incapable of emotion.',
      "I love you too #{res.message.user.name}!"
    ]
    return res.send res.random love
