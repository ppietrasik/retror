# frozen_string_literal: true

class DefaultBoardBuilder
  class << self
    def build(params)
      start_list = List.new(name: I18n.t(:start_list_name, scope: :default_board_builder), position: 0)
      stop_list = List.new(name: I18n.t(:stop_list_name, scope: :default_board_builder), position: 1)
      continue_list = List.new(name: I18n.t(:continue_list_name, scope: :default_board_builder), position: 2)

      Board.new(**params, lists: [start_list, stop_list, continue_list])
    end
  end
end
