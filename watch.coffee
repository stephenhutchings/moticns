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
  compiling = false
  console.log "compiler -> watching"

  restart = (f) ->
    return if compiling

    # Cachebust the compiler
    if f is "src/coffee/compiler.coffee"
      delete require.cache[require.resolve("./src/coffee/compiler")]
      compiler = require("./src/coffee/compiler")

    # Delay recompile with slower SVG files
    buffer = if f.match(/\.svg/gi) then 100 else 0

    compiler.compile () ->
      # Allow restart
      console.log "compiler -> complete"
      setTimeout ( ->
        compiling = false
        console.log "compiler -> watching"
      ), buffer

    compiling = true
    console.log "compiler -> compiling"

  monitor.files["./src/*"]
  monitor.on "created", (f, stat) ->
    # Handle new files
    console.log "created #{f}"
    restart(f)

  monitor.on "changed", (f, curr, prev) ->
    # Handle file changes
    console.log "changed #{f}"
    restart(f)

  monitor.on "removed", (f, stat) ->
    # Handle removed files
    console.log "removed #{f}"
    restart(f)