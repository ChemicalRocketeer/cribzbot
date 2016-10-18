# Description:
#   Direct Hubot's attention to something it missed.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ^ - Responds to the above message as if it was a command (as many messages up as there are ^'s)
#
# Notes:
#   CaptainPicard:  "Let's try out our new robot companion!"
#        JoePesci:  "what is the answer to the ultimate question of life, the universe, and everything?"
#        JoePesci:  "crap, it didn't work..."
#   CaptainPicard:  "@hubot ^^"
#           Hubot:  "42, but what is the question?"
#
# Author:
#   David Aaron Suddjian

{Message, TextMessage} = require.main.require 'hubot'

module.exports = (robot) ->

  boundToRepeat = 8
  rgx = /^\s*(\^{1,8})/
  lastEmitted = null

  getBrainRegion = (message) ->
    return "messages-up-there-#{message.room}"

  getHistory = (message, brainregion) ->
    brainregion ?= getBrainRegion message
    history = robot.brain.get brainregion
    if history
      return JSON.parse(history)
    else
      return []

  oneForTheHistoryBooks = (message, history, brainregion) ->
    brainregion ?= getBrainRegion message
    history ?= getHistory message, brainregion
    history.push message.toString()
    if history.length > boundToRepeat
      history = history.slice 1
    robot.brain.set brainregion, JSON.stringify history

  robot.respond /(\^{1,8})\s*$/, (res) ->
    #ignore it if it's just us emitting a hacky fake message
    if res.message is lastEmitted
      return
    hats = res.match[1]
    history = getHistory res.message
    if hats.length > history.length
      return res.send "I can't see that far back yet"
    originalMsg = history[history.length - hats.length]
    oneForTheHistoryBooks res.message, history
    res.message.finish()
    # avoid adding our contrived hacked-up message thing to the history
    process.nextTick () ->
      message = new TextMessage(res.message.user, "#{robot.name}: #{originalMsg}")
      lastEmitted = message
      robot.receive message


  robot.hear /(.+)/, (res) ->
    oneForTheHistoryBooks res.message unless res.message is lastEmitted
