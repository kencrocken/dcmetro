When(/^I send a GET request for "([^"]*)"$/) do |path|
    case path
    when "WMATA Alerts"
        @last_response = DCMETRO.alerts
    when "WMATA Lines"
        @last_response = DCMETRO.lines
    when "WMATA Stations Red"
        DCMETRO.line = 'red'
        @last_response = DCMETRO.stations
    when "WMATA Station Gallery"
        @last_response = DCMETRO.station "Gallery"
    when "WMATA Travel Gallery College"
        @last_response = DCMETRO.station "Gallery", "College"
    else
        @last_response = false
    end
end

Then(/^the response should be "([^"]*)"$/) do |status|
    @last_response.code == status.to_i
end

Then(/^should return "([^"]*)"$/) do |arg1|
    valid_json?(@last_response)
end

Then(/^should contain "([^"]*)"$/) do |arg1|
    @last_response[arg1]
end
