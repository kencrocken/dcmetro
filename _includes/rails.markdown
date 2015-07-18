{% highlight ruby %}
class WelcomeController < ApplicationController

    def index
        x = DCMetro::Information.new
        @alerts = x.alerts['Incidents']
        @lines = x.line
        @stations = x.line "green"
        @college_park = x.station "college park"
{% endhighlight %}

{% highlight haml %}
    %section{:id => "alerts"}
        - if @alerts.empty?
            %p No incidents to report
        - else
            - @alerts.each do |alert|
                %p= alert['Description']
{% endhighlight %}