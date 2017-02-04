require 'bundler'
require 'bundler/gem_tasks'
require 'cucumber'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'coveralls/rake/task'
RSpec::Core::RakeTask.new
Cucumber::Rake::Task.new
Coveralls::RakeTask.new

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "DCMETRO_KEY=#{ENV['DCMETRO_KEY']} features --format pretty"
end

desc "run rspec"
task :rspec do
  puts "=== Running Rspec ==="
  puts "DCMETRO_KEY=#{ENV['DCMETRO_KEY']} rspec"
  system "DCMETRO_KEY=n2z9aq3redes6k7jekjfzk8q rspec"

end



task :tests => [:spec, :features, 'coveralls:push']


# task :test_with_coveralls => [:spec, :features, 'coveralls:push']

