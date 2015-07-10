Feature: check dcmetro lines

    In order to check lines
    When I run `dcmetro lines`
    Then metro lines should be displayed

    Scenario: check lines
        When I run `dcmetro line`
        Then the stdout should contain "Green\nBlue\nSilver\nRed\nOrange\nYellow"

    Scenario: check lines
        When I run `dcmetro lines`
        Then the stdout should contain "Green\nBlue\nSilver\nRed\nOrange\nYellow"

    Scenario: check red line for Gallery Place
        When I run `dcmetro line red`
        Then the stdout should contain "Gallery"

    Scenario: check green line for Gallery Place
        When I run `dcmetro line green`
        Then the stdout should contain "Gallery"