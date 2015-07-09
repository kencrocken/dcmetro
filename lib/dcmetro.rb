require "dcmetro/version"
require_relative 'dcmetro/cli/application'

module DCMetro
  class Information
    attr_accessor :metro_incidents, :metro_lines, :metro_stations, :station_code, :metro_time

    def initialize
      @metro_incidents = JSON.parse(RestClient.get "http://api.wmata.com/Incidents.svc/json/Incidents?api_key=#{API_KEY}&subscription-key=#{API_KEY}")
      @metro_lines = JSON.parse(RestClient.get "http://api.wmata.com/Rail.svc/json/JLines?api_key=#{API_KEY}&subscription-key=#{API_KEY}")
      @metro_stations = metro_stations
      @station_code = ""
      @metro_time = metro_time
    end

    def alerts
      #
      # Makes the api call and returns the alerts

      @metro_incidents
    end ### alerts

    def line(color=nil)
      #
      # Makes the api call and returns either the stations on a particular line or
      # if no color is passed, returns the metro lines

      if !color.nil?
        color = color.downcase
        @metro_stations = JSON.parse(RestClient.get "http://api.wmata.com/Rail.svc/json/jStations?LineCode=#{color}&api_key=#{API_KEY}&subscription-key=#{API_KEY}")
        @metro_stations['Stations']
      else
        @metro_lines['Lines']
      end
    end ### line

    def station(name)
      #
      # Makes the api call to return all stations in the Metro rail system and
      # then grabs the specific station passed by the user

      # instantiates a new array to help check for multiple matching stations
      stations_check = []

      # forming the api call
      url = "https://api.wmata.com/Rail.svc/json/jStations?api_key=#{API_KEY}&subscription-key=#{API_KEY}"
      @metro_stations = JSON.parse(RestClient.get "#{url}")

      # Iterates through the response checking if the station name passed by the user
      # is included in the return response
      @metro_stations['Stations'].each do |station_name|
        if station_name['Name'].downcase.include? name.downcase

          # if the names of the station matches the user's station, the station
          # is pushed to an array
          stations_check.push(station_name)
        end
      end

      # Oddly, the api seems to return some stations twice - since some stations have more than
      # one line.  Though the additional station information is contained in each instance of the 
      # station. 
      # We limit our array to only unique station names, hopefully limiting the array to a single item
      stations_check.uniq! { |station| station['Name'] }

      # If the array length is greater than 1, we ask the user to be more specific and 
      # return the names of the stations
      if stations_check.length > 1
        puts "****Multiple stations found****"
        stations_check.each do |station|
          puts station['Name']
          puts station
        end
        abort "****Please be more specific****"
      else
        # We pass the station the station_time method to grab the predictions
        station_time stations_check[0]
      end
    end ### station

    private 

    #
    # This makes an api call to grab the train arrival and departure predictions.
    # If more than one line is present at a station, such is concatenated and 
    # the call is made on all lines.

    def station_time(station)

      # If a station has multiple stations codes we join the codes together
      @station_code = station['Code']
      if !station['StationTogether1'].empty?
        @station_code += ",#{station['StationTogether1']}"
      end
      if !station['StationTogether2'].empty?
        @station_code += ",#{station['StationTogether2']}"
      end

      # The call to the api is made and the prediction times are returned
      url = "http://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{@station_code}?api_key=#{API_KEY}&subscription-key=#{API_KEY}"
      @metro_time = JSON.parse(RestClient.get "#{url}")  
      @metro_time
    end

  end ### Information

end ### Metro
