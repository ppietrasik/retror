require 'rails_helper'

describe 'Boards -> New' do
  subject(:create) do
    visit new_board_path

    fill_in 'board[name]', with: name
    click_on 'Create'
  end

  let(:name) { 'My Board' }

  it 'allows to creates new board', :aggregate_failures do
    expect { create }.to change(Board, :count).from(0).to(1)

    expect(page).to have_text 'My Board'
    expect(page).to have_current_path(board_path(Board.first))
  end

  describe 'Validations' do
    context 'with name that exceeds maximum number of character' do
      let(:name) { 'a' * 33 }

      it 'displays correct error', :aggregate_failures do
        expect { create }.not_to change(Board, :count)
        expect(page).to have_text 'Name is too long (maximum is 32 characters)'
      end
    end
  end
end
