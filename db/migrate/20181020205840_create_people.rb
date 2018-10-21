class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :fname
      t.string :lname
      t.string :addr
      t.string :phone

      t.timestamps
    end
  end
end
