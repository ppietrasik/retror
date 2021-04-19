require 'rails_helper'

RSpec.describe BoardChannel do
  subject(:create_subscription) { subscribe(id: id) }

  let(:board) { create(:board) }
  let(:id) { board.id }

  it 'successfully subscribes', :aggregate_failures do
    create_subscription

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_for(board)
  end

  context 'with non-existing board id' do
    let(:id) { "#{board.id}-a" }

    it 'rejects subscription' do
      create_subscription

      expect(subscription).to be_rejected
    end
  end
end
