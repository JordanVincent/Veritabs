module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    folders:
      dest: 'build'
      src: 'app'

    watch:
      main:
        files: ['<%= folders.src %>*/**']
        tasks: ['build']

    coffee:
      main:
        expand: true
        cwd: '<%= folders.src %>/coffee'
        src: ['**/*.coffee'],
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
          {expand: true, cwd: '<%= folders.src %>/views/', src: ['**'], dest: '<%= folders.dest %>/views/'}
          {expand: true, cwd: '<%= folders.src %>/components/', src: ['**'], dest: '<%= folders.dest %>/components/'}
          {expand: true, cwd: '<%= folders.src %>/lib/',   src: ['**'], dest: '<%= folders.dest %>/lib/'}
          {expand: true, cwd:'<%= folders.src %>/img/',    src: ['**'], dest: '<%= folders.dest %>/img/'}
          {expand: true, cwd: '<%= folders.src %>/',       src: ['manifest.json'], dest: '<%= folders.dest %>/'}
        ]

    clean: 
      main: ['<%= folders.dest %>/**']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'build', ['clean','coffee', 'compass','copy']