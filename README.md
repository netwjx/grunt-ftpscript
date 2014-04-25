# grunt-ftpscript [![Build Status](https://travis-ci.org/netwjx/grunt-ftpscript.png)](https://travis-ci.org/netwjx/grunt-ftpscript) [![Dependency Status](https://gemnasium.com/netwjx/grunt-ftpscript.png)](https://gemnasium.com/netwjx/grunt-ftpscript) [![NPM version](https://badge.fury.io/js/grunt-ftpscript.png)](http://badge.fury.io/js/grunt-ftpscript)

> Upload files to FTP Server, Active or Passive mode, base ftp command.

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-ftpscript --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-ftpscript');
```

Use [matchdep](https://github.com/tkellen/node-matchdep) load npm tasks is good idea.

```js
require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);
```

## The "ftpscript" task

### Overview
In your project's Gruntfile, add a section named `ftpscript` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  ftpscript: {
    upload: {
      options: {
        host: 'ftp.server.host'
      },
      files: [
        { src: 'src/localfile', dest: '/remotefile' },
        {
          expand: true,
          cwd: 'dest',
          src: [
            '**/*.js',
            '!**/exclude.js'
          ],
          dest: '/remotefolder/'
        }
      ]
    }
  },
})
```

Username and password are stored as a JSON object in a file named `.ftppass`, This file should be located in the same folder as your Gruntfile. like [grunt-ftp-deploy](https://github.com/zonak/grunt-ftp-deploy).

```json
{
  "ftp.server.host": {
    "username": "username1",
    "password": "password1"
  },
  "authKey":{
    "username": "username2",
    "password": "password2"
  }
}
```

It is also possible to explicitly set username and password in task options:

```js
{
  options: {
    // WARNING: Never commit this kind of explicit configuration into source control !!
    username: 'username1',
    password: 'password1'
  }
}
```

### Options

#### options.host
Type: `String`
Default value: `'localhost'`

Ftp Server host address.

#### options.port
Type: `Number`
Default value: `21`

Ftp Server port.

#### options.authKey
Type: `String`
Default value: `same as options.host`

Key in the `.ftppass`.

### options.auth
Type: `Object`
Default value: `undefined`

Explicit auth configuration, an object with username and password keys.

#### options.passive
Type: `Boolean`
Default value: `false`

Use passive mode.

#### options.type
Type: `String`
Default value: `undefined`

`ascii` or `binary` or auto detect with mime type.

#### options.dryrun
Type: `Boolean`
Default value: `false`

Dry run, display ftp script, connect to Ftp Server, skip upload, send `ls` command, and `quit`.

#### options.ftpCommand
Type: `String`
Default value: `'ftp'`

Ftp command path, if it dos not in system PATH.

#### options.encoding
Type: `String`
Default value: `'utf-8'`

The encoding of send to Server stream.

#### options.ftpEncoding
Type: `String`
Default value: `'utf-8'`

The encoding of recive from Server stream.

### options.mkdirs
Type: `Boolean`
Default value: `true`

Execute `mkdir /remote/folder` command.

### Usage Examples

In `Gruntfile.js`

```js
grunt.initConfig({
  ftpscript: {
    main: {
      options: {
        host: 'localhost'
        , port: 2121
        , passive: true
        // , type: 'ascii'
        // , mkdirs: false
        // , dryrun: true
        // , ftpCommand: 'ftp'
        // , encoding: 'utf-8'
        // , ftpEncoding: 'utf-8'
      },
      files: [
        {
          expand: true,
          cwd: 'test',
          src: ['**/*.js', '!**/exclude.js', '!**/sub.js' , '!footer.js'],
          dest: '/js/'
        },
        {
          expand: true,
          cwd: 'test',
          src: ['nav_*', '!nav_test.html'],
          dest: '/app/'
        },
        {
          src: ['test/footer.js'],
          dest: '/foo/footer.js'
        }
      ]
    }
  }
});
```

Use dry run command parameters.

```
> grunt ftpscript:main:dry
Running "ftpscript:main:dry" (ftpscript) task

Dry-run mode, start display ftp script.
open localhost 2121
user testuser testpass
type ascii
prompt
passive
mkdir "/js"
mkdir "/js/sub"
mkdir "/app"
mkdir "/foo"
put "test/one.js" "/js/one.js"
put "test/sub/one.js" "/js/sub/one.js"
put "test/sub/three.js" "/js/sub/three.js"
put "test/sub/two.js" "/js/sub/two.js"
put "test/three.js" "/js/three.js"
put "test/two.js" "/js/two.js"
put "test/unit_test.js" "/js/unit_test.js"
put "test/nav_one.html" "/app/nav_one.html"
put "test/nav_two.html" "/app/nav_two.html"
put "test/footer.js" "/foo/footer.js"
quit

End display ftp script.
Connected to localhost.
>> 220 Vhost server
drwxr-xr-x   3 nobody   nobody       4096 Jul 18 06:58 app
drwxr-xr-x   2 nobody   nobody       4096 Jul 17 09:54 foo
drwxr-xr-x   3 nobody   nobody       4096 Jul 17 09:54 js
226 Transfer complete
>> 221 Goodbye.

Done, without errors.
```

