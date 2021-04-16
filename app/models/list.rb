# frozen_string_literal: true

class List < ApplicationRecord
  validates :name, length: { maximum: 24 }, allow_blank: true

  belongs_to :board
end
