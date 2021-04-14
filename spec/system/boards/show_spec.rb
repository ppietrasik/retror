# frozen_string_literal: true

require 'system_helper'

describe 'Boards -> Show' do
  let(:board) { create(:board, name: name) }
  let(:name) { 'My Board' }

  subject do
    visit board_path(board)
  end

  it 'displays existing board' do
    subject

    expect(page).to have_text 'My Board'
  end
end
