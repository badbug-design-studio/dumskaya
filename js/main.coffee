require.config({
    urlArgs : 'antichache'
# alias libraries paths
    paths:
        'domReady': './libs/domReady'
        'angular': './libs/angular.min'
        'ionic': './libs/ionic.min'
        'angularIonic': './libs/ionic-angular'
        'app':'./common/app'
        'uiRouter':"./libs/angular-ui-router"
        'angularSanitize' : './libs/angular-sanitize.min',
        'angularAnimate' : './libs/angular-animate.min'
        'routes':""
#        'touch':"./libs/angular-touch.min.js"
        'angularResourse':"./libs/angular-resource.min"

#     angular does not support AMD out of the box, put it in a shim
    shim:
        'angular':
            exports: 'angular',

        'uiRouter':
            deps:['angular']

        'angularResourse':
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