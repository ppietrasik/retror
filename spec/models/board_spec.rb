require 'rails_helper'

RSpec.describe Board, type: :model do
  context 'Validation' do
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_length_of(:name).is_at_least(4).is_at_most(32) }
  end

  context 'DB' do
    it { is_expected.to have_many(:lists) }
    
    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end
end
