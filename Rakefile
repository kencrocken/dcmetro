require 'bundler'
require 'bundler/gem_tasks'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "DCMETRO_KEY=#{ENV['DCMETRO_KEY']} features --format pretty"
end


