# frozen_string_literal: true

User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: 'test_email1@mail.com', password: 'password1')
User.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: 'test_email2@mail.com', password: 'password2')
User.all.find_each { |user| user.bank_account.update!(balance: 1000) }
