const gulp = require('gulp');
const gulpIf = require('gulp-if');
const gulpRev = require('gulp-rev');
const gulpRevReplace = require('gulp-rev-replace');
const gulpUglify = require('gulp-uglify');
const gulpUniqueFiles = require('gulp-unique-files');
const gulpUseRef = require('gulp-useref');
const gulpCleanCSS = require('gulp-clean-css');

gulp.task('default', () => {
  const assets = gulpUseRef.assets({
    searchPath: 'public'
  });

  return gulp.src('public/**/*.html')
    .pipe(assets)
    .pipe(gulpUniqueFiles())
    .pipe(gulpIf('*.css', gulpCleanCSS()))
    .pipe(gulpIf('*.js', gulpUglify()))
    .pipe(gulpRev())
    .pipe(assets.restore())
    .pipe(gulpUseRef())
    .pipe(gulpRevReplace({
      prefix: '/'
    }))
    .pipe(gulp.dest('public'));
});
