module.exports = (config) ->
    config.set
        # base path, that will be used to resolve files and exclude
        basePath: './'

        plugins: [
          'karma-phantomjs-launcher'
          'karma-jasmine'
          'karma-coverage'
        ]

        # frameworks to use
        frameworks: ['jasmine']

        # list of files / patterns to load in the browser
        files: [
            'components/angular/angular.js'
            'components/angular-ui-router/release/angular-ui-router.js'
            'components/angular-mocks/angular-mocks.js'
            'components/angular-bootstrap/ui-bootstrap-tpls.js'
            'components/angular-loading-bar/src/loading-bar.js'
            'components/lodash/lodash.js'
            'src/**/*.coffee'
        ]

        # list of files to exclude
        exclude: [
        ]

        # test results reporter to use
        reporters: ['progress', 'coverage']

        preprocessors:
          'src/**/*.coffee': ['coverage']

        coverageReporter: {
          type : 'lcovonly',
          dir : 'coveralls/'
        }

        # web server port
        port: 9876

        # enable / disable colors in the output (reporters and logs)
        colors: true

        # level of logging
        logLevel: config.LOG_INFO

        # enable / disable watching file and executing tests whenever any file changes
        autoWatch: false

        # Start these browsers
        browsers: ['PhantomJS']

        # If browser does not capture in given timeout [ms], kill it
        captureTimeout: 60000

        # Continuous Integration mode
        # if true, it capture browsers, run tests and exit
        singleRun: true
