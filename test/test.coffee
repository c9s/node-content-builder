assert = require "assert"
ContentBuilder = require "../index.coffee"

assert.ok ContentBuilder

builder = new ContentBuilder("test/app.manifest",{ baseDir: "test" })
assert.ok builder

content = builder.compile()
assert.ok content

