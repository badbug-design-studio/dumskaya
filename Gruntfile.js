module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    uglify: {
      build: {
        src: ['js/libs/**.js',
              'js/app.js',
              'js/controllers/**.js',
              'js/views/**.js'
        ],
        dest: 'build/<%= pkg.name %>.min.js'
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Default task(s).
  grunt.registerTask('default', ['uglify']);

// EXAMPLE
//  grunt.registerTask("default",function(){
//      grunt.log.writeln("Hello, "+grunt.config.get('person').name)
//  })
}