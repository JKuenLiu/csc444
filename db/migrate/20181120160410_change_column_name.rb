class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :reviews, :transaction_id, :interaction_id
  end
end
