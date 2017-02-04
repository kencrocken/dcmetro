@wip
Feature: STDOUT of commands which were executed

    Background:
        Given an executable named "bin/dcmetro" with:
        """bash
        #!/usr/bin/env ruby
        require 'dcmetro'
        DCMetro::Cli::Application.start(ARGV)
        """

    Scenario: Match output in stdout
        When I run `dcmetro`
        Then the stdout should contain "Commands:"
        Then the stderr should not contain "Commands:"