# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  config.messages.default_locale = :en
  config.messages.top_namespace = 'retror'
  config.messages.load_paths << 'config/errors.yml'
end
