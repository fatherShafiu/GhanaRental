class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.text :date_of_birth
      t.text :bio
      t.string :avatar_data
      t.jsonb :preferences
      t.boolean :verified

      t.timestamps
    end
  end
end
