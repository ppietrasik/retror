require 'rails_helper'

RSpec.describe List, type: :model do
  describe 'Validation' do
    it { is_expected.to allow_value('').for(:name) }

    it { is_expected.to validate_length_of(:name).is_at_most(24) }
  end

  describe 'DB' do
    it { is_expected.to belong_to(:board) }

    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end
end
