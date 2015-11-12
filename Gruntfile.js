'use strict';

module.exports = function (grunt) {

  var path = require('path');
  var jiscBuild = require('jisc_build');

  require('time-grunt')(grunt);

  require('load-grunt-config')(grunt, {
    configPath: path.join(process.cwd(), 'grunt'),
    init: true,
    data: {},
    loadGruntTasks: true
  });

  grunt.registerTask('build', [
      'clean:dist',
      'coffee',
      'concat',
      'ngAnnotate'
  ]);

  grunt.registerTask('build_lib',['build']);

  grunt.registerTask('default', [
      'test',
      'build'
  ]);
};
