var gulp        = require('gulp');
var ngClassify  = require('gulp-ng-classify');
var jade        = require('gulp-jade');
var coffee      = require('gulp-coffee');

gulp.task('html', function() {
  gulp
    .src('./src/**/*.jade')
    .pipe(jade())
    .pipe(gulp.dest('./example/'));
});

gulp.task('scripts', function() {
  gulp
    .src('./src/**/*.coffee')
    .pipe(ngClassify())
    .pipe(coffee({
      bare: false
    }))
    .pipe(gulp.dest('./build/'));
});
