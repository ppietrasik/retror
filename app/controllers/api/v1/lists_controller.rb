# frozen_string_literal: true

module Api
  module V1
    class ListsController < BaseController
      attr_reader :board, :list

      def create
        @board = Board.find(params[:board_id])

        result = Lists::CreateContract.new.call(**list_create_params)

        if result.success?
          @list = List.create(**list_create_params, board: board)
          broadcast_new_list_event

          render json: ListBlueprint.render(list), status: :created
        else
          render json: { errors: result.errors.to_h }, status: :bad_request
        end
      end

      def update
        @list = List.find(params[:id])

        result = Lists::UpdateContract.new.call(**list_update_params)

        if result.success?
          list.update(list_update_params)
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

      def list_create_params
        params.permit(:name)
      end

      def list_update_params
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
