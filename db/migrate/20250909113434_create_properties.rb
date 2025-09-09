class CreateProperties < ActiveRecord::Migration[8.0]
  def change
    create_table :properties do |t|
      t.references :landlord, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :property_type
      t.decimal :price
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :square_feet
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.decimal :latitude
      t.decimal :longitude
      t.integer :status
      t.boolean :featured
      t.date :available_from

      t.timestamps
    end
  end
end
