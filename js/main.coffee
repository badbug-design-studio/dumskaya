require.config({
    urlArgs : 'antichache'
# alias libraries paths
    paths:
        'domReady': './libs/domReady'
        'angular': './libs/angular.min'
        'ionic': './libs/ionic.min'
        'angularIonic': './libs/ionic-angular'

        'uiRouter':"./libs/angular-ui-router"
        'angularSanitize' : './libs/angular-sanitize',
        'angularAnimate' : './libs/angular-animate.min'
        'routes':""
#        'ionic-bundle':"./libs/ionic.bundle.js"
#        'touch':"./libs/angular-touch.min.js"
#        'resourse':"./libs/angular-resource.min.js"
    ,

#     angular does not support AMD out of the box, put it in a shim
    shim:
        'angular':
            exports: 'angular',

        'uiRouter':
            deps:['angular']


        'angularAnimate' :
             deps : ['angular']

        'angularSanitize' :
             deps : ['angular']

        'angularIonic' :
             deps : [
                 'angularAnimate',
                 'angularSanitize',
                 'uiRouter'
             ]

#    kick start application
    deps: ['./bootstrap']
});