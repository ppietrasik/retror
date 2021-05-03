require 'rails_helper'

describe 'Board/Lists -> Update' do
  describe 'Name' do
    subject(:update_name) do
      name_input_element = name_input

      name_input_element.double_click
      name_input_element.fill_in(with: new_name)
      name_input_element.send_keys(:tab)

      sleep 0.1 # wait for websocket
    end

    let!(:list) { create(:list, name: 'Old name') }
    let(:board) { list.board }

    let(:new_name) { 'Updated name' }

    before { visit board_path(board) }

    it 'update the list' do
      update_name

      current_list = list.reload
      expect(current_list).to have_attributes(name: new_name)
    end

    it "updates list's name in dom" do
      expect { update_name }.to change(name_input, :value).from('Old name').to(new_name)
    end

    context 'with second widow open' do
      let(:second_window) { open_new_window }

      it "updates list's name in the second window's dom", :aggregate_failures do
        within_window second_window do
          visit board_path(board)

          expect(name_input.value).to eq('Old name')
        end

        update_name

        within_window second_window do
          expect(name_input.value).to eq(new_name)
        end
      end
    end

    def name_input
      find("input[data-list-target='name']")
    end
  end

  describe 'Position' do
    subject(:update_position) do
      list_1_element.drag_to(list_2_element)
      sleep 0.1 # wait for websocket
    end

    let(:board) { create(:board) }

    let!(:list_1) { create(:list, board: board, name: '1', position: 0) }
    let!(:list_2) { create(:list, board: board, name: '2', position: 1) }

    let(:list_1_element) { find_list_by_id(list_1.id) }
    let(:list_2_element) { find_list_by_id(list_2.id) }

    before { visit board_path(board) }

    it 'update lists positions param', :aggregate_failures do
      update_position

      current_list_1 = list_1.reload
      current_list_2 = list_2.reload

      expect(current_list_1.position).to eq(1)
      expect(current_list_2.position).to eq(0)
    end

    it 'update lists dom positions', :aggregate_failures do
      expect(list_1_element).to eq(find_list_by_index(0))
      expect(list_2_element).to eq(find_list_by_index(1))

      update_position

      expect(list_1_element).to eq(find_list_by_index(1))
      expect(list_2_element).to eq(find_list_by_index(0))
    end

    context 'with second widow open' do
      let(:second_window) { open_new_window }

      it 'update lists dom positions in the second window', :aggregate_failures do
        within_window second_window do
          visit board_path(board)

          list_1_element = find_list_by_id(list_1.id)
          list_2_element = find_list_by_id(list_2.id)

          expect(list_1_element).to eq(find_list_by_index(0))
          expect(list_2_element).to eq(find_list_by_index(1))
        end

        update_position

        within_window second_window do
          list_1_element = find_list_by_id(list_1.id)
          list_2_element = find_list_by_id(list_2.id)

          expect(list_1_element).to eq(find_list_by_index(1))
          expect(list_2_element).to eq(find_list_by_index(0))
        end
      end
    end

    def find_list_by_id(id)
      find("div[data-list-id-value='#{id}']")
    end

    def find_list_by_index(index)
      all("div[data-controller='list']")[index]
    end
  end
end
