Feature: check dcmetro station predictions

    In order to station predictions
    When I run `dcmetro station STATION`
    Then train predictions for STATION should be displayed
    
    Scenario: check gallery predictions
        When I run `dcmetro station gallery`
        Then the stdout should contain:
        """"
        gallery
        """

    Scenario: check predictions from partial name
        When I run `dcmetro station gall` interactively
        And I type "0"
        Then the stdout should contain: 
        """
        ****Multiple stations found****
        """
        Then the stdout should contain: 
        """
        Gallery
        """

    Scenario: check predictions returning more than one station
        When I run `dcmetro station g` interactively
        And I type "5"
        Then the stdout should contain:
        """
        ****Multiple stations found****
        """
        Then the stdout should contain:
        """
        Gallery
        """
