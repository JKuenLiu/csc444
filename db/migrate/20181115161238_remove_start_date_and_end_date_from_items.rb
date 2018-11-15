class RemoveStartDateAndEndDateFromItems < ActiveRecord::Migration[5.2]
  def change
      remove_column :items, :start_date, :date
      remove_column :items, :end_date, :date
  end
end
