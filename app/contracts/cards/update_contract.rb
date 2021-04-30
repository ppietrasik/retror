# frozen_string_literal: true

module Cards
  class UpdateContract < ApplicationContract
    option :list

    params do
      optional(:note).value(:string, max_size?: 255)
      optional(:position).value(:integer, gteq?: 0)
    end

    rule(:position) do
      key.failure(:invalid) if key? && values[:position] > last_position
    end

    def last_position
      last_card = list.cards.last
      last_card&.position || 0
    end
  end
end
