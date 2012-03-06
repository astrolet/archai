_    = require 'underscore'
fs   = require 'fs'
json = require 'jsonify'

docs = "#{__dirname}/docs"
test = "#{__dirname}/test"

{basename, join} = require 'path'
{exec, spawn} = require 'child_process'
inspect = require('eyes').inspector({stream: null, pretty: false, styles: {all: 'magenta'}})
watchTree = require('watch-tree').watchTree
{series, parallel} = require 'async'


# Coffee-Scripts with Options. Appended to `coffee -c`, sometimes with `-w` too.
cso = [ "-o lib src" ]


# ANSI Terminal Colors.
bold  = "\033[0;1m"
red   = "\033[0;31m"
green = "\033[0;32m"
reset = "\033[0m"


# Utility functions

pleaseWait = ->
  console.log "\n#{bold}this may take a while#{green} ...\n"

print = (data) -> console.log data.toString().trim()

handleError = (err) ->
  if err
    console.log "\n\033[1;36m=>\033[1;37m Remember you need to `npm install` the package.json devDependencies and also `bundle install`.\033[0;37m\n"
    console.log err.stack

sh = (command) -> (k) -> exec command, k

# Modified from https://gist.github.com/920698
runCommand = (name, args) ->
  proc = spawn name, args
  proc.stderr.on 'data', (buffer) -> console.log buffer.toString()
  proc.stdout.on 'data', (buffer) -> console.log buffer.toString()
  proc.on 'exit', (status) -> process.exit(1) if status != 0

# shorthand to runCommand with
command = (c, cb) ->
  runCommand "sh", ["-c", c]
  cb


# First-time setup.  Pygments is required by docco.
task 'install', "Run once: npm, bundler, pygments, etc.", ->
  pleaseWait()
  command "
    curl http://npmjs.org/install.sh | sh
     && npm install
     && gem install bundler
     && bundle install
     && sudo easy_install Pygments
    "


# Check if any node_modules or gems have become outdated.
task 'outdated', "is all up-to-date?", ->
  pleaseWait()
  parallel [
    command "npm outdated"
    command "gem outdated"
  ], (err) -> throw err if err


# Usually follows `cake outdated`.
task 'update', "latest node modules & ruby gems - the lazy way", ->
  pleaseWait()
  parallel [
    command "npm update"
    command "bundle update"
  ], (err) -> throw err if err


# It's the local police at the root of chartra.
# Catches outdated modules that `cake outdated` doesn't report (major versions).
task 'police', "checks npm package & dependencies with `police -l .`", ->
  command "police -l ."


# Literate programming for the coffee sources.
task 'docs', "docco -- docs", ->
  series [
    sh "rm -rf #{docs}/"
    command "find src | grep .coffee | xargs docco"
  ], (err) -> throw err if err


# Coffee to JS -- in addition to the `cake dev` watch / compiling.
task 'cs2js', "compiles coffee scripts", ->
  for cs in cso
    command "coffee -c #{cs}"


# Get ready to deploy (everything).
task 'build', "ready to push & deploy", ->
  compile = (callback) ->
    command "
      npm install
       && npm shrinkwrap
       && cake cs2js
      "
    callback

  parallel [
    compile()
    invoke 'docs'
  ], (err) -> throw err if err


# Task options (for testing).
option '-b', '--bcat', "\t pipe via `bcat` to the browser as if it's the console"
option '-v', '--verbose', "\t verbose `cake test` option, pre-configured per test framework"
option '-t', '--tests [TESTS]', "\t comma-delimited tests list: framework or path/ or path/part"


