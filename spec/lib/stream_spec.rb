require 'rails_helper'

RSpec.describe Stream do
  describe '.id' do
    subject(:method_call) { described_class.id(streamable) }

    let!(:streamable) do
      Class.new.instance_eval do
        def to_gid_param
          'gid'
        end

        self
      end
    end

    it { is_expected.to eq('gid') }

    it 'calls correct param' do
      expect(streamable).to receive(:to_gid_param)

      method_call
    end

    context 'with streamable that does not implement to_gid_param method' do
      let!(:streamable) { Class.new }

      it { is_expected.to eq(streamable.to_param) }

      it 'calls correct param' do
        expect(streamable).to receive(:to_param)

        method_call
      end
    end
  end

  describe '.signed_id' do
    subject(:method_call) { described_class.signed_id(streamable) }

    let(:streamable) { '123' }

    let(:id) { 'abc' }
    let(:msg_verifier) { ActiveSupport::MessageVerifier.new('key', digest: 'SHA256', serializer: JSON) }

    before do
      allow(described_class).to receive(:id).and_return(id)
      allow(described_class).to receive(:stream_verifier).and_return(msg_verifier)
    end

    it { is_expected.to eq(msg_verifier.generate(id)) }
  end

  describe '.verified_id' do
    subject(:method_call) { described_class.verified_id(stream_signed_id) }

    let(:stream_signed_id) { msg_verifier.generate(id) }

    let(:id) { 'abc' }
    let(:msg_verifier) { ActiveSupport::MessageVerifier.new('key', digest: 'SHA256', serializer: JSON) }

    before do
      allow(described_class).to receive(:stream_verifier).and_return(msg_verifier)
    end

    it { is_expected.to eq(msg_verifier.verified(stream_signed_id)) }

    context 'with failed verification' do
      let(:stream_signed_id) { 'abc' }

      it { is_expected.to eq(nil) }
    end
  end
end
