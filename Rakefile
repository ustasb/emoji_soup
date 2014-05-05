desc 'Watch and compile CoffeeScript files'
task :coffee_watch do
  system 'coffee -cwj dist/application.js src/*.coffee'
end

desc 'Watch and compile Sass files'
task :sass_watch do
    system 'sass --watch css:dist'
end

desc 'Run all the tasks'
task :all do
  threads = []
  threads << Thread.new { Rake::Task['coffee_watch'].invoke }
  threads << Thread.new { Rake::Task['sass_watch'].invoke }
  threads.each(&:join)
end

task :default => [:all]
