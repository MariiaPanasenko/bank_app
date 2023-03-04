# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction, type: :request do
  let(:base_url) { '/transactions' }
  let(:user) { create(:user) }

  context 'when default route' do
    it 'returns success' do
      sign_in(user)

      get "/"

      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
      expect(response).to render_template("index")
    end
  end

  context 'when GET transactions' do
    it 'returns success' do
      sign_in(user)

      get base_url

      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
      expect(response).to render_template("index")
    end
  end

  context 'when GET transactions/new' do
    it 'returns success' do
      sign_in(user)

      get "#{base_url}/new"

      expect(response).to have_http_status(:ok)
      expect(response).to be_successful
      expect(response).to render_template("new")
    end
  end

  context 'when POST transactions with valid params' do
    let!(:sender) { create(:user, :with_balance, balance: balance) }
    let!(:receiver) { create(:user) }
    let(:balance) { 1000 }
    let(:amount) { 55 }
    let(:sender_iban) { sender.bank_account.iban }
    let(:receiver_iban) { receiver.bank_account.iban }
    let(:params) { { iban: receiver_iban, amount: amount } }

    it 'returns redirects to transactions page with success' do
      sign_in(sender)

      post "#{base_url}", params: params
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to transactions_path
    end
  end

  context 'when POST transactions with invalid params' do
    let!(:sender) { create(:user, :with_balance, balance: balance) }
    let!(:receiver) { create(:user) }
    let(:balance) { 100 }
    let(:amount) { 550 }
    let(:sender_iban) { sender.bank_account.iban }
    let(:receiver_iban) { receiver.bank_account.iban }
    let(:params) { { iban: receiver_iban, amount: amount } }

    it 'returns redirects to new transactions page with error displayed' do
      sign_in(sender)

      post "#{base_url}", params: params
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to new_transaction_path
    end
  end
end
