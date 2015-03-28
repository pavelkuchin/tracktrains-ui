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
                tasks: ["jade", "copy:release"]
            coffeescript:
                files: ["src/**/*.coffee"]
                tasks: ["coffee", "copy:release"]
            sass:
                files: ["src/**/*.sass"]
                tasks: ["concat:sass", "sass", "copy:release"]
        uglify:
            release:
                files:
                    "release/app.min.js": ["build/app.js"]
        clean: ["build/", "release/"]
        copy:
            release:
                expand: true
                cwd: "build"
                src: "**/*.{html,css,js,js.map}"
                dest: "release/"
            static:
                src: "static/**"
                dest: "release/"
            components:
                src: "components/**"
                dest: "release/"
        concat:
            sass:
                src: "src/**/*.sass"
                dest: "build/app.sass"
        connect:
            dev_server:
                options:
                    port: 9001
                    base: 'release'
                    debug: true
                    logger: 'dev'
                    middleware: (connect, options) ->
                        proxy = require('grunt-connect-proxy/lib/utils').proxyRequest
                        [
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

    # Load plugins
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-sass'
    grunt.loadNpmTasks 'grunt-contrib-concat'

    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'

    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-connect-proxy'

    grunt.loadNpmTasks 'grunt-karma'

    # Tasks
    grunt.registerTask 'build',[
        'clean',
        'jade',
        'coffee',
        'karma',
        'concat:sass',
        'sass'
    ]
    grunt.registerTask 'default',[
        'build',
        'copy:release',
        'copy:static'
        'copy:components'
        'configureProxies:dev_server',
        'connect',
        'watch',
    ]
    grunt.registerTask 'release',[
        'build',
        'uglify',
        'copy:release',
        'copy:static'
    ]
