require 'rails_helper'

RSpec.describe StreamChannel do
  describe '#subscribed' do
    subject(:method_call) { subscribe(stream_id: stream_id) }

    let(:streamable) { Class.new }
    let(:stream_id) { Stream.signed_id(streamable) }

    it 'successfully subscribes', :aggregate_failures do
      method_call

      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(Stream.id(streamable))
    end

    context 'with invalid stream_id' do
      let(:stream_id) { 'abc' }

      it 'rejects subscription' do
        method_call

        expect(subscription).to be_rejected
      end
    end
  end

  describe '.broadcast_message' do
    subject(:method_call) { described_class.broadcast_message(streamable, tag, event, data) }

    let(:streamable) { Class.new }
    let(:tag) { '1234' }
    let(:event) { 'NewEvent' }
    let(:data) { '<div></div>' }

    it 'performs correct broadcast' do
      expect { method_call }.to have_broadcasted_to(Stream.id(streamable)).from_channel(described_class).with(tag: tag, event: event, data: data)
    end
  end
end
