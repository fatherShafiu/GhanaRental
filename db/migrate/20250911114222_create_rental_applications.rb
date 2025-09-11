class CreateRentalApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :rental_applications do |t|
      t.references :property, null: false, foreign_key: true
      t.references :tenant, null: false, foreign_key: true
      t.integer :status
      t.text :message
      t.datetime :submitted_at

      t.timestamps
    end
  end
end
