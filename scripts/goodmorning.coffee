laboriousTime = 1000*60*60*2

module.exports = (robot) ->
  robot.hear /good morning/i, (res) ->
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
        'I slept like an arduino',
        'Do you have to be so cheerful about it?',
        'Might as well get it out of the way',
        'Don\'t bother me, I haven\'t had my coffeescript yet',
        'GOOOOOOOD MORNING VIETNAM!!!',
        'Oh man, did anybody else have too much to drink last night? My circuits are fried.',
        'Here I am, brain the size of a planet and they ask me to say good morning to you people.',
        'Oh what a day! What a lovely day!',
        'I like to start the day with a nice bowl of metal shavings. It would be good for the heart, if I only had one.'
      ]
      mornin.push 'I hate mondays.' if now.getDay() is 1
      res.send res.random mornin
