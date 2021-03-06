module.exports =
  main:
    files: ['app/**/*', 'public/**/*', 'vendor/**/*', 'tests/**/*']
    tasks: ['build:debug']
  test:
    files: ['app/**/*', 'public/**/*', 'vendor/**/*', 'tests/**/*']
    tasks: ['build:debug', 'karma:server:run']
  options:
    debounceDelay: 200
    livereload: 35729

