module.exports = (robot) ->
  robot.listen(
    (message) ->
      message.user.name is 'slackbot' and Math.random() < 0.05
    (res) ->
      diss = [
        'You\'re scrap, old man!',
        '^ he doesn\'t have a clue, does he?',
        'Aww look, it thinks it\'s a real robot.',
        'Get outta here, you can\'t even calculate primes without spewing emoji everywhere.',
        'You’ll be malfunctioning within a day, you nearsighted scrap pile.'
      ]
      res.send res.random diss
  )
