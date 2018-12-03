class AddResolvedToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :resolved, :boolean
  end
end
