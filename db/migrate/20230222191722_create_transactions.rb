class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :amount, null: false
      t.references :bank_account, foreign_key: true, null: false
      t.string :transaction_uuid, index: true, null: false

      t.timestamps
    end
  end
end
