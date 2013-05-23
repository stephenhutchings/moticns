#!/usr/bin/env coffee

# Dependencies
watch    = require("watch")
static_  = require("node-static")
compiler = require("./src/coffee/compiler")


# Initial compile
compiler.compile()


# Start a server to view the files
fileServer = new static_.Server("./demo")
require("http").createServer((request, response) ->
  request.addListener("end", ->
    fileServer.serve request, response
  ).resume()
).listen 3000


# Recompile on change any source, including the compiler
watch.createMonitor "./src", (monitor) ->
  restart = () ->
    # In case the 
    delete require.cache[require.resolve("./src/coffee/compiler")]
    compiler = require("./src/coffee/compiler")
    compiler.compile()

  monitor.files["./src/*"]
  monitor.on "created", (f, stat) ->
    # Handle new files
    console.log "created #{f}"
    restart()

  monitor.on "changed", (f, curr, prev) ->
    # Handle file changes
    console.log "changed #{f}"
    restart()

  monitor.on "removed", (f, stat) ->
    # Handle removed files
    console.log "removed #{f}"
    restart()