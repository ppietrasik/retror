# frozen_string_literal: true

class BoardsController < ApplicationController
  attr_reader :board

  def show
    @board = Board.includes(lists: :cards).find(params[:id])

    render :show, locals: { board: board }
  end

  def new
    @board = Board.new

    render :new, locals: { board: board }
  end

  def create
    @board = checked_default_setup? ? DefaultBoardBuilder.build(board_params) : Board.new(board_params)

    if board.save
      redirect_to board
    else
      render :new, locals: { board: board }
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def checked_default_setup?
    params[:board][:default_setup] == '1'
  end
end
