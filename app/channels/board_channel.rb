# frozen_string_literal: true

class BoardChannel < ApplicationCable::Channel
  attr_reader :board

  def subscribed
    @board = Board.find_by(id: params[:id])
    return reject unless board

    stream_for board
  end
end
