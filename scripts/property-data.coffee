
descriptionTruncMsg = '... (truncated)'
descriptionTruncLength = 16
descriptionTruncIf = descriptionTruncLength + descriptionTruncMsg + 8
maxMsgLength = 3850 # it's actually 4k but just to be safe

module.exports = (robot) ->

  senddata = (res, id, url, beckoned) ->
    url ?= 'https://campuscribz.com/listings/'
    robot.http(url + id)
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
        if err
          return res.send "Something didn't compute."
        if !body
          return beckoned ? res.send "I couldn't find that listing anywhere. Please don't be mad."
        try
          data = JSON.parse(body)
        catch err
          if beckoned
            res.send "I tried to get json but it sent back something else!"
          return
        if data.status is 404
          if beckoned
            res.send "I couldn't find that listing anywhere. Please don't be mad."
          return
        stringy = JSON.stringify data, null, 2

        if stringy.length > maxMsgLength
          # truncate the descriptions for sanity
          shouldTruncate = (desc) ->
            desc and desc.length > descriptionTruncIf
          truncate = (desc) ->
            desc.substring(0, descriptionTruncLength - 1) + descriptionTruncMsg
          data.description = truncate(data.description) if shouldTruncate data.description
          if data.units and data.units.length
            data.units.forEach (unit) ->
              unit.description = truncate(unit.description) if shouldTruncate unit.description
        stringy = JSON.stringify data, null, 2

        if stringy.length > maxMsgLength
          return uploadFile res, data, stringy
        else
          return sendMessage res, data, stringy

  sendMessage = (res, data, stringy) ->
    # separate into chunks to get around post size limits
    stringy = JSON.stringify data, null, 2
    lines = stringy.split(/[\n\r]+/g)
    messages = ["Here's the data for that listing:\n```"]
    shouldConcat = (line)->
      line.length + messages[messages.length - 1].length < maxMsgLength
    lines.forEach (line) ->
    if shouldConcat line
      messages[messages.length - 1] += line + '\n'
    else
      messages[messages.length - 1] += '```'
      messages.push '```' + line + '\n'
    messages[messages.length - 1] += '```'

    # I can't for the life of me figure out why these end up backwards but they do, so reverse them
    messages.reverse().forEach (msg) ->
      res.send msg

  uploadFile = (res, data, stringy) ->
    payload = "token=#{process.env.HUBOT_SLACK_TOKEN}&filetype=javascript&filename=listing #{data.id} - #{Date.now()}.json&content=#{encodeURI(stringy)}&channels=[#{res.message.room}]"
    robot.http('https://slack.com/api/files.upload')
      .header('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8')
      .post(payload) (err, response, body) ->
        console.log response
        console.log body
        if err
          return sendMessage res, data, stringy

  # this one only runs if you ask it to
  robot.respond /https?:\/\/(www\.)?(dev\.|staging\.|2120\.)?campuscribz\.com\/listings\/(([-a-zA-Z0-9_\+]){4,32})/i, (res) ->
    subdomain = res.match[1]
    id = res.match[3]
    if subdomain is 'dev' or subdomain is '2120'
      res.send 'I can\'t reach that data because the superSignin is in the way, but I\'ll see if I can find it on the live site.'
      return senddata res, id, 'https://campuscribz.com/listings/', true
    else if subdomain is 'staging'
      url = 'https://staging.campuscribz.com/listings/'
    senddata res, id, url, true
