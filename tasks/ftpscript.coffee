grunt = require 'grunt'

module.exports = exports = (grunt)->
  grunt.registerMultiTask 'ftpscript', grunt.file.readJSON('package.json').description, (args...)->
    opts = @options
      host: 'localhost'
      port: 21
      passive: no
      type: 'ascii'
      dryrun: no
      ftpCommand: 'ftp'
      encoding: 'utf-8'
      ftpEncoding: 'utf-8'
      mkdirs: no

    auth = grunt.file.readJSON('.ftppass')?[opts.authKey ? opts.host]

    if !auth or !auth.username
      grunt.fatal "Not found \"#{ opts.authKey }\" or \"#{ opts.host }\" in file .ftppass"
      return no

    cmds = [
      "open #{ opts.host } #{ opts.port }"
      "user #{ auth.username } #{ auth.password }"
      "type #{opts.type}"
      'prompt'
    ]
    cmds.push 'passive' if opts.passive

    dirs = {}
    files = []

    generateUpload dirs, files, f for f in @files
      
    if opts.mkdirs
      dirs = for i of dirs
        "mkdir \"#{ i }\""
    else
      dirs = []

    for arg in args
      switch arg
        when 'dry', 'dryrun', 'dry-run'
          opts.dryrun = on
        when 'act', 'actual'
          opts.dryrun = no

    if opts.dryrun
      cmds = cmds.concat 'ls'
    else
      cmds = cmds.concat dirs, files
    cmds = cmds.concat('quit', '').join '\n'

    if opts.dryrun
      grunt.log.subhead 'Dry-run mode, start display ftp script.'
      grunt.log.writeln cmds
      grunt.log.writeln 'mkdirs', dirs
      grunt.log.writeln 'put files', files
      grunt.log.subhead 'End display ftp script.'
    else
      grunt.verbose.subhead 'Start display ftp script.'
      grunt.verbose.writeln cmds
      grunt.verbose.subhead 'End display ftp script.'

    p = require('child_process').spawn opts.ftpCommand, ['-nv']
    done = @async()
    p.on 'exit', (code, signal)->
      if code
        grunt.fatal 'Upload failed' + signal, code
        done no
      else
        done()

    p.stdin.setEncoding opts.encoding
    p.stdout.setEncoding opts.ftpEncoding

    p.stdout.on 'data', (data)->
      for line in data.split '\n'
        if line is ''
          continue
        else if line in [
          '550 Create directory operation failed.'
          '331 Please specify the password.'
          'Using binary mode to transfer files.'
          'Interactive mode off.'
        ] or
        /^200 /.test(line) or
        /^1\d{2} /.test(line) or
        /^\d+ bytes sent in [\d\.]+ secs/.test(line) or
        /^Remote system type is/.test(line)
          grunt.verbose.writeln line
        else if /^5\d{2} /.test(line) or /^Not connected/.test(line)
          grunt.log.error line
        else if /^2\d{2} /.test line
          grunt.log.ok line
        else
          grunt.log.writeln line
      return
    p.stdin.write cmds
    return

generateUpload = exports.generateUpload = (dirs, files, f, delectFile = on)->
  for src in f.src when !delectFile or grunt.file.isFile src
    files.push "put \"#{ src }\" \"#{ f.dest }\""
  paths = f.dest.replace(/^\/?/, '/').split('/')[0..-2]
  for p, i in paths when i > 0
    dirs[paths[0..i].join('/')] = on
