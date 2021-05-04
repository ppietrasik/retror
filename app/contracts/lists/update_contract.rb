# frozen_string_literal: true

module Lists
  class UpdateContract < ApplicationContract
    params do
      optional(:name).value(:string, max_size?: 24)
      optional(:position).value(:integer, gteq?: 0)
    end
  end
end
