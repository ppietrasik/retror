# frozen_string_literal: true

class List < ApplicationRecord
  validates :name, length: { in: 4..24 }, presence: true

  belongs_to :board
end
