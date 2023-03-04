# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
  end

  def create
    service = BankAccounts::TransferService.call(sender_iban: current_user.bank_account.iban, receiver_iban: params[:iban], amount: params[:amount])
    if service.success?
      redirect_to transactions_path
    else
      redirect_to new_transaction_path, flash: service.errors
    end
  end
end
