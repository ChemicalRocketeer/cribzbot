module.exports = (robot) ->
  robot.hear /(cribzbot i|it'?)s a bit buggy/i, (res) ->
    res.send 'Am not! *twitches*'
