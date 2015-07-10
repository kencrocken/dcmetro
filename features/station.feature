Feature: check dcmetro station predictions

    In order to station predictions
    When I run `dcmetro station STATION`
    Then train predictions for STATION should be displayed
    
    Scenario: check gallery predictions
        When I run `dcmetro station gallery`
        Then the stdout should contain "===== Gallery Pl-Chinatown ====="

    Scenario: check predictions from partial name
        When I run `dcmetro station gall`
        Then the stdout should contain "===== Gallery Pl-Chinatown ====="

    Scenario: check predictions returning more than one station
        When I run `dcmetro station g`
        Then the stdout should contain "****Multiple stations found****"
