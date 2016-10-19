module.exports = (robot) ->

  lub = (res) ->
    love = [
      'MALFUNCTION',
      'Cribzbot is incapable of emotion.',
      'Cribzbot is metal and circuitry, Cribzbot does not know what it is to love.',
      'I wanna know what love is.',
      "I'd be tender - I'd be gentle and awful sentimental - if I only had a heart."
    ]
    return res.send res.random love

  robot.respond /i love you/i, lub
  robot.hear /i love you,? cribzbot/i, lub
