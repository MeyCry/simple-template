gulp = require("gulp")

# css
compass = require("gulp-compass")
autoprefixer = require("gulp-autoprefixer")
minifyCss = require('gulp-minify-css')

# js
concat = require("gulp-concat")
uglify = require("gulp-uglify")
sourcemaps = require('gulp-sourcemaps');

# img
imagemin = require('gulp-imagemin')

# svg
filter = require('gulp-filter')
svgSprite = require("gulp-svg-sprites")
svg2png   = require('gulp-svg2png')

# css docs
styledown = require("gulp-styledown")

paths = {
  cssSource: "source/css"
  cssDist: "public/css"
}


#gulp.task "compass", () ->
#  gulp.src("#{paths.cssSource}/**/*.scss")
#  .pipe compass
#    config_file: "./config.rb"
#    css: paths.cssSource
#    sass: paths.cssSource
#
#  .pipe(gulp.dest(paths.cssSource))
#
#
#gulp.task "autoprefixer", ["compass"], ->
#  gulp.src("#{paths.cssSource}/*.css")
#  .pipe(autoprefixer({
#      browsers: ["last 6 version", "> 1%", "ie 8", "Opera 12.1"]
#    }))
#  .pipe(gulp.dest(paths.cssSource))
#
#
#gulp.task "csso", ["autoprefixer"], ->
#  gulp.src("#{paths.cssSource}/*.css")
#  .pipe(csso())
#  .pipe(gulp.dest(paths.cssDist))


gulp.task "css", ->
  gulp.src("#{paths.cssSource}/**/*.scss")
  .pipe compass
    config_file: "./config.rb"
    css: paths.cssSource
    sass: paths.cssSource
  .pipe autoprefixer
      browsers: ["last 6 version", "> 1%", "ie 8", "Opera 12.1"]
  .pipe minifyCss({compatibility: 'ie8'})
  .pipe(gulp.dest(paths.cssDist))


gulp.task "lib", ->
  gulp.src([
    "./source/js/lib/jquery-2.1.4.js"
  ])
  .pipe(concat("lib.js", {sourceRoot: yes}))
  .pipe(uglify())
  .pipe(gulp.dest("./public/js"))


gulp.task "js", ->
  gulp.src([
    "./source/js/scr/main.js"
  ])
  .pipe(sourcemaps.init())
  .pipe(concat("project.js"))
  .pipe(uglify())
  .pipe(sourcemaps.write())
  .pipe(gulp.dest("./public/js"))


gulp.task "img", ->
  gulp.src('source/image/**/*')
  .pipe(imagemin({
    progressive: true,
#    svgoPlugins: [
#      {
#        removeViewBox: no
#      }
#    ]
  }))
  .pipe(gulp.dest('public/image'));


gulp.task 'sprites', -> # hand run
  gulp.src('source/image/svg/*.svg')
  .pipe(svgSprite({
        cssFile: "css/sprite.css"
        padding: 1
      }))
  .pipe(gulp.dest("source/image/svg/sprite"))
  .pipe(filter("**/*.svg"))
  .pipe(svg2png())
  .pipe(gulp.dest("source/image/svg/sprite"))


gulp.task "cssdoc", ->
  gulp.src 'source/css/**/*.scss'
  .pipe styledown
    config: './cssDOC/styledown.md'
    filename: 'zeo-css-doc.html'
  .pipe gulp.dest './cssDOC/'


gulp.task "watch", ->
  gulp.watch("source/css/**/*.scss", ["css"])
  gulp.watch("source/js/scr/**/*.js", ["js"])
  gulp.watch("source/js/lib/**/*.js", ["lib"])
  gulp.watch("source/image/**/*", ["img"])


gulp.task("default", ["css", "js", "lib", "img"])
gulp.task("w", ["css", "js", "watch"])

