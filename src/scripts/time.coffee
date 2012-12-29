# Description:
#   Search jobs from oDesk platform and return best 5 results
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_WWO_API_KEY
#
# Commands:
#   hubot time in <city> - Get current time in city
#
# Notes
#   City parameter can be:
#     city
#     city, country
#     ip address
#     latitude and longitude (in decimal)
#
# Author:
#   gtoroap
#
module.exports = (robot) ->
  robot.respond /time in (.*)/i, (msg) ->
    msg.http('http://www.worldweatheronline.com/feed/tz.ashx')
      .query({
        q: msg.match[1]
        key: '4e7947013a111525122912' #process.env.HUBOT_WWO_API_KEY
        format: 'json'
      })
      .get() (err, res, body) ->
        result = JSON.parse(body)['data']
        city = result['request'][0]['query']
        currentTime = result['time_zone'][0]['localtime'].slice 11
        msg.send "Current time in #{city} ==> #{currentTime}"
