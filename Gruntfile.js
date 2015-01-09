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
    },
    copy:{
       main:{
            files:[
                {expand: true, src: ['css/**'], dest: 'build/'},
                {expand: true, src: ['fonts/**'], dest: 'build/'},
            ]
       }
    }

  });

  // Load the plugin that provides the "uglify" task.
//  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-requirejs');

  grunt.loadNpmTasks('grunt-contrib-copy');

  // Default task(s).
  grunt.registerTask('build', ['requirejs','copy']);

// EXAMPLE
//  grunt.registerTask("default",function(){
//      grunt.log.writeln("Hello, "+grunt.config.get('person').name)
//  })
}