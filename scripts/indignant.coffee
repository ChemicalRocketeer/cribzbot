module.exports = (robot) ->
  robot.hear /it'?s a bit buggy/i, (res) ->
    res.send 'Am not! *twitches*'
