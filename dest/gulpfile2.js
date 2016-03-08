(function(){var e,t,r,i,n,s,o,u,l,c;i=require("gulp"),o=require("gulp-uglify"),n=require("gulp-minify-css"),s=require("gulp-minify-html"),e=require("browser-sync"),c=require("run-sequence"),u=require("./db"),r=require("del"),l=require("superagent"),t=require("cheerio"),i.task("default",function(e){return console.log(u.data),c(["clean"],["build"],["watch"],e)}),i.task("clean",function(e){return r("./dest/**/*.*",e)}),i.task("miniJS",function(){return i.src("*.js").pipe(o()).pipe(i.dest("./dest/"))}),i.task("miniCSS",function(){return i.src("*.css").pipe(n()).pipe(i.dest("./dest/"))}),i.task("miniHTML",function(){return i.src("*.html").pipe(s()).pipe(i.dest("./dest/"))}),i.task("spider",function(e){var r;return r="http://www.tuicool.com/ah/0/1?lang=1",l.get(r).end(function(e,i){var n;return e?console.log("err"):(n=t.load(i.text),n("#list_article .single_fake div div a").each(function(){return console.log(r),console.log("   title:"+n(this).attr("title")),console.log("   href:"+n(this).attr("href")),console.log("   text:"+n(this).text())}),console.log("==========================================="),console.log("^__^^__^此次爬行完毕1^__^^__^"))}),e()}),i.task("build",function(e){return c(["miniCSS","miniJS","miniHTML"],e)}),i.task("watch",function(){return i.watch(["./*.js","!gulpfile.js"],["spider"])}),i.task("reload",function(e){return console.log("this is reload.........."),c(["spider"],e)}),i.task("reload-browser",function(){return e.reload()}),i.task("server",function(){return e.init({server:{baseDir:"./dest/"},port:8e3})})}).call(this);