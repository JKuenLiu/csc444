class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :fname
      t.string :lname
      t.string :addr
      t.string :phone
      t.reference :user, foreign_key=true, index=true

      t.timestamps
    end
  end
end
