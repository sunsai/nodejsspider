gulp = require('gulp')
minijs = require('gulp-uglify')
minicss = require('gulp-minify-css')
minihtml = require('gulp-minify-html')
browsersync = require('browser-sync')
runsequence = require('run-sequence')
del = require('del')
request = require('superagent')
cheerio = require('cheerio')
mysql = require('./db')
data = []
gulp.task('default', ()->
#  runsequence(['clean'], ['build'], ['server', 'watch'], callback)
#  mysql.query({
#    sql:"INSERT into tcool(href,title,time) VALUES('/articles/jeQnmeq','亚马逊宣布将恢复',CURTIME())",
#    handler:(res)->
#      console.log(res)
#  })
  setInterval(->
    runsequence(['spider'], ['insert'])
  , 10 * 1000)
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
  data = []
  page = Math.floor(Math.random() * 20 + 1)
  url = 'http://www.tuicool.com/ah/0/' + page.toString() + '?lang=1'
  request.get(url).end((err, res)->
    if !err
      $ = cheerio.load(res.text)
      console.log('url:' + url)
      console.log('=================================================')
      $('#list_article .single_fake').each(->
        $tmp = cheerio.load($(this).html())
        $a = $tmp('div.single a').get(0)
        href = $tmp($a).attr('href')
        title = $tmp($a).attr('title')
        $span = $tmp('div.tip.meta-tip span:nth-child(2)').get(0)
        time = $tmp($span).text().trim()
        mysql.query({
          sql: 'INSERT into tcool(href,title,time) VALUES(' + href + ',' + title + ',' + time + '))',
          handler: (res)->
            console.log(res)
        })
#        data.push(item_tmp)
      )
      console.log("^__^^__^此次爬行完毕1^__^^__^")
    else
      console.log('err')
  )
  callback()
)
gulp.task('insert', (callback)->
  console.log("data:" + data.length)
  if data.length > 0
    for item in data
      href = item.href
      title = item.title
      time = item.time
      mysql.query({
        sql: 'INSERT into tcool(href,title,time) VALUES(' + href + ',' + title + ',' + time + '))',
        handler: (res)->
          console.log(res)
      })
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
