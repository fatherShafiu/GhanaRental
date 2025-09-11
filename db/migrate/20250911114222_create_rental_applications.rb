class CreateRentalApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :rental_applications do |t|
      t.references :property, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: { to_table: :users }  # Fix this line
      t.integer :status, default: 0
      t.text :message
      t.datetime :submitted_at

      t.timestamps
    end

    add_index :rental_applications, [ :property_id, :tenant_id ], unique: true
  end
end
