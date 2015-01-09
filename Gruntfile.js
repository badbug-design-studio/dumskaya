module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    requirejs: {
      compile: {
        options:{
            baseUrl: './js',
            mainConfigFile:'js/main.js',
            name: 'bootstrap',
            out:'build/<%= pkg.name %>.min.js',
            include: ['main','prod','./../cordova'],
            preserveLicenseComments: false,
            "optimize": "uglify2"

        }
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
//  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-requirejs');

  // Default task(s).
  grunt.registerTask('default', ['requirejs']);

// EXAMPLE
//  grunt.registerTask("default",function(){
//      grunt.log.writeln("Hello, "+grunt.config.get('person').name)
//  })
}