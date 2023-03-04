# frozen_string_literal: true

require 'spec_helper'

describe BankAccounts::TransferService do
  subject(:service) { described_class.call(params) }

  let!(:sender) { create(:user, :with_balance, balance: balance) }
  let!(:receiver) { create(:user) }
  let(:balance) { 1000 }
  let(:amount) { 55 }
  let(:sender_iban) { sender.bank_account.iban }
  let(:receiver_iban) { receiver.bank_account.iban }
  let(:params) do
    {
      sender_iban: sender_iban,
      receiver_iban: receiver_iban,
      amount: amount
    }
  end

  context 'with valid amount and iban' do
    it 'is successful' do
      service

      expect(service.success?).to be_truthy
      expect(Transaction.count).to eq(2)
      expect(sender.reload.balance).to eq(BigDecimal(balance - amount))
      expect(receiver.reload.balance).to eq(BigDecimal(amount))
    end
  end

  context 'with invalid amount' do
    context 'when negative amount' do
      let(:amount) { -100 }

      it 'is unsuccessful' do
        service

        expect(service.success?).to be_falsey
        expect(Transaction.count).to eq(0)
        expect(sender.reload.balance).to eq(BigDecimal(balance))
        expect(receiver.reload.balance).to eq(BigDecimal(0))
      end
    end

    context 'when string amount' do
      let(:amount) { "hundred" }

      it 'is unsuccessful' do
        service

        expect(service.success?).to be_falsey
        expect(Transaction.count).to eq(0)
        expect(sender.reload.balance).to eq(BigDecimal(balance))
        expect(receiver.reload.balance).to eq(BigDecimal(0))
      end
    end

    context 'when amount is zero' do
      let(:amount) { 0 }

      it 'is unsuccessful' do
        service

        expect(service.success?).to be_falsey
        expect(Transaction.count).to eq(0)
        expect(sender.reload.balance).to eq(BigDecimal(balance))
        expect(receiver.reload.balance).to eq(BigDecimal(0))
      end
    end

    context 'when amount is more than balance' do
      let(:amount) { balance + 1 }

      it 'is unsuccessful' do
        service

        expect(service.success?).to be_falsey
        expect(Transaction.count).to eq(0)
        expect(sender.reload.balance).to eq(BigDecimal(balance))
        expect(receiver.reload.balance).to eq(BigDecimal(0))
      end
    end
  end

  context 'with invalid iban' do
    context 'when wrong receiver iban' do
      let(:receiver_iban) { '123' }

      it 'is unsuccessful' do
        service

        expect(service.success?).to be_falsey
        expect(Transaction.count).to eq(0)
        expect(sender.reload.balance).to eq(BigDecimal(balance))
        expect(receiver.reload.balance).to eq(BigDecimal(0))
      end
    end

    context 'when receiver equal to sender' do
      let(:receiver_iban) { sender_iban }

      it 'is unsuccessful' do
        service

        expect(service.success?).to be_falsey
        expect(Transaction.count).to eq(0)
        expect(sender.reload.balance).to eq(BigDecimal(balance))
        expect(receiver.reload.balance).to eq(BigDecimal(0))
      end
    end
  end
end
