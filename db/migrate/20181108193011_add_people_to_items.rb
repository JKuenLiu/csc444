class AddPeopleToItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :person, foreign_key: true
  end
end
