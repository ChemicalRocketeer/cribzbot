# Description:
#   Post a random Dilbert comic
#
# Dependencies:
#   random-dilbert
#
# Configuration:
#   None
#
# Commands:
#   hubot dilbert me - Posts a link to a random dilbert comic and the date it was published
#
# Notes:
#
# Author:
#   David Aaron Suddjian

olDilby = require 'random-dilbert'

module.exports = (robot) ->
  robot.respond /dilbert me/i, (res) ->
    olDilby (err, data) ->
      return res.send 'MALFUNCTION' if err
      res.send "Dilbert for #{data.date}: \n#{data.url}"
