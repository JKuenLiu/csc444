class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :category
      t.string :status
      t.string :owner
      t.string :current_holder
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end

