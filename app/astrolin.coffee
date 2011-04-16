util = require 'util'
path = require 'path'
express = require 'express'
coffeekup = require 'coffeekup'

# Express app
app = express.createServer()

# Configuration
app.configure ->
  node_server = path.normalize __dirname
  app.set 'root', node_server
  app.use express.logger()
  app.use app.router
  app.use express.static(node_server + '/public')
  app.set 'views', node_server + '/views'  
  app.register '.coffee', coffeekup
  app.set 'view engine', 'coffee'
  app.set 'view options', { layout: yes }
  app.enable 'show exceptions'

# Home page
app.get "/", (req, res, next) ->
  @title = "Welcome"
  res.render "index", format: true

# Catch and log any exceptions that may bubble to the top.
process.addListener 'uncaughtException', (err) ->
  util.puts "Uncaught Exception: #{err.toString()}"

# Start the server.
port = parseInt(process.env.C9_PORT || process.env.PORT || 8001)
app.listen port, null # app.address().port # null host will accept connections from other instances
console.log "Express been started on :%s", port
