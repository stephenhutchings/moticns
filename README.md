## Moticns

12 lovingly crafted, geometric animated icons.

------------------------

### How to use

The source SVG files are used to create demo and the CSS.
The source files are watched for changes, so editing the SVG, compiler, jade or stylus files will recompile everything. The demo is served locally so you can view it in your browser.

```
|- src/
|  |- coffee/
|  |  |- compiler.coffee      # Used to compile the src files
|  |
|  |- jade/
|  |  |- compiler.coffee      # The jade markup for the demo
|  |
|  |- styl/
|  |  |- moticns.styl         # The stylus markup for the demo
|  |
|  |- svg/                    # Contains the source svg files
|
|- demo/
   |- index.html              # The demo, served at http://localhost:3000/
   |
   |- css/
   |  |- moticns.css
   |  |- moticns.min.css
   |
   |--png/

```

Install with npm...

```
npm install
```

And run with...

```
coffee watch.coffee
```

Navigate to...

```
http://localhost:3000/
```

Edit/save the SVG, and refresh the page. Voila!