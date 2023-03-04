# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :model do
  context 'validations' do
    subject { build(:transaction) }

    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:transaction_id) }
    it { is_expected.to validate_presence_of(:bank_account_id) }
  end
end
