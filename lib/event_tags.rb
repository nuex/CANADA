module EventTags
  include Radiant::Taggable

  class TagError < StandardError; end

  desc %{
    Event namespace.

    *Usage:*
    <pre><code><r:events>...</r:events></code></pre>
  }
  tag 'events' do |tag|
    tag.expand
  end

  desc %{
    Cycle through each event. Use the `months` attribute to call events occuring within the given range, otherwise all events will be queried.

    *Usage:*
    <pre><code><r:events:each [months="3"]>...</r:events:each></code></pre>
  }
  tag 'events:each' do |tag|
    if months = tag.attr['months']
      events = Event.all(:conditions => {
                                      :start_datetime => Time.now .. months.to_i.months.from_now })
    else
      events = Event.all
    end
    result = []
    events.each do |event|
      tag.locals.event = event
      result << tag.expand
    end
    result
  end

  desc %{
    Show the event's start time. Use the `format` attribute to format the date using a ruby strftime string. The default is "February 20, 2010 12:00 AM".

    *Usage:*
    <pre><code><r:events:start_datetime /></code></pre>
  }
  tag 'events:start_datetime' do |tag|
    format = tag.attr['format'] || '%B %d, %Y %I:%M%p'
    tag.locals.event.start_datetime.strftime(format)
  end

  desc %{
    Show the event's end time. Use the `format` attribute to format the date using a ruby strftime string. The default is "February 20, 2010 12:00 AM".

    *Usage:*
    <pre><code><r:events:end_datetime /></code></pre>
  }
  tag 'events:end_datetime' do |tag|
    format = tag.attr['format'] || '%B %d, %Y %I:%M%p'
    event = tag.locals.event
    event.end_datetime.strftime(format) if event.end_datetime
  end

  desc %{
    Show the event's time period. If the event does not have an end datetime, only a start time will be shown. Use the `format` attribute to format the time using a ruby strftime string. The default is "12:00AM".

    *Usage:*
    <pre><code><r:events:period [format="%I:%M%p"] /></code></pre>
  }
  tag 'events:period' do |tag|
    format = tag.attr['format'] || "%I:%M%p"
    event = tag.locals.event
    display = event.start_datetime.strftime(format)
    endtime = event.end_datetime
    if endtime
      display << " - #{endtime.strftime(format)}"
    end
    display
  end

  desc %{
    Render child tags if the event has a location.

    *Usage:*
    <pre><code><r:events:if_location /></code></pre>
  }
  tag 'events:if_location' do |tag|
    tag.expand if tag.locals.event.location
  end

  desc %{
    Show the event's location title.

    *Usage:*
    <pre><code><r:events:location /></code></pre>
  }
  tag 'events:location' do |tag|
    event = tag.locals.event
    event.location.title if event.location
  end

  %W{title description}.each do |method|
    desc %{
      Show the event's #{method}.

      *Usage:*
      <pre><code><r:events:#{method} /></code></pre>
    }
    tag "events:#{method}" do |tag|
      tag.locals.event.send(method)
    end
  end

  desc %{
    Render child tags if the event has a description.

    *Usage:*
    <pre><code><r:events:if_description /></code></pre>
  }
  tag 'events:if_description' do |tag|
    tag.expand if tag.locals.event.description
  end

end
