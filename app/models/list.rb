# frozen_string_literal: true

class List < ApplicationRecord
  include Stream::Entity

  validates :name, length: { maximum: 24 }, allow_blank: true

  belongs_to :board
end
