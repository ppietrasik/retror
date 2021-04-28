# frozen_string_literal: true

class List < ApplicationRecord
  include Stream::Entity

  belongs_to :board

  acts_as_list scoep: :board, top_of_list: 0, sequential_updates: false
end
