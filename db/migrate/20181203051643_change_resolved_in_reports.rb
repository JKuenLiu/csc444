class ChangeResolvedInReports < ActiveRecord::Migration[5.2]
  def change
    change_column :reports, :resolved, :boolean, :default => false
  end
end
