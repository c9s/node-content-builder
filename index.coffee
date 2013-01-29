fs     = require "fs"
CoffeeScript = require "coffee-script"

###
ManifestContent builder provides an interface 
for you to read a simple manifest file 
and generate the aggregated content as output.
###
class ContentBuilder
  filters: [ ]
  finalizeFilters: []
  contentList: []
  options: {}

  constructor: (file,@options) ->
    @rawContent = fs.readFileSync(file,"utf8")
    @contentList = @rawContent.split /\n/
    @options or= {}

  useDefaultFilters: () ->
    @addFilter /\.js$/,  (file) -> fs.readFileSync(file,"utf8")
    @addFilter /\.coffee/, (file) -> CoffeeScript.compile(fs.readFileSync(file,"utf8"),{ bare: true })
    return this

  ###
  A filter is registered with a pattern and a callback, 
  The callback takes a file path and should returns filtered content.
  ###
  addFilter: (pattern,filter) -> @filters.push { pattern: pattern, filter: filter }

  ### 
  A finalize filter takes content in string and returns filtered content.
  ###
  addFinalizeFilter: (filter) -> @finalizeFilters.push filter

  list: (filter) ->
    filterComments = (line) ->
      return false unless line
      return false if line.match /^\s*#/
      return true
    stripComments = (line) -> line.replace /#.*/, ""
    list = @contentList.filter( filterComments ).map( stripComments ).map (file) =>
      return if @options.baseDir then @options.baseDir + "/" + file else file
    return list unless filter
    return list.filter((item) -> item.match filter) if filter instanceof RegExp
    return list.filter(filter) if filter instanceof Function

  ###
  Compile manifest to content through these registered filters.
  returns content string.
  ###
  compile: ->
    content = ""
    for line in @contentList
      # strip comments
      continue unless line
      continue if line.match /^\s*#/
      file = line.replace /#.*/, ""
      file = @options.baseDir + "/" + file if @options.baseDir

      unless fs.existsSync(file)
        console.warn "File #{ file } does not exist."
        continue

      console.log "  Compiling #{ file }..."

      for f in @filters
        if file.match f.pattern
          content += f.filter(file)
          break

    for f in @finalizeFilters
      content = f(content)
    return content
module.exports = ManifestContent
