# Require
fs      = require("fs")
jade    = require("jade")
nib     = require("nib")
stylus  = require("stylus")
easyimg = require("easyimage")

# Variables
srcDir   = "./src/svg"
demoJade = "./src/jade/demo.jade"
demoHtml = "./demo/index.html"
demoStyl = "./src/styl/moticons.styl"

_images = null

# Read src directory and find SVG"s
compile = () ->
  console.log "hello"
  fs.readdir "#{srcDir}", (err, files) ->
    throw err if err

    # Ensure there are only SVG files and map to name without suffix
    images = files.filter((image) -> image.match(/\.svg/gi))
                  .map((image) -> image.replace(/\.svg/gi, ""))

    console.log images

    _images = images

    # Covert the SVG files into PNG"s and generate CSS
    createPngs(images)
    createHtml(images)
    createCss(images)


# Creates low and high resolution pngs using easyimage
createPngs = (images) ->
  images.forEach (image) ->
    svg     = "#{srcDir}/#{image}.svg"
    png     = "demo/png/#{image}.png"
    png2x   = "demo/png/#{image}@2x.png"
    density = 96 * 4

    loRes = "convert -density #{density} -background transparent #{svg} -resize 1144x64  #{png}"
    hiRes = "convert -density #{density} -background transparent #{svg} -resize 2288x128 #{png2x}"

    easyimg.exec loRes, (err) -> throw err if err
    easyimg.exec hiRes, (err) -> throw err if err


# Read, convert and save the jade file
createHtml = (images) ->
  fs.readFile demoJade, "utf8", (err, data) ->
    throw err if err

    html = jade.compile data
    fs.writeFileSync demoHtml, html(images)


# Read, convert and save the stylus file
createCss = (images) ->
  fs.readFile demoStyl, "utf8", (err, data) ->
    throw err if err

    stylus(data)
      .define("list", images)
      .use(nib())
      .import('nib')
      .render((err, css) ->
        throw err if err
        fs.writeFile("./demo/css/moticons.css", css))

module.exports.compile = compile
module.exports.compilo = compile