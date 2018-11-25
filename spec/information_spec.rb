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
            expect(@dcmetro).to respond_to :lines
            lines = JSON.parse @dcmetro.lines
            # puts @dcmetro.metro_lines
            expect(@dcmetro.lines.code).to eq 200
            expect(lines).to have_key("Lines")
        end
    end

    describe "#stations" do
        it "returns stations per class attr `line` value" do
            expect(@dcmetro).to respond_to(:stations)
            @dcmetro.line = 'blue'
            stations = JSON.parse @dcmetro.stations
            expect(stations).to have_key 'Stations'
        end

        it "returns error if class attr `line` has no value" do
            begin
                stations = JSON.parse @dcmetro.stations
                expect(stations).to raise_error
            rescue Exception => ex
                puts ex.inspect
            #     expect(ex).to raise_error
            end
        end
    end

    # describe "#lines red" do
    #     # subject { DCMetro::Information.new(:lines => "blue" }
    #     it "returns stations on red line" do
    #         # puts @dcmetro.inspect
    #         expect(@dcmetro).to respond_to(:line).with(1).argument
    #         stations = JSON.parse @dcmetro.line "red"
    #         # puts @dcmetro.metro_lines
    #         expect(@dcmetro.line("red").code).to eq 200
    #         expect(stations).to include 'Stations'
    #     end
    # end

    # describe "#lines orange" do
    #     # subject { DCMetro::Information.new(:lines => "blue" }
    #     it "returns stations on orange line" do
    #         # puts @dcmetro.inspect
    #         expect(@dcmetro).to respond_to(:line).with(1).argument
    #         stations = JSON.parse @dcmetro.line "orange"
    #         # puts @dcmetro.metro_lines
    #         expect(@dcmetro.line("orange").code).to eq 200
    #         expect(stations).to include 'Stations'
    #     end
    # end

    # describe "#lines green" do
    #     # subject { DCMetro::Information.new(:lines => "blue" }
    #     it "returns stations on green line" do
    #         # puts @dcmetro.inspect
    #         expect(@dcmetro).to respond_to(:line).with(1).argument
    #         stations = JSON.parse @dcmetro.line "green"
    #         # puts @dcmetro.metro_lines
    #         expect(@dcmetro.line("green").code).to eq 200
    #         expect(stations).to include 'Stations'
    #     end
    # end

    # describe "#lines yellow" do
    #     # subject { DCMetro::Information.new(:lines => "blue" }
    #     it "returns stations on yellow line" do
    #         # puts @dcmetro.inspect
    #         expect(@dcmetro).to respond_to(:line).with(1).argument
    #         stations = JSON.parse @dcmetro.line "yellow"
    #         # puts @dcmetro.metro_lines
    #         expect(stations.code).to eq 200
    #         expect(stations).to include 'Stations'
    #     end
    # end

    # describe "#lines silver" do
    #     # subject { DCMetro::Information.new(:lines => "blue" }
    #     it "returns stations on silver line" do
    #         # puts @dcmetro.inspect
    #         expect(@dcmetro).to respond_to(:line).with(1).argument
    #         stations = JSON.parse @dcmetro.line "silver"
    #         # puts @dcmetro.metro_lines
    #         expect(@dcmetro.line("silver").code).to eq 200
    #         expect(stations).to include 'Stations'
    #     end
    # end

    describe "#station farragut" do
        it "returns multiple stations" do
            expect(@dcmetro).to respond_to(:station).with(1).argument
            station = @dcmetro.station "farragut"
            # puts station
            # print "0"
            # echo_task = capture(:stdout) { DCMetro::Information.new(['station','farragut']) }
            expect(station).to include 'Multiple stations'
        end
    end
end
