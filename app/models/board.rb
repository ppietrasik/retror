# frozen_string_literal: true

class Board < ApplicationRecord
  include Stream::Entity

  validates :name, length: { maximum: 32 }, allow_blank: true

  has_many :lists, -> { order(position: :asc) }, inverse_of: :board, dependent: :destroy
end
