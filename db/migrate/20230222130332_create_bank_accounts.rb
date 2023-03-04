class CreateBankAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :bank_accounts do |t|
      t.decimal :balance, default: 0
      t.references :user, foreign_key: true, null: false
      t.string "iban", null: false, index: { unique: true }

      t.timestamps
    end
  end
end
