require 'spec_helper'

describe DCMetro::Information do

    before :each do
        @dcmetro = DCMetro::Information.new
        sleep 1
    end

    describe "@dcmetro" do
        it "returns a DCMetro::Information object" do
            expect(@dcmetro).to be_an_instance_of DCMetro::Information
        end
    end

    describe "#alerts" do
        it "returns alert information" do

            # puts @dcmetro.inspect
            expect(@dcmetro).to respond_to :alerts
            alerts = JSON.parse(@dcmetro.alerts)
            # puts @dcmetro.metro_incidents
            expect(@dcmetro.alerts.code).to eq 200
            expect(alerts).to include 'Incidents'
        end
    end

    describe "#lines" do
        it "returns metro lines" do

            # puts @dcmetro.inspect
            expect(@dcmetro).to respond_to :line
            lines = JSON.parse @dcmetro.line
            # puts @dcmetro.metro_lines
            expect(@dcmetro.line.code).to eq 200
            expect(lines).to include 'Lines'
        end
    end

    describe "#lines blue" do
        # subject { DCMetro::Information.new(:lines => "blue" }
        it "returns stations on blue line" do
            # puts @dcmetro.inspect
            expect(@dcmetro).to respond_to(:line).with(1).argument
            stations = JSON.parse @dcmetro.line "blue"
            # puts @dcmetro.metro_lines
            expect(@dcmetro.line("blue").code).to eq 200
            expect(stations).to include 'Stations'
        end
    end

end
