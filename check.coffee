{ log } = console
{ env, exit } = process

_ = require 'lodash'

fs = require 'fs'
util = require 'util'
child_process = require 'child_process'

SLEEP_TIME = 450
DO_NUMBERS = false
FILENAME = '3chars.txt'

sleep = (ms) -> new Promise (resolve, reject) ->
  setTimeout resolve, ms

checkUsername = (username) ->
  new Promise (resolve, reject) ->
    commandStr = fs.readFileSync('.curl-request', 'utf8')
    commandStr = commandStr.split('__replace__').join(username)

    child_process.exec commandStr, (error, stdout, stderr) ->
      if error
        throw error

      if stdout.toLowerCase().includes('is not available')
        return resolve(false)
      else if stdout.toLowerCase().includes('is unavailable')
        return resolve(false)
      else if stdout.toLowerCase().includes('is available')
        return resolve(true)
      else
        log username
        log stdout
        throw new Error 'unparsable'

try
  checkedWords = fs.readFileSync('checked.txt', 'utf8').split('\n')
catch error
  checkedWords = []

wordList = require('fs').readFileSync(FILENAME, 'utf8')
wordList = wordList.split '\n'
wordList = _.shuffle wordList
wordList = _.compact _.uniq _.map wordList, (x) -> x.trim()
wordList = _.compact _.map wordList, (x) ->
  if x.length < 2
    return null
  if x.length > 3
    return null
  x
wordList = _.shuffle wordList

for word in wordList
  for x in [0..10]
    continue if !DO_NUMBERS and x in [0..9]
    if x is 10 then x = ''
    username = word + x

    continue if checkedWords.includes(username + '\n')

    try
      result = await checkUsername(username)
    catch e
      log e
      continue

    log {username:username, available:result}

    if result
      fs.appendFileSync 'available.txt', "#{username}\n"

    fs.appendFileSync 'checked.txt', "#{username}\n"

    await sleep SLEEP_TIME

