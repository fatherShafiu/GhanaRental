class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :rental_application, null: false, foreign_key: true
      t.decimal :amount
      t.string :currency
      t.integer :status
      t.string :transaction_id
      t.text :momo_response

      t.timestamps
    end
  end
end
