module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    folders:
      dest: 'build'
      src: 'app'

    coffee:
      main:
        expand: true
        cwd: '<%= folders.src %>/coffee'
        src: ['*.coffee'],
        dest: '<%= folders.dest %>/js'
        ext: '.js'

    compass:
      main:
        options: 
          sassDir: '<%= folders.src %>/styles'
          cssDir: '<%= folders.dest %>/styles'
          environment: 'production'   

    copy:
      main:
        files: [
          {expand: true, src: ['<%= folders.src %>/views/**'], dest: '<%= folders.dest %>/views/'}
          {expand: true, src: ['<%= folders.src %>/lib/**'], dest: '<%= folders.dest %>/lib/'}
          {expand: true, src: ['<%= folders.src %>/img/**'], dest: '<%= folders.dest %>/img/'}
          {expand: true, src: ['<%= folders.src %>/manifest.json'], dest: '<%= folders.dest %>/manifest.json'}
        ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask 'default', ['coffee', 'compass','copy']