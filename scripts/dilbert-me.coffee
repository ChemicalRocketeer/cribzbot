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

request = require 'request'

module.exports = (robot) ->

  firstDilbert = new Date(1989, 3, 17)

  # Gets a random date between two given dates
  randomDate = (start, end) ->
    return new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()))

  yyyymmdd = (date) ->
    return {
      year: date.getFullYear(),
      month: date.getMonth() + 1,
      day: date.getDate()
    }

  # dilbert urls are formatted as strip/year-month-day (values less that 10 can either have padded zeroes or no)
  formatDate = (date) ->
    return date.year + '-' + date.month + '-' + date.day

  robot.respond /dilbert me/i, (res) ->
    yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    date = yyyymmdd(randomDate(firstDilbert, yesterday))
    url = 'http://www.dilbert.com/strip/' + formatDate date
    res.send url
