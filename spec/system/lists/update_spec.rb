require 'rails_helper'

describe 'Board/Lists -> Update' do
  subject(:update_list) do
    name_input = find('#listName')

    name_input.click
    name_input.fill_in(with: new_name)
    name_input.send_keys(:tab)

    sleep 0.1 # wait for websocket
  end

  let!(:list) { create(:list, name: 'Old name') }
  let(:board) { list.board }

  let(:new_name) { 'Updated name' }

  before { visit board_path(board) }

  it 'update the list' do
    update_list

    current_list = list.reload
    expect(current_list).to have_attributes(name: new_name)
  end

  it "updates list's name in dom" do
    name_input = find('#listName')

    expect { update_list }.to change(name_input, :value).from('Old name').to(new_name)
  end

  context 'with second widow open' do
    let(:second_window) { open_new_window }

    it "updates list's name in the second window's dom", :aggregate_failures do
      within_window second_window do
        visit board_path(board)

        name_input = find('#listName')
        expect(name_input.value).to eq('Old name')
      end

      update_list

      within_window second_window do
        name_input = find('#listName')
        expect(name_input.value).to eq(new_name)
      end
    end
  end
end
