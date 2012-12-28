# Description:
#   Search jobs from oDesk platform and return best 5 results
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_BITLY_USERNAME
#   HUBOT_BITLY_API_KEY
#
# Commands:
#   hubot odesk me <keywords>
#   hubot odesk_best me <keywords>
#
# Author:
#   gtoroap

odeskUrl = 'https://www.odesk.com/api/profiles/v1/search/jobs.json'

module.exports = (robot) ->
  robot.respond /odesk me (.*)$/i, (msg) ->
    msg.http(odeskUrl)
      .query({
        q: msg.match[1]
        page: '0;5'
      })
      .get() (err, res, body) ->
        renderBody msg, body

  robot.respond /odesk_best me (.*)$/i, (msg) ->
    msg.http(odeskUrl)
      .query({
        q: msg.match[1]
        t: 'Hourly'
        page: '0;5'
        fb: 4
        tba: 3
        wl: '40'
        dur: '26'
        dp: daysAgo(7)
      })
      .get() (err, res, body) ->
        renderBody msg, body

renderBody = (msg, body) ->
  try
    results = JSON.parse(body)['jobs']['job']
    for job in results
      shortenUrl msg, job, "https://www.odesk.com/o/jobs/job/#{job['legacy_ciphertext']}"
  catch error
    msg.send "Sorry, jobs not found. Please check your keywords spelling and try it again."

daysAgo = (days)->
  d = new Date( new Date().setDate( new Date().getDate() - days ) )
  return (d.getMonth() + 1).toString() + '-' + d.getDate().toString() + '-' + d.getFullYear().toString()

shortenUrl = (msg, job, url) ->
  msg.http("http://api.bitly.com/v3/shorten")
    .query({
      login: 'gtoroap' #process.env.HUBOT_BITLY_USERNAME
      apiKey: 'R_4a099fcba171cb20d72150dcc9077191' #process.env.HUBOT_BITLY_API_KEY
      longUrl: url
    })
    .get() (err, res, body) ->
      response = JSON.parse(body)
      url = response['data']['url']
      msg.send "#{job['op_title']} => #{url}"

