require 'rails_helper'

RSpec.describe Board, type: :model do
  it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: true) }
end
