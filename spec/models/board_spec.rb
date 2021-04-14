require 'rails_helper'

RSpec.describe Board, type: :model do
  describe 'Validation' do
    it { is_expected.to allow_value('').for(:name) }

    it { is_expected.to validate_length_of(:name).is_at_most(32) }
  end

  describe 'DB' do
    it { is_expected.to have_many(:lists).dependent(:destroy) }

    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end
end
