require 'rails_helper'

RSpec.describe Stream::RenderBroadcastJob do
  describe '.perform' do
    subject(:method_call) { described_class.perform_now(streamable, stream_tag, event, **renderings) }

    let(:streamable) { 'Model' }
    let(:stream_tag) { '1234' }
    let(:event) { 'NewEvent' }
    let(:renderings) { { partial: 'views/test_partial' } }

    let(:stream_channel_double) { class_double(StreamChannel).as_stubbed_const }

    it 'executes correct behaviour' do
      expect(stream_channel_double).to receive(:broadcast_message).with(streamable, stream_tag, event, "<div class=\"test-partial\"></div>\n")

      method_call
    end
  end
end
