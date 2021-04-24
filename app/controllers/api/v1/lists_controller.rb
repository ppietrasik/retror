# frozen_string_literal: true

module Api
  module V1
    class ListsController < BaseController
      before_action :set_board, only: :create

      attr_reader :board, :list

      def create
        @list = List.new(**list_params, board: board)

        if list.save
          broadcast_new_list_event

          render json: ListBlueprint.render(list), status: :created
        else
          render json: { errors: list.errors.messages }, status: :bad_request
        end
      end

      def update
        @list = List.find(params[:id])

        if list.update(**list_params)
          render json: ListBlueprint.render(list)
        else
          render json: { errors: list.errors.messages }, status: :bad_request
        end
      end

      def destroy
        @list = List.find(params[:id])
        list.destroy

        head :no_content
      end

      private

      def set_board
        @board = Board.find(params[:board_id])
      end

      def list_params
        params.permit(:name)
      end

      def broadcast_new_list_event
        Stream::RenderBroadcastJob.perform_later(board, board.stream_tag, 'NewList', partial: 'lists/list', locals: { list: list })
      end
    end
  end
end
