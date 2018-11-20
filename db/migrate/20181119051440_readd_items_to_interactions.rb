class ReaddItemsToInteractions < ActiveRecord::Migration[5.2]
  def change
      remove_reference :interactions, :item
      add_reference :interactions, :item, foreign_key: true
  end
end
