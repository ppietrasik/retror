# frozen_string_literal: true

class List < ApplicationRecord
  include Stream::Entity

  belongs_to :board
  has_many :cards, -> { order(position: :asc) }, inverse_of: :list, dependent: :destroy

  acts_as_list scope: :board, top_of_list: 0, sequential_updates: false
end
