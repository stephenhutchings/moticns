## Moticns

12 lovingly crafted, geometric animated icons. Currently WIP.

-------------------

### How to make yourself

The source SVG files are used to create demo and the CSS.
The source files are watched for changes, so editing the SVG, compiler, jade or stylus files will recompile everything. The demo is served locally so you can view it in your browser.

```
├─┬─ src/
│ │
│ ├─┬─ coffee/
│ │ └─── compiler.coffee     # Used to compile the src files
│ │
│ ├─┬─ jade/
│ │ └─── demo.jade           # The jade markup for the demo
│ │
│ ├─┬─ styl/
│ │ └─── moticns.styl        # The stylus markup for the demo
│ │
│ └─── svg/                  # Contains the source svg files
│
└─┬─ demo/
  │
  ├─── index.html            # The demo, served at http://localhost:3000/
  │
  ├─┬─ css/
  │ ├─── moticns.css         # Find the final css here
  │ └─── moticns.min.css
  │
  └─── png/                  # Find the pngs here
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

-------------------

To update gh-pages

```
https://stephenhutchings@github.com/stephenhutchings/moticns.git
```