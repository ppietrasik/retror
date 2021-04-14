# frozen_string_literal: true

describe 'Boards -> New' do
  let(:name) { 'My Board' }

  subject do
    visit new_board_path

    fill_in 'board[name]', with: name
    click_on 'Create'
  end

  it 'allows to creates new board' do
    expect { subject }.to change { Board.count }.from(0).to(1)

    expect(page).to have_text 'My Board'
    expect(page).to have_current_path(board_path(Board.first))
  end

  describe 'Validations' do
    context 'with name that exceeds maximum number of character' do
      let(:name) { 'a' * 33 }

      it 'displays correct error' do
        expect { subject }.not_to change { Board.count }
        expect(page).to have_text 'Name is too long (maximum is 32 characters)'
      end
    end
  end
end
