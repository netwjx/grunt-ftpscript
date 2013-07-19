ftpscript = require '../tasks/ftpscript'
generateUpload = ftpscript.generateUpload


exports.generate =
  setUp: (cb)->
    this.dirs = {}
    this.files = []
    cb()
  tearDown: (cb)->
    cb()
  test1: (test)->
    generateUpload this.dirs, this.files,
      src: ['/foobar/foo.js']
      dest: '/foo/bar'

    test.expect 2
    test.equal this.dirs['foo'], on
    test.equal this.files[0], 'put "/foobar/foo.js" "/foo/bar"'
   
    test.done()

  test2: (test)->
    generateUpload this.dirs, this.files,
      src: ['/foo/bar.js']
      dest: '/foo/bar/'

    test.expect 3
    test.equal this.dirs['foo'], on
    test.equal this.dirs['foo/bar'], on
    test.equal this.files[0], 'put "/foo/bar.js" "/foo/bar/"'

    test.done()
