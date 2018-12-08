require 'thor'
require 'json'
require 'rest-client'

module DCMetro
  #
  # Command Line Interface
  module Cli
    #
    # Thor App
    class Application < Thor
      desc 'alerts', 'Display DC Metro system wide alerts.'
      long_desc %{
        `dcmetro alerts` will display the current WMATA system wide alerts.
        If there are no current WMATA alerts, a message is displayed that no alerts have been found.
        \>$ dcmetro alerts
        \> *** ALERT! ALERT ***
        ...
      }
      def alerts
        dcmetro = DCMetro::Information.new
        alerts = parse_json dcmetro.alerts
        display_alerts alerts
      end

      desc 'lines', 'Display the metro rail lines'
      long_desc %{
        `dcmetro lines` will display a list of the current rails that make up the WMATA metro.
        $ dcmetro lines
        # The Metro rail system currently consists of ...

        Adding `-a` the metro system alerts will also be displayed.
        \>$ dcmetro lines -a
        \> *** ALERT! ALERT ***
        ...
      }
      method_option :alerts, aliases: '-a', type: :boolean, description: 'Display Metro wide alerts.'
      def lines
        dcmetro = DCMetro::Information.new
        if options[:alerts]
          self.alerts
        end
        metro_lines = parse_json dcmetro.lines
        display_lines metro_lines
      end

      desc 'stations [COLOR]', 'Displays rail station names for the line COLOR'
      long_desc %{
        `dcmetro stations [COLOR]` will display a list of the current statuions on the given line color.
        $ dcmetro stations green
        # The Metro rail system currently consists of ...

        Adding `-a` the metro system alerts will also be displayed.
        \>$ dcmetro lines -a
        \> *** ALERT! ALERT ***
        ...

        `dcmetro line [COLOR]` has the same behavior.
      }
      def stations(color)
        dcmetro = DCMetro::Information.new(color)
        stations = parse_json dcmetro.stations
        display_stations(stations, color)
      end

      map "line" => :stations

      desc 'station [NAME]', 'Display metro station train arrival and departure times.'
      method_option :alerts, aliases: '-a', type: :boolean, description: 'Display Metro wide alerts.'
      def station(from)
        #
        # $dcmetro station Greenbelt
        # => Displays the departure and arrival times at the Greenbelt Station
        #
        # $dcmetro station Greenbelt -a
        # => Displays the alerts, departure and arrival times at the Greenbelt Station
        #

        dc_metro = DCMetro::Information.new
        if options[:alerts]
          self.alerts
        end
        station = parse_json dc_metro.station(from)

        train_time = station['multiple'] ? multiple_stations(station['data']) : display_trains(station, from)
        train_time
      end

      desc 'travel [FROM] [TO]', 'Display travel information between two stations, including fare and duration.'
      method_option :alerts, aliases: '-a', type: :boolean, description: 'Display Metro wide alerts.'
      def travel(from, to)
        dcmetro = DCMetro::Information.new
        if options[:alerts]
          self.alerts
        end
        travel_info = dcmetro.station(from, to)
        fare_info = parse_json travel_info
        if (fare_info['StationToStationInfos'])
          display_travel_info fare_info
        else
          travel_stations = travel_multiple_stations(fare_info['data'])
          from = travel_stations[:from]
          to = travel_stations[:to]
          info = dcmetro.station(from, to)
          display_travel_info parse_json(info)
        end
      end

      private

      no_commands do
        #
        # returns color char for the lines
        # 
        # @param [String] line_code two character code from WMATA describing the line.
        # @return [String] unicode for color to match the font color with the line color
        def get_color(line_code)
          case line_code
          when 'GR', 'green'
            GREEN
          when 'BL', 'blue'
            BLUE
          when 'OR', 'orange'
            ORANGE
          when 'SV', 'silver'
            SILVER
          when 'YL', 'yellow'
            YELLOW
          else
            RED
          end
        end

        def parse_json(response)
          JSON.parse(response, quirks_mode: true)
        end

        def display_alerts(alerts)
          #
          # Formats the display of the alerts

          if alerts['Incidents'].empty?
            puts '*** No alerts reported. ***'
          else
            puts "#{RED}*** ALERT! ALERT! ***#{COLOR_OFF}"
            alerts['Incidents'].each { |incident| puts "#{incident['Description']}\n\n" }
          end
        end

        def display_lines(metro_lines)
          #@type[String]
          intro = %{
The Metro rail system currently consists of #{metro_lines['Lines'].length} rail lines.
Each line represented by a color.
The lines are:
          }
          puts intro
          metro_lines['Lines'].each do |line|
            color = get_color(line['LineCode'])
            puts "#{color}#{line['DisplayName']}#{COLOR_OFF}"
          end
        end

        def display_stations(stations, lineName)
          color = get_color(lineName.downcase)
          intro = %{
These are the current stations on the #{color}#{lineName.upcase}#{COLOR_OFF} line:
          }
          puts intro
          stations['Stations'].each { |station| puts station['Name'] }
          outro = %{
For more information about a station, including train departures, please run `dcmetro station STATION_NAME`.
          }
          puts outro
        end

        def display_trains(trainData, from)
          puts trainData
          #
          # Formats the display of the train arrival and departures
          trains = trainData['Trains']
          if trains.length < 1
            puts "There is no train information for '#{from}' at this time."
            return
          end

          puts "===== #{trains[0]['LocationName']} ====="
          trains.each do |prediction|
            puts "Line: #{prediction['Line']} | Towards: #{prediction['DestinationName']} | Arriving: #{prediction['Min']}"
          end
        end

        def display_travel_info(information)
          information = information['StationToStationInfos'][0]
          railFare = information['RailFare']
          puts "Distance: #{information['CompositeMiles']} Miles\n"
          puts "Estimate Travel Time: #{information['RailTime']} Minutes\n"
          puts "\n*** Fare Information ***\nOff Peak Time:  $#{railFare['OffPeakTime']}\nPeak Time:  $#{railFare['PeakTime']}\nSenior/Disabled:  $#{railFare['SeniorDisabled']}"
        end

        def multiple_stations(stations)
          puts "****Multiple stations found****"
          stations.each_with_index do |station,i|
            puts  "#{i} #{station['Name']}"
          end
          puts "****Please be more specific, enter the number below ****"
          specific = STDIN.gets.chomp.to_i
          puts stations[specific]["Name"]
          station(stations[specific]["Name"])
        end

        def travel_multiple_stations(stations)
          puts '****Multiple stations found****'
          stations.each_with_index do |station, i|
            puts "#{i} #{station['Name']}"
          end
          puts '****Please be more specific****'
          puts 'Enter the number of your starting station.'
          start = STDIN.gets.chomp.to_i
          puts 'Enter the number of your destination station.'
          destination = STDIN.gets.chomp.to_i
          from = stations[start]
          to = stations[destination] 
          return { from: from['Name'], to: to['Name'] }
        end
      end
    end
  end
end
