#!/usr/bin/env rake
require "bundler/gem_tasks"

desc 'Uninstall snoo, build it, and install it locally'
task :cycle do
  sh 'gem uninstall snoo'
  Rake::Task["install"].execute
end
