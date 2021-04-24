require 'rails_helper'

# rubocop:disable RSpec/DescribedClass
RSpec.describe Stream::Entity do
  subject(:class_instance) { klass.new }

  let!(:klass) do
    Class.new do
      include Stream::Entity

      stream_entity name: 'Entity', identifier: '1234'
    end
  end

  it 'allows to setup stream_entity_options' do
    expect(klass.stream_entity_options).to include(name: 'Entity', identifier: '1234')
  end

  describe '#stream_entity' do
    subject(:method_call) { class_instance.stream_entity }

    let(:entity_object_double) { instance_double(Stream::Entity::Object) }

    before do
      allow(Stream::Entity::Object).to receive(:new).and_return(entity_object_double)
    end

    it 'retruns correct object', :aggregate_failures do
      expect(Stream::Entity::Object).to receive(:new).with(class_instance, **klass.stream_entity_options)
      expect(method_call).to eq(entity_object_double)
    end
  end

  describe '#stream_tag' do
    subject(:method_call) { class_instance.stream_tag }

    it 'delegates method to stream_entity' do
      expect(class_instance.stream_entity).to receive(:stream_tag)

      method_call
    end
  end

  context 'without stream_entity setup' do
    let!(:klass) do
      stub_const 'EntityTest', Class.new # couldn't find a better way

      EntityTest.class_eval do
        include Stream::Entity

        def self.to_param
          'ToParamResult'
        end

        self
      end
    end

    it 'has correct stream_entity_options parameters' do
      expect(klass.stream_entity_options).to include(
        name: 'EntityTest',
        identifier: satisfy { |v| v.call == 'ToParamResult' }
      )
    end
  end
end
# rubocop:enable RSpec/DescribedClass
