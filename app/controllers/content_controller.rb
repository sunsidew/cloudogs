class ContentController < ApplicationController
  include ActionController::Live

  def stream
    response.headers['Content-Type'] = 'text/event-stream'

    redis = Redis.new
    redis.subscribe('new_message') do |on|
      on.message do |event, data|
        response.stream.write "event: #{event}\n"
        response.stream.write "data: #{data}\n\n"
        #puts event, data
      end
    end

#    render nothing: true
  rescue IOError
    redis.quit
  ensure
#    redis.quit
    response.stream.close
  end
end
