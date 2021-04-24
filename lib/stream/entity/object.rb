# frozen_string_literal: true

module Stream
  module Entity
    class Object
      def initialize(model, name:, identifier:)
        @model = model
        @name = name
        @identifier = identifier
      end

      def stream_tag
        [name, identifier].map(&eval_attribute).join(':')
      end

      private

      attr_reader :model, :name, :identifier

      def eval_attribute
        lambda do |attribute|
          return model.instance_exec(&attribute) if attribute.is_a?(Proc)

          attribute.to_param
        end
      end
    end
  end
end
