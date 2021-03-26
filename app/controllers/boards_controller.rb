# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :set_board, only: :show

  def show; end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to @board
    else
      render :new
    end
  end

  private

    def set_board
      @board = Board.find(params[:id])
    end

    def board_params
      params.require(:board).permit(:name)
    end
end
