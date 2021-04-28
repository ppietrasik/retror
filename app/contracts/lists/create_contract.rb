# frozen_string_literal: true

module Lists
  class CreateContract < ApplicationContract
    params do
      required(:name).value(:string, max_size?: 24)
    end
  end
end
