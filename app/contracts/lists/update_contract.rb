# frozen_string_literal: true

module Lists
  class UpdateContract < ApplicationContract
    option :board

    params do
      optional(:name).value(:string, max_size?: 24)
      optional(:position).value(:integer, gteq?: 0)
    end

    rule(:position) do
      key.failure(:invalid) if key? && value > last_position
    end

    def last_position
      last_list = board.lists.last
      last_list&.position || 0
    end
  end
end
