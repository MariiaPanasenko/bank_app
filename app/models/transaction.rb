# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :bank_account

  validates :amount, presence: true
  validates :transaction_id, presence: true
  validates :bank_account_id, presence: true
end