# Run all the tests.
task 'test', "multi-framework tests", (options) ->
  # test frameworks configuration
  # constraint: everything in a path is run by a single unique framework
  frameworks = json.parse fs.readFileSync "#{test}/frameworks.json", 'utf8'

  # build reverse index of framework lookup by path
  paths = {}
  for runner, config of frameworks
    for path in config.paths
      paths[path] = runner

  # option defaults
  options.silent = true unless options.verbose

  # -t framework(s) or paths(s) override
  tfp = options.tests
  tfp = if tfp? then tfp.split(',') else _.keys frameworks

  for fp in tfp
    if fp.indexOf('/') is -1 # doesn't end in / (valid framework expectation)
      runner = fp
      unless frameworks[runner]?
        console.log "Invalid '#{runner}' test framework."
        continue # still run whatever else
      config = frameworks[runner]
      args = _.map config.paths, (path) -> "test/#{path}/*#{config.extension}"
    else # it contains a path, verify it's valid & configure
      path = fp.split('/')[0]
      unless paths[path]?
        console.log "Invalid test path: #{path}/."
        continue # still run whatever else
      runner = paths[path]
      config = frameworks[runner]
      args = ["test/#{fp}*#{config.extension}"]
    for option in ["silent", "verbose"]
      args.unshift config.alias[option] if options[option]?

    # TODO: these should probably be combined - so there is one `| bcat` output.
    execute = "NODE_ENV=#{options.env} ./node_modules/.bin/#{runner} #{args.join ' '}"
    execute += " | bcat" if options.bcat?
    command execute


task 'assets:watch', 'Broken: watch source files and build lib/*.js & docs/', (options) ->

  compileCoffee = (callback) ->
    runCommand 'coffee', ['-wc', 'lib']

  watchStuff = (callback) ->
    watch_rate = 100 #ms
    watch_info =
      1:
        path: "lib"
        options:
          'match': '.+\.coffee'
        events: ["filePreexisted", "fileCreated", "fileModified"]
        callback: -> console.log "you can't call me"

    # NOTE: it would be nice if the watch_info[n].callback could be called
    # ... and if we knew which event fired it - perhaps there is a way?

    watcher = {}
    for item, stuff of watch_info
      stuff.options['sample-rate'] = watch_rate
      for event in stuff.events
        watcher["#{item}-#{event}"] = watchTree(stuff.path, stuff.options)
        watcher["#{item}-#{event}"].on event, (what, stats) ->
          console.log what + ' - is being documented (due to some event), stats: ' + inspect(stats)
          if what.match /(.*)\/[^\/]+\.coffee$/ then runCommand 'docco', [what]
          else console.log "unrecognized file type of #{what}"

  series [
    (sh "rm -rf #{docs}/")
    parallel [compileCoffee, watchStuff]
  ], (err) -> throw err if err


# Build manuals / gh-pages almost exactly like https://github.com/josh/nack does

task 'man', "Build manuals", ->
  fs.readdir "doc/", (err, files) ->
    for file in files when /\.md/.test file
      source = join "doc", file
      target = join "man", basename source, ".md"
      exec "ronn --pipe --roff #{source} > #{target}", (err) ->
        throw err if err


task 'pages', "Build pages", ->

  buildMan = (callback) ->
    series [
      (sh "cp README.md doc/index.md")
      (sh 'echo "# UNLICENSE\n## LICENSE\n\n" > doc/UNLICENSE.md' )
      (sh "cat UNLICENSE >> doc/UNLICENSE.md")
      (sh "ronn -stoc -5 doc/*.md")
      (sh "mv doc/*.html pages/")
      (sh "rm doc/index.md")
      (sh "rm doc/UNLICENSE.md")
    ], callback

  buildAnnotations = (callback) ->
    series [
      invoke "docs"
      (sh "cp -r docs pages/annotations")
    ], callback

  build = (callback) ->
    parallel [buildMan, buildAnnotations], callback

  series [
    (sh "if [ ! -d pages ] ; then mkdir pages ; fi") # mkdir pages only if it doesn't exist
    (sh "rm -rf pages/*")
    build
  ], (err) -> throw err if err


task 'pages:publish', "Publish pages", ->

  checkoutBranch = (callback) ->
    series [
      (sh "rm -rf pages/")
      (sh "git clone -q -b gh-pages git@github.com:astrolet/lin.git pages")
      (sh "rm -rf pages/*")
    ], callback

  publish = (callback) ->
    series [
      (sh "cd pages/ && git add . && git commit -m 'rebuild manual' || true")
      (sh "cd pages/ && git push git@github.com:astrolet/lin.git gh-pages")
      (sh "rm -rf pages/")
    ], callback

  series [
    checkoutBranch
    (sh "cake pages") # NOTE: (invoke "pages") # doesn't work here after checkoutBranch
    publish
  ], (err) -> throw err if err
