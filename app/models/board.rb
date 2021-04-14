# frozen_string_literal: true

class Board < ApplicationRecord
  validates :name, length: { maximum: 32 }, allow_blank: true

  has_many :lists, dependent: :destroy
end
