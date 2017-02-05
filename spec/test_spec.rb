require 'spec_helper'

describe DCMetro::Cli do

    describe "#dcmetro" do
        it "should show commands" do
            output = `bundle exec bin/dcmetro`.chomp
            expect(output).to include "Commands:"
        end
    end

    describe "#dcmetro alerts" do
        it "should echo alerts" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['alert']) }
            expect(echo_task).to include "***"
        end
    end

    describe "#dcmetro lines" do
        it "should echo metro lines" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['lines']) }
            expect(echo_task).to eq "\e[0;94mBlue\e[0m\n\e[0;32mGreen\e[0m\n\e[38;5;208mOrange\e[0m\n\e[0;31mRed\e[0m\n\e[0;90mSilver\e[0m\n\e[0;93mYellow\e[0m\n"
        end
    end

    describe "#dcmetro line" do
        it "should echo metro line" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['line']) }
            expect(echo_task).to eq "\e[0;94mBlue\e[0m\n\e[0;32mGreen\e[0m\n\e[38;5;208mOrange\e[0m\n\e[0;31mRed\e[0m\n\e[0;90mSilver\e[0m\n\e[0;93mYellow\e[0m\n"
        end
    end

    describe "#dcmetro lines red" do
        it "should echo metro stations on the red line" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['lines', 'red']) }
            expect(echo_task).to include "Metro Center"
            expect(echo_task).to include "Farragut North"
            expect(echo_task).to include "Dupont Circle"

        end
    end


    describe "#dcmetro station gallery" do
        it "should echo predictions for Gallery Place" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['station','gallery']) }
            expect(echo_task).to include "Gallery"
        end
    end

    describe "#dcmetro station gallery -a" do
        it "should echo predictions for Gallery Place with alerts" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['station','gallery','-a']) }
            expect(echo_task).to include "***"
            expect(echo_task).to include "Gallery"
        end
    end

    describe "#dcmetro station college gallery" do
        it "should echo fare information from college park to gallery place" do
            echo_task = capture(:stdout) { DCMetro::Cli::Application.start(['station','college','gallery']) }
            expect(echo_task).to include "Distance"
            expect(echo_task).to include "Travel Time"
            expect(echo_task).to include "*** Fare Information ***"
            expect(echo_task).to include "Off Peak Time"
            expect(echo_task).to include "Peak Time"
            expect(echo_task).to include "Senior/Disabled"
        end
    end
end