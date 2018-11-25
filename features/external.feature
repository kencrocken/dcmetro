@check
Feature: External calls to WMATA api

    When I call WMATA api
    Then the response should be "200"
    And should return "JSON"
    And should contain "the desired information"


    Scenario: Check Alerts
        When I send a GET request for "WMATA Alerts"
        Then the response should be "200"
        Then should return "JSON"
        And should contain "Incidents"

    Scenario: Check Lines
        When I send a GET request for "WMATA Lines"
        Then the response should be "200"
        And should return "JSON"
        And should contain "Lines"

    Scenario: Check Stations on a Line
        When I send a GET request for "WMATA Stations Red"
        Then the response should be "200"
        And should return "JSON"
        And should contain "Stations"

    Scenario: Check Stations arrival/departure times
        When I send a GET request for "WMATA Station Gallery"
        Then the response should be "200"
        And should return "JSON"
        And should contain "Line"
        And should contain "DestinationName"
        And should contain "Min"

    Scenario: Check travel time, distance and fare between two stations
        When I send a GET request for "WMATA Travel Gallery College"
        Then the response should be "200"
        And should return "JSON"
        And should contain "CompositeMiles"
        And should contain "RailFare"
        And should contain "RailTime"

    Scenario: Check nonsense
        When I send a GET request for "WMATA crazy"
        Then should return "false"
