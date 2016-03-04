gulp = require('gulp')
minijs = require('gulp-uglify')
minicss = require('gulp-minify-css')
minihtml = require('gulp-minify-html')
browsersync = require('browser-sync')
runsequence = require('run-sequence')
del = require('del')
request = require('superagent')
cheerio = require('cheerio')
gulp.task('default', (callback)->
#  runsequence(['clean'], ['build'], ['server', 'watch'], callback)
  runsequence(['clean'], ['build'], ['watch'], callback)
)
gulp.task('clean', (callback)->
  del('./dest/**/*.*', callback)
)
gulp.task('miniJS', ->
  gulp.src('*.js')
  .pipe(minijs())
  .pipe(gulp.dest('./dest/'))
)
gulp.task('miniCSS', ->
  gulp.src('*.css')
  .pipe(minicss())
  .pipe(gulp.dest('./dest/'))
)
gulp.task('miniHTML', ->
  gulp.src('*.html')
  .pipe(minihtml())
  .pipe(gulp.dest('./dest/'))
)
gulp.task('spider', (callback)->
  url = 'http://www.tuicool.com/ah/0/1?lang=1'
  request.get(url).end((err, res)->
    if !err
      $ = cheerio.load(res.text)
      #    console.log($('.index-item div a'))
      $('#list_article .single_fake div div a').each(->
        console.log(url)
        console.log("   title:" + $(this).attr('title'))
        console.log("   href:" + $(this).attr('href'))
        console.log("   text:" + $(this).text())
        #        console.log($(this).attr('title') + ':http://www.tuicool.com/' + $(this).attr('href'))
        console.log("===========================================")
        console.log("^__^^__^此次爬行完毕^__^^__^")
      )
    else
      console.log('err')
  )
  callback()
)
gulp.task('build', (callback)->
  runsequence(['miniCSS', 'miniJS', 'miniHTML'], callback)
)
gulp.task('watch', ->
#  gulp.watch(['./*.js', '!gulpfile.js'], ['reload'])
  gulp.watch(['./*.js', '!gulpfile.js'], ['spider'])
)
gulp.task('reload', (callback)->
  console.log('this is reload..........');
  #  runsequence(['build','reload-browser'],callback)
  runsequence(['spider'], callback)
)
gulp.task('reload-browser', ->
  browsersync.reload()
)
gulp.task('server', ->
  browsersync.init({
    server: {
      'baseDir': './dest/'
    }
    port: 8000
  })
)
