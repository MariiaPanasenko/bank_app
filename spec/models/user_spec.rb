# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:first_name).with_message('CAN_NOT_BE_BLANK') }
    it { is_expected.to validate_presence_of(:last_name).with_message('CAN_NOT_BE_BLANK') }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }

    it { is_expected.to allow_value('LoRemЮзерKuvićѐ진규@&(),/.+-_').for(:first_name) }
    it { is_expected.to allow_value('LoRemЮзерKuvićѐ진규@&(),/.+-_').for(:last_name) }
    it { is_expected.to allow_value('LoRemЮзерKuvićѐ진규@&(),/.+-_').for(:password) }
    it { is_expected.to allow_value('email@addresse.foo').for(:email) }
    it { is_expected.not_to allow_value('foo').for(:email) }
    it { is_expected.not_to allow_value('email..email@addresse.foo').for(:email) }

    it { expect { subject.save! }.to change(BankAccount, :count).by(1) }
  end
end
