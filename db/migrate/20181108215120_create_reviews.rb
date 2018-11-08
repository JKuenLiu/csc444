class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :transaction, foreign_key: true
      t.string :comment
      t.integer :rating

      t.timestamps
    end
  end
end
