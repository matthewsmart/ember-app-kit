# Use this option to have the catch-all return a different
# page than index.html on any url not matching an asset.
#   wildcard: 'not_index.html'

# works with tasks/locking.js
lock = (req, res, next) ->
  (retry = ->
    if lockFile.checkSync("tmp/connect.lock")
      setTimeout retry, 30
    else
      next()
  )()
wildcardResponseIsValid = (request) ->
  urlSegments = request.url.split(".")
  extension = urlSegments[urlSegments.length - 1]
  ["GET", "HEAD"].indexOf(request.method.toUpperCase()) > -1 and (urlSegments.length is 1 or extension.indexOf("htm") is 0 or extension.length > 5)
buildWildcardMiddleware = (options) ->
  (request, response, next) ->
    return next()  unless wildcardResponseIsValid(request)
    wildcard = (options.wildcard or "index.html")
    wildcardPath = options.base + "/" + wildcard
    fs.readFile wildcardPath, (err, data) ->
      return next((if "ENOENT" is err.code then null else err))  if err
      response.writeHead 200,
        "Content-Type": "text/html"

      response.end data

middleware = (connect, options) ->
  # Remove this middleware to disable catch-all routing.
  [require("connect-livereload")(), lock, connect["static"](options.base), connect.directory(options.base), buildWildcardMiddleware(options)]
lockFile = require("lockfile")
fs = require("fs")
url = require("url")
module.exports =
  livereload:
    options:
      base: "tmp/public"
      middleware: middleware

  server:
    options:
      port: process.env.PORT or 8000
      hostname: "0.0.0.0"
      base: "tmp/public"
      middleware: middleware

  dist:
    options:
      port: process.env.PORT or 8000
      hostname: "0.0.0.0"
      base: "dist/"
      middleware: middleware

