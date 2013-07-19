[![Build Status](https://travis-ci.org/netwjx/grunt-ftpscript.png)](https://travis-ci.org/netwjx/grunt-ftpscript)

# grunt-ftpscript

> Upload files to FTP Server, Active or Passive mode, bash ftp command.

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
          expand: on,
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

#### options.passive
Type: `Boolean`
Default value: `false`

Use passive mode.

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


### Usage Examples

```js
grunt.initConfig({
  ftpscript: {
    main: {
      options: {
        host: 'localhost',
        port: 2121,
        passive: on,
        # dryrun: on,
        # ftpCommand: 'ftp',
        # encoding: 'utf-8',
        # ftpEncoding: 'utf-8'
      },
      files: [
        {
          expand: on,
          cwd: 'test',
          src: ['**/*.js', '!**/exclude.js', '!**/sub.js' , '!footer.js'],
          dest: '/js/'
        },
        {
          expand: on,
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
open localhost 2121
user username1 password1
type binary
prompt
passive
!echo In dry-run mode
mkdir "js"
mkdir "js/sub"
mkdir "app"
mkdir "foo"
put "test/one.js" "/js/one.js"
put "test/sub/one.js" "/js/sub/one.js"
put "test/sub/three.js" "/js/sub/three.js"
put "test/sub/two.js" "/js/sub/two.js"
put "test/three.js" "/js/three.js"
put "test/two.js" "/js/two.js"
put "test/nav_one.html" "/app/nav_one.html"
put "test/nav_two.html" "/app/nav_two.html"
put "test/footer.js" "/foo/footer.js"
!echo In dry-run mode
quit

Connected to localhost.
220 Vhost server
331 Password required for testuser

230 Anonymous access granted, restrictions apply

Remote system type is UNIX.
Using binary mode to transfer files.
200 Type set to I

Interactive mode off.
Passive mode on.
227 Entering Passive Mode (127,0,0,1,255,253).

150 Opening ASCII mode data connection for file list

drwxr-xr-x   3 nobody   nobody       4096 Jul 18 06:58 app
drwxr-xr-x   2 nobody   nobody       4096 Jul 17 09:54 foo
drwxr-xr-x   3 nobody   nobody       4096 Jul 17 09:54 js
226 Transfer complete

>> 221 Goodbye.

```

