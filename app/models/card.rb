# frozen_string_literal: true

class Card < ApplicationRecord
  include Stream::Entity

  belongs_to :list

  delegate :board, to: :list
end
