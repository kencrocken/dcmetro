require 'thor'
require 'json'
require 'rest-client'

#
# This is the command line interface using Thor

module DCMetro
  module Cli
    class Application < Thor

      desc 'alerts', 'Display DC Metro system wide alerts.'
      def alerts
        #
        # $dcmetro alerts
        # => *** Alert! Alert! ***

        x = DCMetro::Information.new

        alerts = parse_json x.alerts
        display_alerts alerts
      end

      desc 'line COLOR', 'Display metro rail lines, if COLOR, displays rail stations on the COLOR line'
      def line color=nil
        #
        # $dcmetro line
        # => Orange, Blue, Silver, Red, etc ...
        #
        # $dcmetro line Red
        # => Displays the stations on the Red Line

        x = DCMetro::Information.new

        if !color.nil?
          line = parse_json x.line(color)
          line["Stations"].each { |station| puts station['Name']}
        else
          lines = parse_json x.line
          lines["Lines"].each do |line|
            color = get_color(line['LineCode'])

            puts "#{color}#{line['DisplayName']}#{COLOR_OFF}"
          end
        end
      end

      desc "lines", "invokes line method"
      def lines color=nil
        invoke :line
      end

      desc 'station NAME', 'Display metro station train arrival and departure times.'
      method_option :alerts, :aliases => '-a', :type => :boolean,  :description => "Display Metro wide alerts."
      def station(from, to=nil)
        #
        # $dcmetro station Greenbelt
        # => Displays the departure and arrival times at the Greenbelt Station
        #
        # $dcmetro station Greenbelt -a
        # => Displays the alerts, departure and arrival times at the Greenbelt Station
        #

        dc_metro = DCMetro::Information.new

        if options[:alerts]
          alerts = parse_json dc_metro.alerts
          display_alerts alerts
        end

        if to.nil?
          station = parse_json dc_metro.station(from)
          train_time = station['Trains'].empty? ? "Sorry, there is no information for #{from}." : display_trains(station['Trains'])
          puts train_time if !train_time.kind_of?(Array)
          train_time
        else
          travel_info = dc_metro.station(from,to)
          fare_info = parse_json travel_info
          display_travel_info fare_info

        end
      end

      private

      no_commands do

        def get_color line_code
          case line_code
            when "GR"
              GREEN
            when "BL"
              BLUE
            when "OR"
              ORANGE
            when "SV"
              SILVER
            when "YL"
              YELLOW
            else
              RED
          end
        end

        def parse_json response
          puts response
          JSON.parse(response, :quirks_mode => true)
        end

        def display_alerts alerts
          #
          # Formats the display of the alerts

          if alerts['Incidents'].empty?
            puts "*** No alerts reported. ***"
          else
            puts "#{RED}*** ALERT! ALERT! ***#{COLOR_OFF}"
            alerts['Incidents'].each { |incident| puts "#{incident["Description"]}\n\n"}
          end
        end

        def display_trains trains
          #
          # Formats the display of the train arrival and departures

          puts  "===== #{trains[0]['LocationName']} ====="
          trains.each do |prediction|
            puts "Line: #{prediction['Line']} | Towards: #{prediction['DestinationName']} | Arriving: #{prediction['Min']}"
          end
        end

        def display_travel_info information
          information = information['StationToStationInfos'][0]
          railFare = information['RailFare']
          puts "Distance: #{information['CompositeMiles']} Miles\n"
          puts "Estimate Travel Time: #{information['RailTime']} Minutes\n"
          puts "\n*** Fare Information ***\nOff Peak Time:  $#{railFare['OffPeakTime']}\nPeak Time:  $#{railFare['PeakTime']}\nSenior/Disabled:  $#{railFare['SeniorDisabled']}"
        end

      end

    end
  end
end
