module.exports = (grunt) ->
    # Project configuration
    grunt.initConfig
        pkg: grunt.file.readJSON("package.json")
        jade:
            compile:
                options:
                    pretty: true
                files: [
                    expand: true
                    cwd: "src"
                    src: "**/*.jade"
                    dest: "build"
                    ext: ".html"
                    extDot: 'last'
                ]
        coffee:
            options:
                join: true
                sourceMap: true
            compile:
                files:
                    "build/app.spec.js": "src/**/*.spec.coffee"
                    "build/app.js": ["src/**/*.coffee", "!src/**/*.spec.coffee"]
        sass:
            compile:
                files:
                    "build/app.css": "build/app.sass"
        watch:
            options:
                spawn: false
            jade:
                files: ["src/**/*.jade"]
                tasks: ["jade", "copy:debug"]
            coffeescript:
                files: ["src/**/*.coffee"]
                tasks: ["coffee", "copy:debug"]
            sass:
                files: ["src/**/*.sass"]
                tasks: ["concat:sass", "sass", "copy:debug"]
        clean: ["build/", "release/"]
        copy:
            release:
                expand: true
                cwd: "build"
                src: "**/*.html"
                dest: "release/"
            debug:
                expand: true
                cwd: "build"
                src: "**/*.{html,css,js,js.map}"
                dest: "release/"
            static:
                src: "static/**"
                dest: "release/"
        concat:
            sass:
                src: "src/**/*.sass"
                dest: "build/app.sass"
        filerev:
          options:
            algorithm: 'md5'
            length: 8
          release:
            src: 'release/app.min.{css,js}'
        useminPrepare:
          html: 'build/index.html'
          options:
            dest: 'release'
            root: 'build'
            flow:
              steps:
                js: ['uglifyjs']
                css: ['cssmin']
              post: {}
        usemin:
          options:
            dest: 'release'
            root: 'build'
            assetsDirs: 'release'
          html: 'build/index.html'
        connect:
            dev_server:
                options:
                    port: 9001
                    base: 'release'
                    debug: true
                    logger: 'dev'
                    middleware: (connect, options) ->
                        proxy = require('grunt-connect-proxy/lib/utils').proxyRequest
                        history = require('connect-history-api-fallback')
                        [
                            # Support html5mode or the ui-router
                            history()
                            # Include the proxy first
                            proxy
                            # Serve static files.
                            connect.static(options.base[0])
                            # Make empty directories browsable.
                            connect.directory(options.base[0])
                        ]
                proxies:
                    context: '/v1'
                    port: 8081
                    host: 'localhost'
        karma:
          unit:
            configFile: 'karma.conf.coffee'
        coveralls:
          options:
            coverageDir: './coveralls'
            recursive: true

    # Load plugins
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-sass'
    grunt.loadNpmTasks 'grunt-contrib-concat'

    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-filerev'

    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-connect-proxy'

    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-karma-coveralls'

    grunt.loadNpmTasks 'grunt-usemin'

    # Tasks
    grunt.registerTask 'test',[
        'karma'
        'coveralls'
    ]
    grunt.registerTask 'build',[
        'clean',
        'jade',
        'coffee',
        'concat:sass',
        'sass'
        'karma',
    ]
    grunt.registerTask 'default',[
        'build',
        'copy:debug',
        'configureProxies:dev_server',
        'connect',
        'watch',
    ]
    grunt.registerTask 'release',[
        'build',
        'useminPrepare',
        'uglify',
        'cssmin',
        'filerev',
        'usemin',
        'copy:release',
    ]
