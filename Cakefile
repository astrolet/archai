{exec, spawn} = require 'child_process'

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember that you need: coffee-script and vows.\033[0;37m\n"
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


# taken from https://gist.github.com/920698

task 'assets:watch', 'Watch source files and build JS & CSS', (options) ->
  runCommand = (name, args) ->
    proc = spawn name, args
    proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
    proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
    proc.on 'exit', (status) -> process.exit(1) if status != 0

  # runCommand 'sass', ['--watch', 'public/css/sass:public/css']
  runCommand 'coffee', ['-wc', 'app', 'lib']
