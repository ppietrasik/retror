# frozen_string_literal: true

module Cards
  class UpdateContract < ApplicationContract
    params do
      optional(:note).value(:string, max_size?: 255)
    end
  end
end
