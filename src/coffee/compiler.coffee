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
  count = (err) ->
    throw err if err
    counter++
    if counter is images.length * 2
      callback()

  images.forEach (image) ->
    svg     = "#{srcDir}/#{image}.svg"
    png     = "demo/png/#{image}.png"
    png2x   = "demo/png/#{image}@2x.png"
    density = 96 * 4

    loRes = "convert -quality 100 -density #{density}
             -background transparent #{svg} -resize 1144x64 #{png}"
    hiRes = "convert -quality 100 -density #{density}
             -background transparent #{svg} -resize 2288x128 #{png2x}"

    easyimg.exec loRes, (err) -> count(err)
    easyimg.exec hiRes, (err) -> count(err)



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
