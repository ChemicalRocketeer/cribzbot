module.exports = (robot) ->

  senddata = (res, id, url, beckoned) ->
    url ?= 'https://campuscribz.com/listings/'
    robot.http(url + id)
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
        if err
          if beckoned
            res.send "DOES NOT COMPUTE"
          return
        if !body
          if beckoned
            res.send "I couldn't find that listing anywhere. Please don't be mad."
          return
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
        uploadFile res, data, stringy

  uploadFile = (res, data, stringy) ->
    title = encodeURI "Listing #{data.id} - #{Date.now()}"
    comment = encodeURI "Here's the data from that listing."
    token = process.env.HUBOT_SLACK_TOKEN
    payload = "token=#{token}&filetype=javascript&title=#{title}&initial_comment=#{comment}&content=#{encodeURI(stringy)}&channels=#{res.message.room}"
    robot.http('https://slack.com/api/files.upload')
      .header('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8')
      .post(payload) (err, response, body) ->
        if err and beckoned
          console.error 'ERROR ERROR CRITICAL CORE LOGIC BREACH', body
          res.send "DOES NOT COMPUTE"

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
