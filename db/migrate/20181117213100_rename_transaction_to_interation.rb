class RenameTransactionToInteration < ActiveRecord::Migration[5.2]
  def change
      rename_table :transactions, :interactions
  end
end
