# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_one :bank_account, dependent: :destroy
  has_many :transactions, through: :bank_account

  validates :first_name, :last_name, :email, length: { maximum: 255 }
  validates :first_name, :last_name, presence: { message: "CAN_NOT_BE_BLANK" }
  validates :email, presence: true, email: true
  validates :first_name, :last_name,
            presence: { message: "CAN_NOT_BE_BLANK" },
            format: {
              with: /\A[\p{L}0-9 @&(),\/\-\.+_'\uAC00-\uD7AF]*\z/,
              message: "($!#^|[]\\%) are not allowed"
            }

  delegate :balance, to: :bank_account, allow_nil: true

  after_create_commit  :create_bank_account!
end
