# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :with_balance do
      transient do
        balance { 5000 }
      end
      after(:create) do |user, evaluator|
        user.bank_account.update!(balance: evaluator.balance)
      end
    end
  end
end
