# DCMetro

Rails class and a command line interface to access the Washington, D.C. Metro Rail API.  Returns the systemwide alerts, lines, stations and arrival times for the lines at each station.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dcmetro'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dcmetro

## Usage
###Rails App

With the gem installed, instantiate a new class in your controller:

```
class WelcomeController < ApplicationController


  def index
    x = DCMetro::Information.new
    @alerts = x.alerts['Incidents']
    @lines = x.line
    @stations = x.line "green"
    @college_park = x.station "college"
    @rosslyn = x.station "ross"
    @fort_totten = x.station "fort"
    @metro_center = x.station "metro"
  end

end
```

###CLI

```
$ dcmetro
Commands:
  dcmetro alerts          # Display DC Metro system wide alerts.
  dcmetro help [COMMAND]  # Describe available commands or one specific command
  dcmetro line COLOR      # Display metro rail lines, if COLOR, displays rail stations on the COLOR line
  dcmetro station NAME    # Display metro station train arrival and departure times.
  ```
  

## Contributing

1. Fork it ( https://github.com/kencrocken/dcmetro/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
