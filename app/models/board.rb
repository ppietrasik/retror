# frozen_string_literal: true

class Board < ApplicationRecord
  validates :name, length: { in: 4..32 }, presence: true

  has_many :lists
end
