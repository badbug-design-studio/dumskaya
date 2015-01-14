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
            include: ['main','text','prod'],
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
                {expand: true, src: ['img/**'], dest: 'build/'},
                {expand: false, src: ['js/libs/**'], dest: 'build/'},
                {expand: false, src: ['js/templates/**'], dest: 'build/'},
                {expand: false, src: ['js/views/**.js'], dest: 'build/'},
                {expand: false, flatten: true, src: ['js/common/baseView.js'], dest: 'build/js/common/baseView.js',filter: 'isFile'},
                {expand: false, flatten: true, src: ['js/common/categoryView.js'], dest: 'build/js/common/categoryView.js',filter: 'isFile'},
                {expand: false, flatten: true, src: ['js/common/tabs.js'], dest: 'build/js/common/tabs.js',filter: 'isFile'},
                {expand: false, flatten: true, src: ['index.html'], dest: 'build/index.html',filter: 'isFile'}
            ]
       },
       copyToDir:{
           files:[
               {expand: true, src: ['**'],cwd: 'build/', dest:"<%= pkg.build %>/www"},
               {expand: true, src: ['**'], cwd: 'res/', dest:"<%= pkg.build %>/res"},
               {expand: false, flatten: true, src: ['config.xml'], dest: '<%= pkg.build %>/',filter: 'isFile'}
           ]
       }
    },
   "regex-replace":{
        dist:{
            src:['build/index.html'],
            actions:[
                {
                    name:'change-main-js-path',
                    search:'<script src="./js/libs/require.js" data-main=".*"></script>',
                    replace:function(match){
//                         '<script src="http://jsconsole.com/remote.js?410831F1-23CB-469B-9DAA-AD1247408B87"></script>' +
                        return  '<script src="cordova.js"></script>'+
                                '<script src="./js/libs/require.js" data-main="'+grunt.config('pkg').name +'.min.js"></script>'
                    }
                }
            ]
        }
    }


  });

  // Load the plugin that provides the "uglify" task.
//  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-regex-replace');
  grunt.registerTask('build', ['requirejs','copy:main','regex-replace'])
  grunt.registerTask('copyDir', ['copy:copyToDir'])






  // Default task(s).

// EXAMPLE
//  grunt.registerTask("default",function(){
//      grunt.log.writeln("Hello, "+grunt.config.get('person').name)
//  })
}