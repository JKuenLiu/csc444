class ChangePeopleToPersonInReports < ActiveRecord::Migration[5.2]
  def change
    remove_reference :reports, :people, foreign_key: true
    add_reference :reports, :person, foreign_key: true
  end
end
