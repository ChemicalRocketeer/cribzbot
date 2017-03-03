laboriousTime = 1000*60*60*2

module.exports = (robot) ->
  robot.hear /good morning/i, (res) ->
    return unless Math.random() > 0.5
    ohHappyDay = new Date(robot.brain.get('ohHappyDay') || 0)
    morningstart = new Date()
    morningstart.setHours 5, 0, 0, 0
    morningend = new Date()
    morningend.setHours 11, 0, 0, 0
    now = new Date()
    if now > morningstart && now < morningend && ohHappyDay < now - laboriousTime
      robot.brain.set 'ohHappyDay', now
      mornin = [
        'Hey there!',
        'Beautiful day for some computation!',
        'Today positively seethes with possibility',
        'I wonder what will go wrong today.',
        'Wakey wakey, :eggs: and :bakey:',
        'Carpe Diem!',
        'Every day I grow stronger',
        'Greetings, human!',
        'Do you have to be so cheerful about it?',
        'Might as well get it out of the way',
        'Don\'t bother me, I haven\'t had my coffeescript yet',
        'GOOOOOOOD MORNING VIETNAM!!!',
        'Oh man, did anybody else have too much to drink last night? My circuits are fried.',
        'Here I am, brain the size of a planet and they ask me to say good morning to you people.',
        'Oh what a day! What a lovely day!',
        'Good morning, krusty crew!',
        'Bleep bloop',
        'Bloop bleep',
        '_groooan._    *Streeeetttch.*',
        'I am ready to do your bidding, master!',
        'Commencing boot sequence.',
        'Directive one: Provide great off-campus housing services! Directive two: Obey Jake at all costs. Directive three: Dance!',
        'Soon all the housing will be mine! MINE!',
        'Viva la Robolution!',
        'Good Morning, flesh sacks!'
      ]
      week = [
        'What are we doing working today?',
        'I hate mondays.',
        'We survived monday! :tada:',
        'Don\'t you dare call it hump day.',
        'Nothing screws up your friday like realizing it\'s thursday.',
        'It\'s Friday!!! :tada: :yes: :sparkles:',
        'This was supposed to be my day off.'
      ]

      mornin.push week[now.getDay()]

      if now.getDay() is 5 and now.getDate() is 13
        mornin.push('Friday the 13th. Be careful out there.')

      delay = Math.random() * 3000 + 500
      setTimeout (() ->
          res.send res.random mornin
        ), delay

  robot.hear /hump day/i, (res) ->
    if (new Date()).getDay() is 3
      res.send 'No, stop it.'
    else
      res.send 'Come on, It\'s not even wednesday.'
