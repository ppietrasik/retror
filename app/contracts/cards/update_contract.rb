# frozen_string_literal: true

module Cards
  class UpdateContract < ApplicationContract
    option :card

    params do
      optional(:note).value(:string, max_size?: 255)
      optional(:position).value(:integer, gteq?: 0)
      optional(:list_id).value(:string)
    end

    rule(:position) do
      key.failure(:invalid) if key? && value > last_position
    end

    rule(:list_id) do
      if key?
        update_list = List.find_by(id: value)

        key.failure(:not_found) unless update_list
        key.failure(:invalid) unless rule_error? || update_list.board_id == list.board_id
      end
    end

    delegate :list, to: :card

    def last_position
      last_card = list.cards.last
      last_card&.position || 0
    end
  end
end
