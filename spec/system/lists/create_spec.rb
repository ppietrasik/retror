require 'rails_helper'

describe 'Board/Lists -> Create' do
  subject(:press_create) do
    visit board_path(board)

    click_on 'createList'
    sleep 0.5 # wait for websocket
  end

  let(:board) { create(:board) }

  it 'creates new list' do
    expect { press_create }.to change(List, :count).from(0).to(1)
  end

  it 'renderes new list in the dom', :aggregate_failures do
    expect(page).to have_no_selector('div[data-list-id]')

    press_create

    created_list = List.last
    expect(page).to have_selector("div[data-list-id='#{created_list.id}']")
  end
end
