olDilby = require 'random-dilbert'

module.exports = (robot) ->
  robot.respond /dilbert me/i, (res) ->
    olDilby (err, data) ->
      return res.send 'MALFUNCTION' if err
      res.send "Dilbert for #{data.date}: #{data.url}"
