# frozen_string_literal: true

module Stream
  class RenderBroadcastJob < ApplicationJob
    discard_on ActiveJob::DeserializationError

    def perform(streamable, stream_tag, event, **rendering)
      StreamChannel.broadcast_message(streamable, stream_tag, event, render_html(rendering))
    end

    private

    def render_html(rendering)
      ApplicationController.render(**rendering)
    end
  end
end
