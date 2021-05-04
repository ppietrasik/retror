require 'rails_helper'

describe 'Board/Lists/Cards -> Update' do
  describe 'Name' do
    subject(:update_note) do
      note_input_element = note_input

      note_input_element.double_click
      note_input_element.fill_in(with: new_note)
      note_input_element.send_keys(:tab)

      sleep 0.1 # wait for websocket
    end

    let(:list) { create(:list) }
    let!(:card) { create(:card, list: list, note: 'Old note') }

    let(:new_note) { 'Updated note' }

    before { visit board_path(list.board) }

    it 'update the card' do
      update_note

      current_card = card.reload
      expect(current_card).to have_attributes(note: new_note)
    end

    it "updates card's note in dom" do
      expect { update_note }.to change(note_input, :value).from('Old note').to(new_note)
    end

    context 'with second widow open' do
      let(:second_window) { open_new_window }

      it "updates cards's note in the second window's dom", :aggregate_failures do
        within_window second_window do
          visit board_path(list.board)

          expect(note_input.value).to eq('Old note')
        end

        update_note

        within_window second_window do
          expect(note_input.value).to eq(new_note)
        end
      end
    end

    def note_input
      find("textarea[data-card-target='note']")
    end
  end

  describe 'Position' do
    subject(:update_position) do
      card_1_list_1_element.drag_to(card_2_list_2_element)
      sleep 0.1 # wait for websocket
    end

    let(:board) { create(:board) }

    let(:list_1) { create(:list, board: board) }
    let(:list_2) { create(:list, board: board) }

    let!(:card_1_list_1) { create(:card, note: '1', list: list_1, position: 0) }
    let!(:card_1_list_2) { create(:card, note: '2', list: list_2, position: 0) }
    let!(:card_2_list_2) { create(:card, note: '3', list: list_2, position: 1) }

    let(:card_1_list_1_element) { find_card_by_id(card_1_list_1.id) }
    let(:card_1_list_2_element) { find_card_by_id(card_1_list_2.id) }
    let(:card_2_list_2_element) { find_card_by_id(card_2_list_2.id) }

    before { visit board_path(board) }

    it 'update cards positions param' do
      expect { update_position }.to(change { card_1_list_1.reload.position }.from(0).to(1)
        .and(change { card_2_list_2.reload.position }.from(1).to(2)
        .and(not_change { card_1_list_2.reload.position })))
    end

    it 'update card list_id param', :aggregate_failures do
      expect { update_position }.to change { card_1_list_1.reload.list }.from(list_1).to(list_2)
    end

    it 'update lists dom positions', :aggregate_failures do
      expect(card_1_list_1_element).to eq(find_card_by_index_in_list(0, list_1))
      expect(card_1_list_2_element).to eq(find_card_by_index_in_list(0, list_2))
      expect(card_2_list_2_element).to eq(find_card_by_index_in_list(1, list_2))

      update_position

      expect(card_1_list_1_element).to eq(find_card_by_index_in_list(1, list_2))
      expect(card_1_list_2_element).to eq(find_card_by_index_in_list(0, list_2))
      expect(card_2_list_2_element).to eq(find_card_by_index_in_list(2, list_2))
    end

    context 'with second widow open' do
      let(:second_window) { open_new_window }

      it 'update lists dom positions in the second window', :aggregate_failures do
        within_window second_window do
          visit board_path(board)

          card_1_list_1_element = find_card_by_id(card_1_list_1.id)
          card_1_list_2_element = find_card_by_id(card_1_list_2.id)
          card_2_list_2_element = find_card_by_id(card_2_list_2.id)

          expect(card_1_list_1_element).to eq(find_card_by_index_in_list(0, list_1))
          expect(card_1_list_2_element).to eq(find_card_by_index_in_list(0, list_2))
          expect(card_2_list_2_element).to eq(find_card_by_index_in_list(1, list_2))
        end

        update_position

        within_window second_window do
          card_1_list_1_element = find_card_by_id(card_1_list_1.id)
          card_1_list_2_element = find_card_by_id(card_1_list_2.id)
          card_2_list_2_element = find_card_by_id(card_2_list_2.id)

          expect(card_1_list_1_element).to eq(find_card_by_index_in_list(1, list_2))
          expect(card_1_list_2_element).to eq(find_card_by_index_in_list(0, list_2))
          expect(card_2_list_2_element).to eq(find_card_by_index_in_list(2, list_2))
        end
      end
    end

    def find_card_by_id(id)
      find("div[data-card-id-value='#{id}']")
    end

    def find_card_by_index_in_list(index, list)
      list_element = find("div[data-list-id-value='#{list.id}']")
      list_element.all("div[data-controller='card card-edit']")[index]
    end
  end
end
