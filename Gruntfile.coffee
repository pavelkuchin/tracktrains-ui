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
                ]
        coffee:
            options:
                join: true
            compile:
                files:
                    "build/app.js": "src/**/*.coffee"
        sass:
            compile:
                files:
                    "build/app.css": "build/app.sass"
        watch:
            options:
                spawn: false
            jade:
                files: ["src/**/*.jade"]
                tasks: ["jade"]
            coffeescript:
                files: ["src/**/*.coffee"]
                tasks: ["coffee"]
            sass:
                files: ["src/**/*.sass"]
                tasks: ["sass"]
        uglify:
            release:
                files:
                    "release/app.min.js": ["build/app.js"]
        clean:
            build: "build"
            release: "release"
        copy:
            release:
                expand: true
                cwd: "build"
                src: "**/*.{html,css}"
                dest: "release/"
        concat:
            sass:
                src: "src/**/*.sass"
                dest: "build/app.sass"

    # Load plugins
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-sass'
    grunt.loadNpmTasks('grunt-contrib-concat');

    grunt.loadNpmTasks 'grunt-contrib-watch'

    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'

    # Tasks
    grunt.registerTask 'build',[
        'clean',
        'jade',
        'coffee',
        'concat:sass',
        'sass'
    ]
    grunt.registerTask 'default',['build', 'watch']
    grunt.registerTask 'release',['build', 'uglify', 'copy']
