# Description:
#   Search jobs from oDesk platform and return top 5 results
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot odesk me <keywords>
#
# Author:
#   gtoroap

module.exports = (robot) ->
  robot.respond /odesk me (.*)$/i, (msg) ->

    msg.http("https://www.odesk.com/api/profiles/v1/search/jobs.json")
      .query({
        q: msg.match[1]
        page: '0;5'
      })
      .get() (err, res, body) ->
        try
          results = JSON.parse(body)['jobs']['job']
          for job in results
            msg.send "#{job['op_title']} | https://www.odesk.com/o/jobs/job/#{job['legacy_ciphertext']}"
        catch error
          msg.send "Sorry, a temporary error has occurred. Please, try again in a few minutes."
