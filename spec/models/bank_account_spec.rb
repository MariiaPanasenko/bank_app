# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankAccount, type: :model do
  context 'validations' do
    subject { create(:bank_account) }

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_presence_of(:iban) }
    it { is_expected.to validate_uniqueness_of(:iban) }
    it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  end
end
