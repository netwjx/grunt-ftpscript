module.exports = (grunt)->
  grunt.initConfig
    ftpscript:
      main:
        options:
          host: 'localhost'
          port: 2121
          passive: on
          # dryrun: on
          # ftpCommand: 'ftp'
          # encoding: 'utf-8'
          # ftpEncoding: 'utf-8'
        files: [
          {
            expand: on
            cwd: 'test'
            src: ['**/*.js', '!**/exclude.js', '!**/sub.js' , '!footer.js']
            dest: '/js/'
          }
          {
            expand: on
            cwd: 'test'
            src: ['nav_*', '!nav_test.html']
            dest: '/app/'
          }
          {
            src: ['test/footer.js']
            dest: '/foo/footer.js'
          }
        ]

    coffee:
      options:
        bare: on
      main:
        files: [
          {
            expand: on
            src: [
              'tasks/**/*.coffee'
              'test/**/*.coffee'
            ]
            ext: '.js'
          }
        ]

    coffeelint:
      options:
        max_line_length:
          value: 130
      main:
        files:
          src: [
            'Gruntfile.coffee'
            'tasks/**/*.coffee'
            'test/**/*.coffee'
          ]

    clean:
      main: [
        'tasks/*.js'
        'test/*_test.js'
      ]
    
    watch:
      main:
        # options:
        #   nospawn: on
        files: "<%= coffee.main.files.0.src %>"
        tasks: [
          'clean'
          'coffee'
        ]

    nodeunit:
      tests: [
       'test/*_test.js'
      ]

  require('matchdep').filterDev('grunt-*').forEach grunt.loadNpmTasks

  grunt.loadTasks 'tasks'

  grunt.registerTask 'test', [
    'nodeunit'
  ]

  grunt.registerTask 'default', [
    'clean'
    'coffeelint'
    'coffee'
  ]