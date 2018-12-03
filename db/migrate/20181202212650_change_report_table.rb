class ChangeReportTable < ActiveRecord::Migration[5.2]
  def change
    # remove_reference :reports, :offender, index: true, foreign_key: true
  end
end
