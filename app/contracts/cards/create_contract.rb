# frozen_string_literal: true

module Cards
  class CreateContract < ApplicationContract
    params do
      required(:note).value(:string, max_size?: 255)
    end
  end
end
