require "dcmetro/version"
require_relative 'dcmetro/cli/application'

module DCMetro
  class Information
    attr_accessor :metro_incidents, :metro_lines, :metro_stations, :station_code, :metro_time

    def initialize
      @metro_incidents = JSON.parse(RestClient.get "http://api.wmata.com/Incidents.svc/json/Incidents?api_key=#{API_KEY}")
      @metro_lines = JSON.parse(RestClient.get "http://api.wmata.com/Rail.svc/json/JLines?api_key=#{API_KEY}")
      @metro_stations = metro_stations
      @station_code = ""
      @metro_time = metro_time
    end

    def alerts
      @metro_incidents
    end ### alerts

    def line(color=nil)
      if !color.nil?
        color = color.downcase
        @metro_stations = JSON.parse(RestClient.get "http://api.wmata.com/Rail.svc/json/jStations?LineCode=#{color}&api_key=#{API_KEY}")
        @metro_stations['Stations']
      else
        @metro_lines['Lines']
      end
    end ### line

    def station(name)
      url = "http://api.wmata.com/Rail.svc/json/jStations?api_key=#{API_KEY}"
      @metro_stations = JSON.parse(RestClient.get "#{url}")
      @metro_stations['Stations'].each do |station_name|
        if station_name['Name'].downcase.include? name.downcase
          x = station_time station_name
          return x
        end
      end
    end ### station

    private 

    def station_time(station)

      # puts station['Code']
      @station_code = station['Code']
      if !station['StationTogether1'].empty?
        @station_code += ",#{station['StationTogether1']}"
      end
      if !station['StationTogether2'].empty?
        @station_code += ",#{station['StationTogether2']}"
      end
      # p @station_code.class
      # @station_code = @station_code[1].nil? ? @station_code[0] : @station_code.join(",")

      # p @station_code
      url = "http://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{@station_code}?api_key=#{API_KEY}"
      # p url
      @metro_time = JSON.parse(RestClient.get "#{url}")  
      # p @metro_time 
      @metro_time
    end


  end ### Information

end ### Metro
