Feature: check dcmetro lines

    In order to check lines
    When I run `bundle exec dcmetro lines`
    Then metro lines should be displayed

    # check line - singular
    Scenario: check lines
        When I run `bundle exec dcmetro line`
        Then the stdout should contain "Blue\nGreen\nOrange\nRed\nSilver\nYellow"

    # check lines - plural
    Scenario: check lines
        When I run `bundle exec dcmetro lines`
        Then the stdout should contain "Blue\nGreen\nOrange\nRed\nSilver\nYellow"

    Scenario: check blue line stations
        When I run `bundle exec dcmetro line blue`
        Then the stdout should contain "Metro Center\nMcPherson Square\nFarragut West\nFoggy Bottom-GWU\nRosslyn\nArlington Cemetery\nPentagon\nPentagon City\nCrystal City\nRonald Reagan Washington National Airport\nBraddock Road\nKing St-Old Town\nFederal Triangle\nSmithsonian\nL'Enfant Plaza\nFederal Center SW\nCapitol South\nEastern Market\nPotomac Ave\nStadium-Armory\nBenning Road\nCapitol Heights\nAddison Road-Seat Pleasant\nMorgan Boulevard\nLargo Town Center\nVan Dorn Street\nFranconia-Springfield\n"

    Scenario: check green line stations
        When I run `bundle exec dcmetro line green`
        Then the stdout should contain "Mt Vernon Sq 7th St-Convention Center\nShaw-Howard U\nU Street/African-Amer Civil War Memorial/Cardozo\nColumbia Heights\nGeorgia Ave-Petworth\nFort Totten\nWest Hyattsville\nPrince George's Plaza\nCollege Park-U of MD\nGreenbelt\nGallery Pl-Chinatown\nArchives-Navy Memorial-Penn Quarter\nL'Enfant Plaza\nWaterfront\nNavy Yard-Ballpark\nAnacostia\nCongress Heights\nSouthern Avenue\nNaylor Road\nSuitland\nBranch Ave\n"

    Scenario: check red line stations
        When I run `bundle exec dcmetro line red`
        Then the stdout should contain "Metro Center\nFarragut North\nDupont Circle\nWoodley Park-Zoo/Adams Morgan\nCleveland Park\nVan Ness-UDC\nTenleytown-AU\nFriendship Heights\nBethesda\nMedical Center\nGrosvenor-Strathmore\nWhite Flint\nTwinbrook\nRockville\nShady Grove\nGallery Pl-Chinatown\nJudiciary Square\nUnion Station\nRhode Island Ave-Brentwood\nBrookland-CUA\nFort Totten\nTakoma\nSilver Spring\nForest Glen\nWheaton\nGlenmont\nNoMa-Gallaudet U"

    Scenario: Show help
        Given I run `bundle exec dcmetro`
        Then the output should contain:
        """
        Commands:
        """