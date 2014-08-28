(function() {
  module.exports = function(config) {
    return config.set({
      basePath: '../',
      frameworks: ['jasmine'],
      files: ['bower_components/angular/angular.js', 'bower_components/angular-mocks/angular-mocks.js', 'bower_components/angular-animate/angular-animate.js', 'bower_components/angular-cookies/angular-cookies.js', 'bower_components/angular-resource/angular-resource.js', 'bower_components/angular-route/angular-route.js', 'bower_components/angular-sanitize/angular-sanitize.js', 'bower_components/angular-touch/angular-touch.js', 'app/scripts/**/*.cs', 'test/mock/**/*.cs', 'test/spec/**/*.cs'],
      exclude: [],
      port: 8080,
      logLevel: config.LOG_INFO,
      browsers: ['PhantomJS'],
      plugins: ['karma-phantomjs-launcher', 'karma-jasmine', 'karma-coffee-preprocessor'],
      autoWatch: true,
      singleRun: false,
      colors: true,
      preprocessors: {
        '**/*.coffee': ['coffee']
      }
    });
  };

}).call(this);

/*
//@ sourceMappingURL=karma.conf.js.map
*/