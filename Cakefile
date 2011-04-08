{exec, spawn} = require 'child_process'

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember that you need: coffee-script, vows and assert.\033[0;37m\n"
    console.log err.stack

print = (data) -> console.log data.toString().trim()


option '-s', '--spec', 'Use Vows spec mode'
option '-v', '--verbose', 'Verbose vows when necessary'

task 'test', 'Test the app', (options) ->

  args = [
    'spec/test_gaia.coffee'
  ]
  args.unshift '--spec'     if options.spec
  args.unshift '--verbose'  if options.verbose

  vows = spawn 'vows', args
  vows.stdout.on 'data', print
  vows.stderr.on 'data', print
