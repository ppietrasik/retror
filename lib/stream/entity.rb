# frozen_string_literal: true

module Stream
  module Entity
    def self.included(klass)
      klass.class_eval do
        @stream_entity_options = { name: name, identifier: -> { to_param } }

        class << self
          attr_reader :stream_entity_options

          private

          def stream_entity(name:, identifier:)
            @stream_entity_options = { name: name, identifier: identifier }
          end
        end
      end
    end

    delegate :stream_tag, to: :stream_entity

    def stream_entity
      @stream_entity ||= Stream::Entity::Object.new(self, **self.class.stream_entity_options)
    end
  end
end
