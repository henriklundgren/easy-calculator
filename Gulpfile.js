var gulp        = require('gulp');
var pkg         = require('./package.json');
var fs          = require('fs');
var ngClassify  = require('gulp-ng-classify');
var jade        = require('gulp-jade');
var coffee      = require('gulp-coffee');
var tmplCache   = require('gulp-angular-templatecache');
var less        = require('gulp-less');
var header      = require('gulp-header');
var footer      = require('gulp-footer');
var concat      = require('gulp-concat');
var gulpif      = require('gulp-if');

gulp.task('css', function() {
  gulp
    .src('./src/*.less')
    .pipe(less())
    .pipe(gulp.dest('./build/'));
});

gulp.task('html', function() {
  gulp
    .src('./src/index.jade')
    .pipe(jade())
    .pipe(gulp.dest('./'));
});

gulp.task('templatecache', function() {
  gulp
    .src('./src/*.tmpl.jade')
    .pipe(jade())
    .pipe(tmplCache({
      //filename: ''
      module: 'app'
    }))
    .pipe(gulp.dest('./tmp/'));
});

gulp.task('scripts', function() {
  gulp
    .src(['./src/**/*.coffee', './tmp/**/*.js'])
    .pipe(gulpif(/[.]coffee$/, ngClassify()))
    .pipe(gulpif(/[.]coffee$/, coffee({
      bare: false
    })))
    .pipe(concat(pkg.name + '.js'))
    .pipe(header(fs.readFileSync('src/main.prefix.js', 'utf-8')))
    .pipe(footer(fs.readFileSync('src/main.suffix.js', 'utf-8')))
    .pipe(gulp.dest('./build/'));
});

gulp.task('concat', function() {
  gulp
    .src(['./gulp'])
});
