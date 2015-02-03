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
                {expand: true, src: ['fonts/**'], dest: 'build/'},
                {expand: true, src: ['img/**'], dest: 'build/'},
                {expand: false, src: ['js/libs/require.js'], dest: 'build/'},
                {expand: false, src: ['js/templates/**'], dest: 'build/'},
                {expand: false, src: ['js/views/**.js'], dest: 'build/'},
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
    concat:{
            css:{
                src: ['css/reset.css','css/animate.css','css/font-awesome.css','css/framework7.css','css/framework7.themes.css','css/mobile.css'],
                dest: 'css/concat.css'
            }
    },
    cssmin: {
        options: {
                keepSpecialComments: 0
        },
        minify: {
            src: 'css/concat.css',
            dest: 'build/css/my-app.css'
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
   },

    clean: {
      css: ["css/concat.css"]
    },

  coffee: {
      coffee_to_js:{
          options:{
            bare: true,
            sourceMap: true
          },
          expand: true,
          flatten: false,
          cwd: "./js",
          src: ["**/*.coffee"],
          dest: '/js/',
          ext: ".js"

}
  }

  });

  // Load the plugin that provides the "uglify" task.
//  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-requirejs');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-regex-replace');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-coffee');


  grunt.registerTask('build', ['requirejs','copy:main','concat:css','cssmin','regex-replace','clean'])
  grunt.registerTask('copyDir', ['copy:copyToDir'])






  // Default task(s).

// EXAMPLE
//  grunt.registerTask("default",function(){
//      grunt.log.writeln("Hello, "+grunt.config.get('person').name)
//  })
}