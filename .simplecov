require 'codecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start do
   add_filter 'features/'
   add_filter 'spec/'
end
