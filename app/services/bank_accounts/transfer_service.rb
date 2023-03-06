# frozen_string_literal: true

module BankAccounts
  class TransferService < ApplicationService

    def process
      set_accounts
      validate_accounts
      validate_amount

      return if errors.present?


      ActiveRecord::Base.transaction do
        create_transactions
        change_balance
      end
    end

    private

    attr_reader :sender, :receiver, :amount, :incoming_transaction, :outgoing_transaction

    def set_accounts
      @sender = BankAccount.find_by(iban: params.delete(:sender_iban))
      @receiver = BankAccount.find_by(iban: params.delete(:receiver_iban))
    end

    def validate_amount
      @amount = BigDecimal(params[:amount])
      errors[:amount] = "Transfer amount should be positive" if amount <= 0
      errors[:amount] = "Balance can't be negative" if amount > sender.balance
    rescue StandardError
      errors[:amount] = "Amount is invalid"
    end

    def validate_accounts
      errors[:sender] = "Can't find sender with such IBAN" if sender.blank?
      errors[:receiver] = "Can't find receiver with such IBAN" if receiver.blank?
      errors[:receiver] = "Sender and receiver can't be the same" if receiver == sender && sender.present?
    end

    def create_transactions
      uuid = SecureRandom.uuid

      @incoming_transaction = receiver.transactions.create!(amount: amount, transaction_uuid: uuid)
      @outgoing_transaction = sender.transactions.create!(amount: -amount, transaction_uuid: uuid)
    end

    def change_balance
      sender.update!(balance: sender.balance - amount)
      receiver.update!(balance: receiver.balance + amount)
    end
  end
end
