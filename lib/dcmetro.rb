require 'dcmetro/version'
require_relative 'dcmetro/cli/application'


module DCMetro

  class Information
    attr_accessor :alerts, :lines, :line, :stations, :station_code, :metro_time, :travel_info

    BASE_URL = 'https://api.wmata.com'.freeze

    def initialize(line=nil)
      @alerts = alerts
      @lines = lines
      @line = line
      @stations = stations if @line
      @station_code    = ''

      @metro_time      = metro_time
      @travel_info     = travel_info
    end

    #
    # calls the incidents endpoint for the WMATA api
    #
    # @return [Hash] Incidents key contains an array of wmata alerts
    #
    def alerts
      @alerts ||= RestClient.get "#{BASE_URL}/Incidents.svc/json/Incidents", params: {
        'api_key' => API_KEY,
        'subscription-key' => API_KEY
      }
    end

    #
    # calls the rail lines endpoint
    #
    # @return [Response] <description>
    #
    def lines
      RestClient.get "#{BASE_URL}/Rail.svc/json/JLines", params: {
        'api_key'          => API_KEY,
        'subscription-key' => API_KEY
      }
    end

    #
    # Retrieves a list of stations on a given line, if the metro line is set
    #
    # @return [RestClient] response from WMATA end point to retrieve stations on a given line
    #
    def stations
      raise 'Don\'t know which line color.  Ensure the Metro line color has been set.' if !@line
      color = @line
      # puts color
      colorCode = case color
              when 'red'
                'RD'
              when 'green'
                'GR'
              when 'yellow'
                'YL'
              when 'blue'
                'BL'
              when 'orange'
                'OR'
              when 'silver'
                'SV'
              else
                raise "Invalid argument, #{color}"
              end
      RestClient.get "#{BASE_URL}/Rail.svc/json/jStations", params: {
          'LineCode'         => colorCode,
          'api_key'          => API_KEY,
          'subscription-key' => API_KEY}
    end

    def station(source, destination = nil)
      #
      # Makes the api call to return all stations in the Metro rail system and
      # then grabs the specific station passed by the user

      # instantiates a new array to help check for multiple matching stations
      stations_check = []

      # forming the api call
      @metro_stations = JSON.parse(get_all_stations)

      if destination.nil?
        # Iterates through the response checking if the station name passed by the user
        # is included in the return response
        @metro_stations['Stations'].each do |metro_station|
          next unless metro_station['Name'].downcase.include? source.downcase
          # if the names of the station matches the user's station, the station
          # is pushed to an array
          stations_check.push(metro_station)
        end
        # Oddly, the api seems to return some stations twice - since some stations have more than
        # one line.  Though the additional station information is contained in each instance of the
        # station.
        # We limit our array to only unique station names, hopefully limiting the array to a single item
        stations_check.uniq! { |station| station['Name'] }

        # If the array length is greater than 1, we ask the user to be more specific and
        # return the names of the stations
        if stations_check.length > 1
          return {
            multiple: true,
            data: stations_check
          }.to_json
        
        else
          # We pass the station the retrieve_train_time method to grab the predictions
          retrieve_train_time(stations_check) 
          # response = {
          #   multiple: false,
          #   data: JSON.parse(@metro_time)
          # }.to_json
          # response
        end
      else
        #  Will become travel_info
        stations     = [source, destination]
        station_code = []
        stations.each do |station|
          @metro_stations['Stations'].each do |station_name|
            if station_name['Name'].downcase.include? station.downcase
              station_code << station_name
            end
          end
        end
        station_code.uniq! { |station| station['Name'] }
        if station_code.length > 2
          @travel_info = { error: true, data: station_code}.to_json
        else
          @travel_info = RestClient.get "#{BASE_URL}/Rail.svc/json/jSrcStationToDstStationInfo", params: {
            'FromStationCode' => station_code[0]['Code'],
            'ToStationCode' => station_code[1]['Code'],
            'api_key' => API_KEY,
            'subscription-key' => API_KEY
          }
        end
      end
    end ### station

    private

    def get_all_stations
      RestClient.get "#{BASE_URL}/Rail.svc/json/jStations", params: {
        'api_key' => API_KEY,
        'subscription-key' => API_KEY
      }
    end

    #
    # This makes an api call to grab the train arrival and departure predictions.
    # If more than one line is present at a station, such is concatenated and
    # the call is made on all lines.

    def retrieve_train_time(stationArray)
      station = stationArray[0]
      # puts station
      # puts station['Code']
      # If a station has multiple stations codes we join the codes together
      @station_code = station['Code']
      unless station['StationTogether1'].empty?
        @station_code += ",#{station['StationTogether1']}"
      end
      unless station['StationTogether2'].empty?
        @station_code += ",#{station['StationTogether2']}"
      end

      # The call to the api is made and the prediction times are returned
      @metro_time = RestClient.get "#{BASE_URL}/StationPrediction.svc/json/GetPrediction/#{@station_code}", params: {
        'api_key' => API_KEY,
        'subscription-key' => API_KEY
      }
    end
  end ### Information
end ### Metro
