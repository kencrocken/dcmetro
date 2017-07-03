@slow_process
Feature: check dcmetro station predictions
    In order to station predictions
    When I run `dcmetro station STATION`
    Then train predictions for STATION should be displayed

    Scenario: check gallery predictions
        When I run `dcmetro station gallery`
        Then the stdout should contain:
        """"
        Gallery
        """
        And the stderr should not contain anything

    # TO-DO: Refactor tests and code to remove 
    # @announce-stdout
    # @announce-stderr
    # Scenario: check predictions from partial name
    #     When I run `dcmetro station gall` interactively
    #     Then I type "0"
    #     Then the stdout should contain:
    #     """
    #     ****Multiple stations found****
    #     """
    #     Then the stdout should contain:
    #     """
    #     Gallery
    #     """
    #     And the stderr should not contain anything

    # @announce-stdout
    # Scenario: check predictions returning more than one station
    #     When I run `dcmetro station g` interactively
    #     Then I type "5"
    #     Then the stdout should contain:
    #     """
    #     Gallery
    #     """
    #     And the stderr should not contain anything
