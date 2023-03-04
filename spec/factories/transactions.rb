# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    association :bank_account_id, factory: :bank_account

    amount { 300 }
  end
end
