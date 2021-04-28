# frozen_string_literal: true

module Api
  module V1
    class ListsController < BaseController
      attr_reader :board, :list

      def create
        @board = Board.find(params[:board_id])
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

        contract = Lists::UpdateContract.new(board: list.board)
        result = contract.call(**list_params)

        if result.success?
          list.update(list_params)
          broadcast_update_list_event

          render json: ListBlueprint.render(list)
        else
          render json: { errors: result.errors.to_h }, status: :bad_request
        end
      end

      def destroy
        @list = List.find(params[:id])

        list.destroy
        broadcast_delete_list_event

        head :no_content
      end

      private

      def list_params
        params.permit(:name, :position)
      end

      def broadcast_new_list_event
        renderings = { partial: 'lists/list', locals: { list: list } }
        Stream::RenderBroadcastJob.perform_later(board, board.stream_tag, 'NewList', **renderings)
      end

      def broadcast_update_list_event
        data = { name: list.name, position: list.position }
        StreamChannel.broadcast_message(list.board, list.stream_tag, 'UpdateList', data)
      end

      def broadcast_delete_list_event
        StreamChannel.broadcast_message(list.board, list.stream_tag, 'DeleteList', nil)
      end
    end
  end
end
