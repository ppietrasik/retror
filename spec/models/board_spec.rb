require 'rails_helper'

RSpec.describe Board, type: :model do
  it { should validate_presence_of(:name) }

  it { should validate_length_of(:name).is_at_least(4).is_at_most(32) }

  it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
end
