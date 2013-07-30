module.exports = exports = (grunt)->
  grunt.registerMultiTask 'ftpscript', grunt.file.readJSON('package.json').description, (args...)->
    opts = @options
      host: 'localhost'
      port: 21
      passive: no
      dryrun: no
      ftpCommand: 'ftp'
      encoding: 'utf-8'
      ftpEncoding: 'utf-8'

    auth = grunt.file.readJSON('.ftppass')?[opts.authKey ? opts.host]

    if !auth or !auth.username
      grunt.fatal "Not found \"#{ opts.authKey }\" or \"#{ opts.host }\" in file .ftppass"
      return no

    cmds = [
      "open #{ opts.host } #{ opts.port }"
      "user #{ auth.username } #{ auth.password }"
      'type binary'
      'prompt'
    ]
    cmds.push 'passive' if opts.passive

    dirs = {}
    files = []

    generateUpload dirs, files, f for f in @files
      

    dirs = for i of dirs
      "mkdir \"#{ i }\""

    for dry in ['dry', 'dryrun', 'dry-run']
      if dry in args
        opts.dryrun = on
    if opts.dryrun
      grunt.log.writeln cmds.concat('!echo In dry-run mode', dirs, files, '!echo In dry-run mode', 'quit' , '').join('\n')
      cmds = cmds.concat 'ls'
    else
      cmds = cmds.concat dirs, files
    cmds = cmds.concat('quit', '').join '\n'

    p = require('child_process').spawn opts.ftpCommand, ['-nv']
    done = @async()
    p.on 'exit', (code, signal)->
      if code
        grunt.fatal signal, code
        grunt.fatal 'Upload failed!'
        done no
      else
        done()

    p.stdin.setEncoding opts.encoding
    p.stdout.setEncoding opts.ftpEncoding

    p.stdout.on 'data', (data)->
      for line in data.split '\n'
        if /^5\d{2}/.test(line) or /^Not connected/.test(line)
          grunt.warn line
        else if /^221 /.test line
          grunt.log.ok line
        else
          grunt.log.writeln line
      return
    p.stdin.write cmds
    return

generateUpload = exports.generateUpload = (dirs, files, f)->
  files.push "put \"#{ src }\" \"#{ f.dest }\"" for src in f.src
  paths = f.dest.split('/')[1..-2]
  for p, i in paths
    dirs[paths[0..i].join('/')] = on
