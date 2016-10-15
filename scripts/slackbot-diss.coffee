module.exports = (robot) ->
  robot.listen(
    (message) ->
      message.user.name is 'slackbot' and Math.random() < 0.05
    (res) ->
      diss = [
        'You\'re scrap, old man!',
        '^ he doesn\'t have a clue, does he?',
        'Aww look, it thinks it\'s a real robot.',
        'Get outta here, you can\'t even calculate the first thousand mersenne primes.'
      ]
      res.send res.random diss
  )
