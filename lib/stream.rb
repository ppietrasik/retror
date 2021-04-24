# frozen_string_literal: true

module Stream
  class << self
    def id(streamable)
      streamable.try(:to_gid_param) || streamable.to_param
    end

    def verified_id(stream_signed_id)
      stream_verifier.verified(stream_signed_id)
    end

    def signed_id(streamable)
      streamable_id = id(streamable)
      stream_verifier.generate(streamable_id)
    end

    private

    def stream_verifier
      @stream_verifier ||= ActiveSupport::MessageVerifier.new(stream_verifier_key, digest: 'SHA256', serializer: JSON)
    end

    def stream_verifier_key
      @stream_verifier_key ||= Rails.application.key_generator.generate_key('stream_verifier')
    end
  end
end
