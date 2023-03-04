# frozen_string_literal: true

class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :user_id, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :iban, presence: true, uniqueness: true

  before_validation :set_iban, on: :create

  private

  def set_iban
    self.iban ||= Faker::Bank.iban
  end
end
