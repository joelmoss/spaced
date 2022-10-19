# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

task :test do
  sh "bundle exec sus"
end

RuboCop::RakeTask.new

task default: %i[test rubocop]
