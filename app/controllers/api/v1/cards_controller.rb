# frozen_string_literal: true

module Api
  module V1
    class CardsController < BaseController
      attr_reader :card, :list

      def create
        @list = List.find(params[:list_id])

        result = Cards::CreateContract.new.call(**card_create_params)

        if result.success?
          @card = Card.create(**card_create_params, list: list)
          broadcast_new_card_event

          render json: CardBlueprint.render(card), status: :created
        else
          render json: { errors: result.errors.to_h }, status: :bad_request
        end
      end

      def update
        @card = Card.find(params[:id])

        contract = Cards::UpdateContract.new(card: card)
        result = contract.call(**card_update_params)

        if result.success?
          card.update(card_update_params)
          broadcast_update_card_event

          render json: CardBlueprint.render(card)
        else
          render json: { errors: result.errors.to_h }, status: :bad_request
        end
      end

      def destroy
        @card = Card.find(params[:id])

        card.destroy
        broadcast_delete_card_event

        head :no_content
      end

      private

      def card_create_params
        params.permit(:note)
      end

      def card_update_params
        params.permit(:note, :position, :list_id)
      end

      def broadcast_new_card_event
        renderings = { partial: 'cards/card', locals: { card: card } }
        Stream::RenderBroadcastJob.perform_later(card.board, list.stream_tag, 'NewCard', **renderings)
      end

      def broadcast_update_card_event
        data = { note: card.note, position: card.position, list_id: card.list_id }
        StreamChannel.broadcast_message(card.board, card.stream_tag, 'UpdateCard', data)
      end

      def broadcast_delete_card_event
        StreamChannel.broadcast_message(card.board, card.stream_tag, 'DeleteCard', nil)
      end
    end
  end
end
