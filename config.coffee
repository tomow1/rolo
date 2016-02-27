module.exports =
    scripts:
        source: './src/coffee/main.coffee'
        extensions: ['.coffee']
        transforms: ['coffee-reactify', 'envify']
        destination: './dist/static/js/'
        filename: 'bundle.js'
    templates:
        source: './src/jade/*.jade'
        watch: './src/jade/*.jade'
        destination: './dist/'
    styles:
        source: './src/stylus/style.styl'
        watch: './src/stylus/*.styl'
        destination: './dist/static/css/'
    fonts:
        source: './bower_components/Font-Awesome-Stylus/fonts/*.*'
        destination: './dist/static/fonts'
    assets:
        source: [
            './src/favicon.ico'
            './src/apple-touch-icon.png'
            './src/humans.txt'
            './src/robots.txt'
            './src/assets/**/*.*'
        ]
        watch: [
            './src/favicon.ico'
            './src/apple-touch-icon.png'
            './src/humans.txt'
            './src/robots.txt'
            './src/assets/**/*.*'
        ]
        destination: './dist/static/'
    deploy:
        source: [
            './dist/static/**/*.*'
            '!./dist/**/*.html'
        ]
        static: './app/static/'
        templates: './app/templates/'
