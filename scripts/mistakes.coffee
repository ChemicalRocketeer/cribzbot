module.exports = (robot) ->
  robot.hear /^\s?@?hubot/i, (res) ->
    res.send "I'm not hubot, I'm cribzbot!"

  robot.hear /^\s?@?campusbot/i, (res) ->
    res.send "I'm not campusbot, I'm cribzbot!"
