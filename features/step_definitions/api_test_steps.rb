When(/^I send a GET request for "([^"]*)"$/) do |path|
    case path
    when "WMATA Alerts"
        @last_response = X.alerts
    when "WMATA Lines"
        @last_response = X.line
    when "WMATA Lines Red"
        @last_response = X.line "Red"
    else 
        false
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