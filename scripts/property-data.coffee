module.exports = (robot) ->

  senddata = (res, id, url, user, pass, beckoned) ->
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
        uploadFile res, data

  uploadFile = (res, data) ->
    title = encodeURIComponent "Listing #{data.id} - #{new Date().toDateString()}"
    comment = encodeURIComponent "Here's the data from that listing."
    datastr = encodeURIComponent(JSON.stringify data, null, 2)
    token = process.env.HUBOT_SLACK_TOKEN
    payload = "token=#{token}&filetype=javascript&title=#{title}&initial_comment=#{comment}&content=#{datastr}&channels=#{res.message.room}"
    robot.http('https://slack.com/api/files.upload')
      .header('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8')
      .header('CC-supersignin-username', user)
      .header('CC-supersignin-password', pass)
      .post(payload) (err, response, body) ->
        if err and beckoned
          console.error 'ERROR ERROR CRITICAL CORE LOGIC BREACH', body
          res.send "DOES NOT COMPUTE"

  # this one only runs if you ask it to
  robot.respond /https?:\/\/(?:(www|dev|staging|2120)\.)?campuscribz\.com\/listings\/((?:[-\w\+]){4,})/i, (res) ->
    subdomain = res.match[1]
    id = res.match[2]
    if subdomain is 'dev'
      username = process.env.SUPERSIGNIN_DEV_USERNAME
      password = process.env.SUPERSIGNIN_DEV_PASSWORD
    else if subdomain is '2120'
      username = process.env.SUPERSIGNIN_2120_USERNAME
      password = process.env.SUPERSIGNIN_2120_PASSWORD
    senddata res, id, res.match[0], username, password, true
