# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot abstract <topic> - Prints a nice abstract of the given topic
#
# Author:
#   tantalor

module.exports = (robot) ->
  robot.respond /(abs|abstract|explain|what'?s the deal with) (.+)/i, (res) ->
    query = res.match[2]
    if /cribzbot|(yo)?urself/i.test query
      self = [
        'I pass butter.',
        'I exist to serve mankind.',
        'Just a lowly chatbot',
        'I\'m your peppy personal assistant.'
      ]
      res.send res.random self
      return setTimeout (() ->
          if Math.random() < 0.4
            res.send '*For now.*'
        ), 4000
    if /^campus\s*cribz$/i.test query
      return res.send 'Ah, my birthplace.'
    abstract_url = "http://api.duckduckgo.com/?format=json&q=#{encodeURIComponent(query)}"
    res.http(abstract_url)
      .header('User-Agent', 'Hubot Abstract Script')
      .get() (err, _, body) ->
        return res.send "Sorry, the tubes are broken." if err
        data = JSON.parse(body.toString("utf8"))
        return unless data
        topic = data.RelatedTopics[0] if data.RelatedTopics and data.RelatedTopics.length
        if data.AbstractText
          # hubot abs numerology
          # Numerology is any study of the purported mystical relationship between a count or measurement and life.
          # http://en.wikipedia.org/wiki/Numerology
          res.send data.AbstractText
          res.send data.AbstractURL if data.AbstractURL
        else if topic and not /\/c\//.test(topic.FirstURL)
          # hubot abs astronomy
          # Astronomy is the scientific study of celestial objects.
          # http://duckduckgo.com/Astronomy
          res.send topic.Text
          res.send topic.FirstURL
        else if data.Definition
          # hubot abs contumacious
          # contumacious definition: stubbornly disobedient.
          # http://merriam-webster.com/dictionary/contumacious
          res.send data.Definition
          res.send data.DefinitionURL if data.DefinitionURL
        else
          res.send "I don't know anything about that."
