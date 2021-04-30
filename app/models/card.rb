# frozen_string_literal: true

class Card < ApplicationRecord
  include Stream::Entity

  belongs_to :list

  acts_as_list scope: :list, top_of_list: 0, sequential_updates: false

  delegate :board, to: :list
end
