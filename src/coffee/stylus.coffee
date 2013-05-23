stylus = require('stylus')
str = require('fs').readFileSync('./src/styl/demo.styl', 'utf8')

stylus(str)
  # .set('filename', './src/styl/demo.styl')
  .define('list', [1,2,3])
  .render (err, css) ->
    throw err if err
    require('fs').writeFileSync('./src/styl/demo.css', css)