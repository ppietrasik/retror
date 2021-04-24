require 'rails_helper'

RSpec.describe Stream::Entity::Object do
  subject(:class_instance) { described_class.new(model, name: name, identifier: identifier) }

  let!(:model) do
    Class.new.instance_eval do
      def name
        'Model'
      end

      def id
        '1234'
      end

      self
    end
  end

  let(:name) { 'EntityName' }
  let(:identifier) { 'EntityIdentifier' }

  describe '#stream_tag' do
    subject(:method_call) { class_instance.stream_tag }

    it { is_expected.to eq('EntityName:EntityIdentifier') }

    context 'with proc attributes' do
      let(:name) { -> { name } }
      let(:identifier) { -> { id } }

      it { is_expected.to eq('Model:1234') }

      it 'evalueates procs in a context of the model', :aggregate_failures do
        expect(model).to receive(:name)
        expect(model).to receive(:id)

        method_call
      end
    end
  end
end
