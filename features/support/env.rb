require 'simplecov'
require 'coveralls'
Coveralls.wear!
# require 'simplecov'
# SimpleCov.start

# require 'codecov'
# SimpleCov.formatter = SimpleCov::Formatter::Codecov
require 'aruba/cucumber'
require 'json'
require 'rest-client'
require 'dcmetro'

DCMetro::Cli::Application::COLOR_OFF="\033[0m"       # Text Reset

# Line Colors
DCMetro::Cli::Application::RED="\033[0;31m"          # Red
DCMetro::Cli::Application::GREEN="\033[0;32m"        # Green
DCMetro::Cli::Application::ORANGE="\033[38;5;208m"   # Orange
DCMetro::Cli::Application::SILVER="\033[0;90m"       # IBlack
DCMetro::Cli::Application::YELLOW="\033[0;93m"       # IYellow
DCMetro::Cli::Application::BLUE="\033[0;94m"         # IBlue

DCMETRO_KEY=ENV['DCMETRO_KEY']
API_KEY = DCMETRO_KEY
BASE_URL="http://api.wmata.com"

DCMETRO = DCMetro::Information.new

Before ("@check ") do
    def valid_json?(json)
        begin
            JSON.parse(json)
            true
        rescue
            false
        end
    end
end