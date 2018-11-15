class AddStartandEndDateToTransactions < ActiveRecord::Migration[5.2]
  def change
      add_column :transactions, :start_date, :date
      add_column :transactions, :end_date, :date
  end
end
