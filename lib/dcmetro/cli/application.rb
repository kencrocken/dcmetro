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
          x.line(color).each { |station| puts station['Name']}
        else
          x.line.each { |line| puts line["DisplayName"]}
        end
      end

      desc "lines", "invokes line method"
      def lines color=nil
        invoke :line
      end

      desc 'station NAME', 'Display metro station train arrival and departure times.'
      method_option :alerts, :aliases => '-a', :type => :boolean,  :description => "Display Metro wide alerts."
      def station(name)
        #
        # $dcmetro station Greenbelt
        # => Displays the departure and arrival times at the Greenbelt Station
        #
        # $dcmetro station Greenbelt -a
        # => Displays the alerts, departure and arrival times at the Greenbelt Station
        #

        x = DCMetro::Information.new

        if options[:alerts]
          y = x.alerts
          display_alerts y
        end

        x = x.station(name)
        train_time = x['Trains'].empty? ? "Sorry, there is no information for #{name}." : display_trains(x['Trains'])
        puts train_time if !train_time.kind_of?(Array)
        train_time
      end

      private

      no_commands do

        def parse_json(response)
          JSON.parse(response)
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

      end

    end
  end
end
