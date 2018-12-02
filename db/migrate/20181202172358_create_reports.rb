class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :complaint
      t.integer :reporter
      t.reference :offender

      t.timestamps
    end
  end
end
