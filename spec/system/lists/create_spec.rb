require 'rails_helper'

describe 'Board/Lists -> Create' do
  subject(:press_create) do
    visit board_path(board)

    click_on 'createList'
  end

  let(:board) { create(:board) }

  it 'creates new list' do
    expect { press_create }.to change(List, :count).from(0).to(1)
  end
end
