content-builder
===============
content-builder is a simple builder for you to build application js/cs/css files through
a simple manifest.

## Why do we need this?

To develop a js/css library, we don't need such heavy tools like (require.js)
to build our js/cs/css library, what we need a simple enough tool to concat and
minify these contents to a single file.

In some cases, we need to build js/css library by selecting components,
require.js is just too heavy for building.

And in some cases, we need to build our js/css library as small as possible,
but you need to add a lot of `define` function in your source code while using require.js
or other AMD tools.

To use require.js or not in application codebase, the decision is made by users, so we made this.

By using `content-builder`, you can define many manifest for different usage. 
also, users can easily customize their builds as what they need.

content-builder provides a filter interface, you can register your custom filter directly.

## Install

    npm install content-builder

## Usage

First, define a simple manifest file called `app.manifest`:

    lib/app.js
    lib/widget_a.js
    lib/widget_b.js
    lib/widget_c.js
    lib/widgets.js

Then define the code below to compile your content:

```coffee
ContentBuilder = require "content-builder"
builder = new ContentBuilder("app.manifest",{ 
    baseDir: "js"
})
content = builder.compile()
```

