class ContentController < ApplicationController
  include ActionController::Live

  def stream
  	response.headers['Content-Type'] = 'text/event-stream'

  	redis = Redis.new
    redis.subscribe('new_message') do |on|
      on.message do |event, data|
        response.stream.write "event: #{event}\n"
        #response.stream.write ""
        response.stream.write "data: #{data}\n\n"
        print "event- :"+event+"\n"
        print "data- :"+data+"\n"
        #puts event, data
      end
    end

    render nothing: true
  rescue IOError

  ensure
    redis.quit
    response.stream.close
  end
end
