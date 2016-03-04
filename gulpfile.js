// Generated by CoffeeScript 1.10.0
(function() {
  var browsersync, cheerio, del, gulp, minicss, minihtml, minijs, request, runsequence;

  gulp = require('gulp');

  minijs = require('gulp-uglify');

  minicss = require('gulp-minify-css');

  minihtml = require('gulp-minify-html');

  browsersync = require('browser-sync');

  runsequence = require('run-sequence');

  del = require('del');

  request = require('superagent');

  cheerio = require('cheerio');

  gulp.task('default', function(callback) {
    return runsequence(['clean'], ['build'], ['watch'], callback);
  });

  gulp.task('clean', function(callback) {
    return del('./dest/**/*.*', callback);
  });

  gulp.task('miniJS', function() {
    return gulp.src('*.js').pipe(minijs()).pipe(gulp.dest('./dest/'));
  });

  gulp.task('miniCSS', function() {
    return gulp.src('*.css').pipe(minicss()).pipe(gulp.dest('./dest/'));
  });

  gulp.task('miniHTML', function() {
    return gulp.src('*.html').pipe(minihtml()).pipe(gulp.dest('./dest/'));
  });

  gulp.task('spider', function(callback) {
    var url;
    url = 'http://www.tuicool.com/ah/0/1?lang=1';
    request.get(url).end(function(err, res) {
      var $;
      if (!err) {
        $ = cheerio.load(res.text);
        return $('#list_article .single_fake div div a').each(function() {
          console.log(url);
          console.log("   title:" + $(this).attr('title'));
          console.log("   href:" + $(this).attr('href'));
          console.log("   text:" + $(this).text());
          console.log("===========================================");
          return console.log("^__^^__^此次爬行完毕^__^^__^");
        });
      } else {
        return console.log('err');
      }
    });
    return callback();
  });

  gulp.task('build', function(callback) {
    return runsequence(['miniCSS', 'miniJS', 'miniHTML'], callback);
  });

  gulp.task('watch', function() {
    return gulp.watch(['./*.js', '!gulpfile.js'], ['spider']);
  });

  gulp.task('reload', function(callback) {
    console.log('this is reload..........');
    return runsequence(['spider'], callback);
  });

  gulp.task('reload-browser', function() {
    return browsersync.reload();
  });

  gulp.task('server', function() {
    return browsersync.init({
      server: {
        'baseDir': './dest/'
      },
      port: 8000
    });
  });

}).call(this);

//# sourceMappingURL=gulpfile.js.map
