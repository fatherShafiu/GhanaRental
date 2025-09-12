class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.references :rental_application, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :document_type
      t.text :file_data

      t.timestamps
    end
  end
end
