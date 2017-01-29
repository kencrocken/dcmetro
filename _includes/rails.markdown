{% highlight ruby %}
class WelcomeController < ApplicationController

    def index
        dc_metro = DCMetro::Information.new
        @alerts = dc_metro.alerts['Incidents']
        @lines = dc_metro.line
        @stations = dc_metro.line "green"
        @college_park = dc_metro.station "college park"
    end
{% endhighlight %}

{% highlight haml %}
    %section{:id => "alerts"}
        - if @alerts.empty?
            %p No incidents to report
        - else
            - @alerts.each do |alert|
                %p= alert['Description']
{% endhighlight %}