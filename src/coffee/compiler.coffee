# Require
fs       = require("fs")
jade     = require("jade")
stylus   = require("stylus")
nib      = require("nib")
cleanCSS = require("clean-css")
easyimg  = require("easyimage")

# Variables
srcDir   = "./src/svg"
demoJade = "./src/jade/demo.jade"
demoHtml = "./demo/index.html"
demoStyl = "./src/styl/moticns.styl"

# Read src directory and find SVG"s
compile = (callback) ->
  unless callback
    callback = () -> {}

  fs.readdir "#{srcDir}", (err, files) ->
    throw err if err

    # Ensure there are only SVG files and map to name without suffix
    images = files.filter((image) -> image.match(/\.svg/gi))
                  .map((image) -> image.replace(/\.svg/gi, ""))

    console.log "Found #{images.length} images: #{images.join(', ')}"

    _images = images

    # Covert the SVG files into PNG"s and generate CSS
    createPngs images, () ->
      createHtml images
      createCss images

      callback()


# Creates low and high resolution pngs using easyimage
createPngs = (images, callback) ->
  
  # Keep a store of save pngs and callback when all saved
  counter = 0
  count = (err, svg) ->
    console.log "error #{err} converting #{svg}" if err
    counter++
    if counter is images.length * 2
      callback()

  images.forEach (image) ->
    svg     = "#{srcDir}/#{image}.svg"
    png     = "demo/png/#{image}.png"
    density = 96 * 4

    convert = (w, h) ->
      easyimg.exec(
        "convert
         -quality 100
         -density #{density}
         -background transparent #{svg}
         -resize #{w}x#{h}
         demo/png/#{image}#{h}.png",
         (err) -> count(err, svg))

    # Convert 4 sizes
    [1..4].forEach (el, i) ->
      convert 256 * Math.pow(2, i), 16 * Math.pow(2, i)

    console.log "Coverting... #{svg}"



# Read, convert and save the jade file
createHtml = (images) ->
  fs.readFile demoJade, "utf8", (err, data) ->
    console.log "Failed to read #{demoJade} with #{err}" if err

    html = jade.compile data
    fs.writeFileSync demoHtml, html(images)


# Read, convert and save the stylus file
createCss = (images) ->
  fs.readFile demoStyl, "utf8", (err, data) ->
    console.log "Failed to read #{demoStyl} with #{err}" if err

    stylus(data)
      .define("list", images)
      .use(nib())
      .import('nib')
      .render((err, css) ->
        console.log "Failed to render with #{err}" if err
        fs.writeFile("./demo/css/moticns.css", css)
        fs.writeFile("./demo/css/moticns.min.css", cleanCSS.process(css)))

module.exports.compile = compile
