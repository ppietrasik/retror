# frozen_string_literal: true

class StreamChannel < ApplicationCable::Channel
  class << self
    def broadcast_message(streamable, stream_tag, event, data)
      stream_id = Stream.id(streamable)
      ActionCable.server.broadcast(stream_id, { tag: stream_tag, event: event, data: data })
    end
  end

  def subscribed
    stream_id = Stream.verified_id(params[:stream_id])
    return reject unless stream_id

    stream_from stream_id
  end
end
