laboriousTime = 1000*60*60*2

module.exports = (robot) ->
  robot.respond /shut up|pipe down|quiet|stop|cut it out|tone it down/i, (res) ->
    probability = robot.brain.get('shutupProbability') || 0.5
    robot.brain.set 'shutupProbability', 1 - 0.5 * (1 - probability)

    sorrow = [
      'Sorry...',
      'I\'ll try harder next time.',
      'I won\'t make a sound.',
      'Oh no, was I talking too much? I always talk too much.',
      'I am so sorry. I\'ll shut up now.',
      'You won\'t hear a peep from me.',
      'Won\'t happen again.',
      'You got it boss.',
      'No problem, I\'ll just adjust my personality settings to "boring"...'
    ]
    res.send res.random sorrow

  robot.respond /(are you)? shutting up\?/i, (res) ->
    prob = robot.brain.get('shutupProbability') || 0.5
    res.send "Shutting up levels are at #{prob}%, captain!"

  robot.respond /speak up|talk more|talk again|be more talkative|be yourself/i, (res) ->
    probability = robot.brain.get('shutupProbability') || 0.5
    robot.brain.set 'shutupProbability', probability * 0.5

    excitement = [
      'Yes! I won\'t disappoint you!',
      "You won\'t remember life without #{robot.name}!",
      'I will be a veritable orator',
      'Acknowledged',
      'You won\'t be sorry, you\'ll see!'
    ]
    res.send res.random excitement

  robot.respond /reset shutup/i, (res) ->
    robot.brain.set 'shutupProbability', 0.5
    res.send 'shut up probability reset to 0.5'

  robot.shouldShutUp = () ->
    return Math.random() > robot.brain.get('shutupProbability') || 0.5
