# frozen_string_literal: true

FactoryBot.define do
  factory :bank_account do
    association :user

    balance { 5000.00 }
  end
end
