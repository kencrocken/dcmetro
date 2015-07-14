When(/^I send a GET request for "([^"]*)"$/) do |path|
    case path
    when "WMATA Alerts"
        # @last_response = RestClient.get "#{BASE_URL}/Incidents.svc/json/Incidents", :params => {
        #     "api_key" => DCMETRO_KEY,
        #     "subscription-key" => DCMETRO_KEY
        # }
        @last_response = X.alerts
    when "WMATA Lines"
        @last_response = RestClient.get "#{BASE_URL}/Rail.svc/json/JLines", :params => {
            "api_key" => DCMETRO_KEY,
            "subscription-key" => DCMETRO_KEY
        }
    when "WMATA Lines Red"
        @last_response = RestClient.get "#{BASE_URL}/Rail.svc/json/JStations", :params => {
            "LineCode" => "red",
            "api_key" => DCMETRO_KEY,
            "subscription-key" => DCMETRO_KEY
        }
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