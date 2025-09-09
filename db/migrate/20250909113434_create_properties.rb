class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.references :landlord, null: false, foreign_key: { to_table: :users }
      t.string :title, null: false
      t.text :description, null: false
      t.string :property_type, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :bedrooms, default: 0
      t.integer :bathrooms, default: 0
      t.integer :square_feet
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.integer :status, default: 0
      t.boolean :featured, default: false
      t.date :available_from, null: false

      t.timestamps
    end

    add_index :properties, :status
    add_index :properties, :featured
    add_index :properties, :property_type
    add_index :properties, :city
    add_index :properties, :state
    add_index :properties, [ :latitude, :longitude ]
  end
end
