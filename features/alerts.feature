Feature: check dcmetro alerts

  In order to check alerts
  When I run `dcmetro alerts` 
  Then alerts should be display

  Scenario: check alerts
    When I run `dcmetro alerts`
    Then the stdout should contain "***"
